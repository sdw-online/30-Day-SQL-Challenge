-- ============================================
-- DAY 18 SOLUTIONS: Normalisation and Denormalisation
-- ============================================

-- Explore: measure the redundancy
SELECT
    COUNT(*)                            AS total_rows,
    COUNT(DISTINCT household_ref)       AS unique_households,
    COUNT(DISTINCT person_name)         AS unique_people,
    COUNT(DISTINCT district)            AS unique_districts,
    COUNT(DISTINCT region)              AS unique_regions,
    COUNT(DISTINCT enumerator_name)     AS unique_enumerators
FROM census_raw;

-- ============================================
-- Task 1: Split into normalised tables
-- ============================================

-- census_regions - the 3NF fix (region_type depends on region, not the person)
CREATE TABLE census_regions (
    region       VARCHAR(80) PRIMARY KEY,
    region_type  VARCHAR(50)
);

-- census_households and census_persons - the 2NF fix (address stored once
-- per household, not once per person)
CREATE TABLE census_households (
    household_ref  VARCHAR(20) PRIMARY KEY,
    address_line   VARCHAR(200),
    district       VARCHAR(80),
    region         VARCHAR(80) REFERENCES census_regions(region),
    census_date    DATE
);

CREATE TABLE census_persons (
    person_id       SERIAL PRIMARY KEY,
    household_ref   VARCHAR(20) REFERENCES census_households(household_ref),
    person_name     VARCHAR(100) NOT NULL,
    relationship    VARCHAR(50),
    date_of_birth   DATE,
    gender          VARCHAR(20),
    occupation      VARCHAR(100),
    ethnicity       VARCHAR(80)
);

-- census_languages - a 1NF fix (one row per language)
CREATE TABLE census_languages (
    language_id   SERIAL PRIMARY KEY,
    person_id     INTEGER REFERENCES census_persons(person_id),
    language      VARCHAR(50) NOT NULL
);

-- census_enumerators and census_enumerator_phones - another 1NF fix
-- (one row per phone number)
CREATE TABLE census_enumerators (
    enumerator_name  VARCHAR(100) PRIMARY KEY,
    region           VARCHAR(80) REFERENCES census_regions(region)
);

CREATE TABLE census_enumerator_phones (
    phone_id          SERIAL PRIMARY KEY,
    enumerator_name   VARCHAR(100) REFERENCES census_enumerators(enumerator_name),
    phone_number      VARCHAR(20) NOT NULL
);

-- Migrate the data across, parents first, then children

-- Regions (DISTINCT - each region lands once). Expected: 4 rows.
INSERT INTO census_regions (region, region_type)
SELECT DISTINCT region, region_type
FROM census_raw;

-- Households (DISTINCT - one row per household). Expected: 9 rows.
INSERT INTO census_households (household_ref, address_line, district, region, census_date)
SELECT DISTINCT household_ref, address_line, district, region, census_date
FROM census_raw;

-- Persons (NO DISTINCT - all 20 people are real, separate rows). Expected: 20 rows.
INSERT INTO census_persons (household_ref, person_name, relationship, date_of_birth, gender, occupation, ethnicity)
SELECT household_ref, person_name, relationship, date_of_birth, gender, occupation, ethnicity
FROM census_raw;

-- Languages - split the comma-separated list into one row each. Expected: 34 rows.
INSERT INTO census_languages (person_id, language)
SELECT p.person_id, trim(lang)
FROM census_persons p
JOIN census_raw c
    ON c.household_ref = p.household_ref
   AND c.person_name   = p.person_name
CROSS JOIN LATERAL unnest(string_to_array(c.languages_spoken, ',')) AS lang;

-- Enumerators (DISTINCT). Expected: 4 rows.
INSERT INTO census_enumerators (enumerator_name, region)
SELECT DISTINCT enumerator_name, region
FROM census_raw
WHERE enumerator_name IS NOT NULL;

-- Enumerator phones - split the comma-separated list into one row each. Expected: 5 rows.
INSERT INTO census_enumerator_phones (enumerator_name, phone_number)
SELECT DISTINCT e.enumerator_name, trim(ph)
FROM census_enumerators e
JOIN census_raw c ON c.enumerator_name = e.enumerator_name
CROSS JOIN LATERAL unnest(string_to_array(c.enumerator_phone, ',')) AS ph;

-- Prove it all landed correctly
SELECT 'census_regions'           AS table_name, COUNT(*) AS row_count FROM census_regions
UNION ALL
SELECT 'census_households',        COUNT(*) FROM census_households
UNION ALL
SELECT 'census_persons',           COUNT(*) FROM census_persons
UNION ALL
SELECT 'census_languages',         COUNT(*) FROM census_languages
UNION ALL
SELECT 'census_enumerators',       COUNT(*) FROM census_enumerators
UNION ALL
SELECT 'census_enumerator_phones', COUNT(*) FROM census_enumerator_phones;

-- ============================================
-- Task 2: Reconstruct with a JOIN
-- ============================================
-- Expected: 20 rows.

SELECT
    p.person_name,
    p.relationship,
    p.occupation,
    h.address_line,
    h.district,
    r.region,
    r.region_type
FROM census_persons p
JOIN census_households h ON p.household_ref = h.household_ref
JOIN census_regions r    ON h.region = r.region
ORDER BY h.household_ref, p.person_name;

-- ============================================
-- Task 3: Denormalise for reporting, then compare (capstone)
-- ============================================

-- Reporting view - the denormalised layer the dashboard reads from.
-- The source of truth stays in the normalised tables above.
CREATE VIEW v_census_report AS
SELECT
    p.person_name,
    p.relationship,
    p.date_of_birth,
    p.gender,
    p.occupation,
    p.ethnicity,
    h.household_ref,
    h.address_line,
    h.district,
    r.region,
    r.region_type,
    h.census_date
FROM census_persons p
JOIN census_households h ON p.household_ref = h.household_ref
JOIN census_regions r    ON h.region = r.region;

-- Population per region via the view. Expected: 4 rows -
-- East 7, North 6, South 4, West 3.
SELECT
    region,
    region_type,
    COUNT(*) AS population
FROM v_census_report
GROUP BY region, region_type
ORDER BY population DESC;

-- Compare: the same count straight off the flat table - same numbers,
-- but the data underneath still has duplicated addresses and regions
-- on every row.
SELECT
    region,
    COUNT(*) AS population
FROM census_raw
GROUP BY region
ORDER BY population DESC;
