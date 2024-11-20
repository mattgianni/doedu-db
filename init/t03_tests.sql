-- Test ID^Test ID Num^Test Name
CREATE TABLE IF NOT EXISTS tests (
    id SERIAL PRIMARY KEY,
    tests_id VARCHAR(50),
    tests_num INTEGER,
    tests_name VARCHAR(100)
);

COPY tests (
    tests_id,
    tests_num,
    tests_name
)
FROM '/raw/tests.dat' DELIMITER '^' CSV NULL '' HEADER;

CREATE INDEX ON tests (tests_id);
CREATE INDEX ON tests (tests_num);
