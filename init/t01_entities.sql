-- County Code^District Code^School Code^Type ID^Filler^Test Year^County Name^District Name^School Name^Zip Code
CREATE TABLE IF NOT EXISTS entities (
    id SERIAL PRIMARY KEY,
    county_code VARCHAR(50),
    district_code VARCHAR(50),
    school_code VARCHAR(50),
    type_id INTEGER,
    filler TEXT,
    test_year INTEGER,
    county_name TEXT,
    district_name TEXT,
    school_name TEXT,
    zip_code VARCHAR(50)
);

COPY entities (
    county_code,
    district_code,
    school_code,
    type_id,
    filler,
    test_year,
    county_name,
    district_name,
    school_name,
    zip_code
)
FROM '/raw/entities.dat' DELIMITER '^' CSV NULL '' HEADER;

CREATE INDEX ON entities (district_code, type_id);
CREATE INDEX ON entities (district_code);
