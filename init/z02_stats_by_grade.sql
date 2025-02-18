BEGIN;
CREATE TABLE pivot_scores_stats_bg AS
SELECT 
    e.school_code,
    e.grade,
    GREATEST(e.total_students_enrolled, m.total_students_enrolled) AS enrolled,
    e.total_students_tested AS total_tested_english,
    (e.pct_std_exceeded::FLOAT / 100::FLOAT) AS pct_exceeded_english,
    (e.pct_std_met_and_above::FLOAT / 100::FLOAT) AS pct_met_and_above_english,
    m.total_students_tested AS total_tested_math,
    (m.pct_std_exceeded::FLOAT / 100::FLOAT) AS pct_exceeded_math,
    (m.pct_std_met_and_above::FLOAT / 100::FLOAT) AS pct_met_and_above_math
FROM (
    -- English test data
    SELECT
        school_code,
        grade,
        total_students_enrolled,
        total_students_tested,
        pct_std_exceeded,
        pct_std_met_and_above
    FROM 
        scores
    WHERE 
        type_id IN (7, 9) AND
        student_group_id = 1 AND -- All students
        grade != 13 AND
        test_id = 1 -- English
) e
JOIN (
    -- Math test data
    SELECT
        school_code,
        grade,
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
        grade != 13 AND
        test_id = 2 -- Math
) m ON e.school_code = m.school_code AND e.grade = m.grade;

COMMIT;
CREATE INDEX ON pivot_scores_stats_bg (school_code);
CREATE INDEX ON pivot_scores_stats_bg (school_code, grade);

BEGIN;
CREATE TABLE pivot_demo_stats_bg AS
SELECT 
    a.school_code,
    a.grade,
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
        grade,
        MAX(total_students_enrolled) AS enrolled
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 1 -- all students
        AND grade != 13
    GROUP BY school_code, grade
) a
JOIN (
    -- disadvantaged
    SELECT
        school_code,
        grade,
        MAX(total_students_enrolled) AS disadvantaged
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 31 -- disadvantaged students
        AND grade != 13
    GROUP BY school_code, grade
) b ON a.school_code = b.school_code AND a.grade = b.grade
JOIN (
    -- ELearners
    SELECT
        school_code,
        grade,
        MAX(total_students_enrolled) AS elearners
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 160 -- English learning students
        AND grade != 13
    GROUP BY school_code, grade
) c ON a.school_code = c.school_code AND a.grade = c.grade
JOIN (
    -- disabled
    SELECT
        school_code,
        grade,
        MAX(total_students_enrolled) AS disabled
    FROM 
        scores
    WHERE 
        type_id IN (7, 9)
        AND student_group_id = 128 -- disabled students
        AND grade != 13
    GROUP BY school_code, grade
) d ON a.school_code = d.school_code AND a.grade = d.grade;

COMMIT;
CREATE INDEX ON pivot_demo_stats_bg (school_code);
CREATE INDEX ON pivot_demo_stats_bg (school_code, grade);

CREATE OR REPLACE VIEW pivot_stats_bg AS
SELECT 
	c.district_code,
    a.school_code,
	c.school_name,
    a.enrolled,
    a.grade,
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
FROM pivot_scores_stats_bg a
JOIN pivot_demo_stats_bg b ON a.school_code = b.school_code AND a.grade = b.grade
JOIN entities c ON a.school_code = c.school_code;
