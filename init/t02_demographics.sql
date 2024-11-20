-- Demographic ID^Demographic ID Num^Demographic Name^Student Group
CREATE TABLE IF NOT EXISTS demographics (
    id SERIAL PRIMARY KEY,
    demographic_id VARCHAR(50),
    demographic_num INTEGER,
    demographic_name VARCHAR(100),
    student_group VARCHAR(100)
);

COPY demographics (
    demographic_id,
    demographic_num,
    demographic_name,
    student_group
)
FROM '/raw/demographics.dat' DELIMITER '^' CSV NULL '' HEADER;

CREATE INDEX ON demographics (demographic_id);
CREATE INDEX ON demographics (demographic_num);
