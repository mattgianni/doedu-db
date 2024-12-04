BEGIN;

DROP TABLE IF EXISTS sfusd_english_scores;
DROP TABLE IF EXISTS sfusd_math_scores;

CREATE TABLE sfusd_english_scores AS
SELECT
    school_code,
	school_name,
    test_id,
    total_students_enrolled,
    total_students_tested,
    pct_std_exceeded,
    pct_std_met_and_above
FROM
    scores s
WHERE
    s.district_code = '68478' AND
    s.type_id BETWEEN 7 AND 9 AND
    s.student_group_id = 1 AND
    s.grade = 13 AND
    s.test_id = 1;

CREATE TABLE sfusd_math_scores AS
SELECT
    school_code,
	school_name,
    test_id,
    total_students_enrolled,
    total_students_tested,
    pct_std_exceeded,
    pct_std_met_and_above
FROM
    scores s
WHERE
    s.district_code = '68478' AND
    s.type_id BETWEEN 7 AND 9 AND
    s.student_group_id = 1 AND
    s.grade = 13 AND
    s.test_id = 2;

CREATE INDEX idx_english_scores_school_code ON sfusd_english_scores (school_code);
CREATE INDEX idx_math_scores_school_code ON sfusd_math_scores (school_code);

COMMIT;

-- Create the combined view
CREATE OR REPLACE VIEW sfusd_scores_combined AS
SELECT
    e.school_code,
    e.school_name,
    e.total_students_enrolled,
    e.total_students_tested AS english_total_students_tested,
    e.pct_std_exceeded AS english_pct_std_exceeded,
    e.pct_std_met_and_above AS english_pct_std_met_and_above,
    m.total_students_tested AS math_total_students_tested,
    m.pct_std_exceeded AS math_pct_std_exceeded,
    m.pct_std_met_and_above AS math_pct_std_met_and_above
FROM
    sfusd_english_scores e
JOIN
    sfusd_math_scores m
ON
    e.school_code = m.school_code;
