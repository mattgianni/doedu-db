BEGIN;
CREATE TABLE pivot_scores_stats AS
SELECT 
    e.school_code,
    GREATEST(e.total_students_enrolled, m.total_students_enrolled) AS enrolled,
    e.total_students_tested AS total_tested_english,
    e.pct_std_exceeded AS pct_exceeded_english,
    e.pct_std_met_and_above AS pct_met_and_above_english,
    m.total_students_tested AS total_tested_math,
    m.pct_std_exceeded AS pct_exceeded_math,
    m.pct_std_met_and_above AS pct_met_and_above_math
FROM (
    -- English test data
    SELECT
        school_code,
        total_students_enrolled,
        total_students_tested,
        pct_std_exceeded,
        pct_std_met_and_above
    FROM 
        scores
    WHERE 
        type_id IN (7, 9) AND
        student_group_id = 1 AND -- All students
        grade = 13 AND
        test_id = 1 -- English
) e
JOIN (
    -- Math test data
    SELECT
        school_code,
        school_name,
        total_students_enrolled,
        total_students_tested,
        pct_std_exceeded,
        pct_std_met_and_above
    FROM 
        scores
    WHERE 
        type_id IN (7, 9) AND
        student_group_id = 1 AND -- All students
        grade = 13 AND
        test_id = 2 -- Math
) m ON e.school_code = m.school_code;

COMMIT;
CREATE INDEX ON pivot_scores_stats (school_code);

BEGIN;
CREATE TABLE pivot_demo_stats AS
SELECT 
    a.school_code, 
    a.enrolled, 
    b.disadvantaged, 
    c.elearners, 
    d.disabled,
    (b.disadvantaged::FLOAT / a.enrolled::FLOAT) AS pct_disadvantaged,
    (c.elearners::FLOAT / a.enrolled::FLOAT) AS pct_elearners,
    (d.disabled::FLOAT / a.enrolled::FLOAT) AS pct_disabled
FROM (
    -- enrolled
    SELECT
        school_code,
        MAX(total_students_enrolled) AS enrolled
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 1 -- all students
        AND grade = 13
    GROUP BY school_code
) a
JOIN (
    -- disadvantaged
    SELECT
        school_code,
        MAX(total_students_enrolled) AS disadvantaged
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 31 -- disadvantaged students
        AND grade = 13
    GROUP BY school_code
) b ON a.school_code = b.school_code
JOIN (
    -- ELearners
    SELECT
        school_code,
        MAX(total_students_enrolled) AS elearners
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 160 -- English learning students
        AND grade = 13
    GROUP BY school_code
) c ON a.school_code = c.school_code
JOIN (
    -- disabled
    SELECT
        school_code,
        MAX(total_students_enrolled) AS disabled
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 128 -- disabled students
        AND grade = 13
    GROUP BY school_code
) d ON a.school_code = d.school_code;

COMMIT;
CREATE INDEX ON pivot_scores_stats (school_code);

CREATE OR REPLACE VIEW pivot_stats AS
SELECT 
	c.district_code,
    a.school_code,
	c.school_name,
    a.enrolled,
    a.total_tested_english,
    a.pct_exceeded_english,
    a.pct_met_and_above_english,
    a.total_tested_math,
    a.pct_exceeded_math,
    a.pct_met_and_above_math,
    b.disadvantaged,
    b.elearners,
    b.disabled,
    b.pct_disadvantaged,
    b.pct_elearners,
    b.pct_disabled
FROM pivot_scores_stats a
JOIN pivot_demo_stats b ON a.school_code = b.school_code
JOIN entities c ON a.school_code = c.school_code;

-- summary graduation rate data
CREATE OR REPLACE VIEW grad_filtered AS
SELECT
	district_code,
	school_code,
	school_name,
	rate_reg_hs_grads,
	rate_met_uc_reqs,
	rate_merit,
	rate_dropout
FROM grads
WHERE
	agglevel = 'S' AND
	reporting_category = 'TA';