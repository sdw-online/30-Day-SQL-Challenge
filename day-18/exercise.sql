-- Day 18: Normalisation and Denormalisation - Exercise Script
-- Exercise table: census_raw (20 rows)

DROP TABLE IF EXISTS census_raw;

-- TABLE: census_raw
-- National census data - one row per person, with household, address,
-- region, language and enumerator details all flattened onto every row.
CREATE TABLE census_raw (
    record_id         SERIAL PRIMARY KEY,
    household_ref     VARCHAR(20)  NOT NULL,
    address_line      VARCHAR(200),
    district          VARCHAR(80),
    region            VARCHAR(80),
    region_type       VARCHAR(50),
    person_name       VARCHAR(100) NOT NULL,
    relationship      VARCHAR(50),
    date_of_birth     DATE,
    gender            VARCHAR(20),
    occupation        VARCHAR(100),
    languages_spoken  VARCHAR(200),
    ethnicity         VARCHAR(80),
    census_date       DATE         NOT NULL DEFAULT '2025-03-15',
    enumerator_name   VARCHAR(100),
    enumerator_phone  VARCHAR(100)
);

-- ============================================
-- INSERT: 20 census records across 9 households
-- ============================================

INSERT INTO census_raw
    (household_ref, address_line, district, region, region_type, person_name, relationship, date_of_birth, gender, occupation, languages_spoken, ethnicity, census_date, enumerator_name, enumerator_phone)
VALUES
    ('HH-1001', '17 River Lane',     'Westfield',   'North Region',   'Urban',   'Rashid Osman',    'Head',      '1978-06-14', 'Male',   'Civil Engineer',     'English, Arabic',          'Arab',        '2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1001', '17 River Lane',     'Westfield',   'North Region',   'Urban',   'Omar Osman',      'Son',       '2005-09-22', 'Male',   'Student',            'English, Arabic',          'Arab',        '2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1001', '17 River Lane',     'Westfield',   'North Region',   'Urban',   'Layla Osman',     'Daughter',  '2008-03-11', 'Female', 'Student',            'English, Arabic, French',  'Arab',        '2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1002', '4 Hilltop Crescent','Eastbrook',   'North Region',   'Urban',   'Adil Farooq',     'Head',      '1985-01-30', 'Male',   'Pharmacist',         'English, Urdu',            'Pakistani',   '2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1002', '4 Hilltop Crescent','Eastbrook',   'North Region',   'Urban',   'Sana Farooq',     'Spouse',    '1987-04-18', 'Female', 'Dentist',            'English, Urdu, Punjabi',   'Pakistani',   '2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1003', '89 Station Road',   'Greendale',   'South Region',   'Rural',   'Cora Mitchell',   'Head',      '1970-11-05', 'Female', 'Retired Teacher',    'English',                  'White British','2025-03-15', 'James Hartley',  '+44 7700 900200'),
    ('HH-1003', '89 Station Road',   'Greendale',   'South Region',   'Rural',   'Derek Mitchell',  'Spouse',    '1968-08-19', 'Male',   'Retired Accountant', 'English',                  'White British','2025-03-15', 'James Hartley',  '+44 7700 900200'),
    ('HH-1004', '12 Market Square',  'Greendale',   'South Region',   'Rural',   'Priti Kapoor',    'Head',      '1992-07-25', 'Female', 'Software Developer', 'English, Hindi, Gujarati', 'Indian',      '2025-03-15', 'James Hartley',  '+44 7700 900200'),
    ('HH-1005', '6 Harbour View',    'Portside',    'East Region',    'Coastal', 'Toby Grant',      'Head',      '1983-02-14', 'Male',   'Fisherman',          'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1005', '6 Harbour View',    'Portside',    'East Region',    'Coastal', 'Elsie Grant',     'Spouse',    '1985-10-30', 'Female', 'Nurse',              'English, Welsh',           'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1005', '6 Harbour View',    'Portside',    'East Region',    'Coastal', 'Willow Grant',    'Daughter',  '2015-05-08', 'Female', 'Student',            'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1006', '33 Abbey Gardens',  'Oldtown',     'West Region',    'Urban',   'Kwesi Mensah',    'Head',      '1990-12-01', 'Male',   'Logistics Manager',  'English, Twi',             'Black African','2025-03-15', 'Helen Bradford',  '+44 7700 900400'),
    ('HH-1006', '33 Abbey Gardens',  'Oldtown',     'West Region',    'Urban',   'Akua Mensah',     'Spouse',    '1991-03-17', 'Female', 'Midwife',            'English, Twi',             'Black African','2025-03-15', 'Helen Bradford',  '+44 7700 900400'),
    ('HH-1006', '33 Abbey Gardens',  'Oldtown',     'West Region',    'Urban',   'Kobi Mensah',     'Son',       '2018-08-23', 'Male',   'N/A',                'English',                  'Black African','2025-03-15', 'Helen Bradford',  '+44 7700 900400'),
    ('HH-1007', '2 Chapel Lane',     'Eastbrook',   'North Region',   'Urban',   'Fern Atkinson',   'Head',      '1995-04-02', 'Female', 'Graphic Designer',   'English',                  'White British','2025-03-15', 'Farida Youssef', '+44 7700 900100, +44 7700 900101'),
    ('HH-1008', '55 Orchard Way',    'Portside',    'East Region',    'Coastal', 'Reuben Shaw',     'Head',      '1975-09-10', 'Male',   'Electrician',        'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1008', '55 Orchard Way',    'Portside',    'East Region',    'Coastal', 'Hannah Shaw',     'Spouse',    '1977-01-28', 'Female', 'Teaching Assistant',  'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1008', '55 Orchard Way',    'Portside',    'East Region',    'Coastal', 'Archie Shaw',     'Son',       '2010-06-15', 'Male',   'Student',            'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1008', '55 Orchard Way',    'Portside',    'East Region',    'Coastal', 'Bonnie Shaw',     'Daughter',  '2013-11-03', 'Female', 'Student',            'English',                  'White British','2025-03-15', 'Nadia Okoro',    '+44 7700 900300'),
    ('HH-1009', '10 Meadow Drive',   'Greendale',   'South Region',   'Rural',   'Yusuf Diallo',    'Head',      '1988-05-20', 'Male',   'Bus Driver',         'English, French, Wolof',   'Black African','2025-03-15', 'James Hartley',  '+44 7700 900200');

-- ============================================
-- EXERCISES
-- ============================================
-- You work on the data team at a national statistics office.
-- Amira, the Operations Lead for the census, needs the raw census data
-- restructured before the reporting deadline. Her brief:
--
--   "We need the census data restructured before the reporting deadline.
--    First - preview the raw data and tell me how bad the redundancy is.
--    Then split it into properly structured tables, prove the structure
--    works with a JOIN, and finally build a denormalised view for the
--    reporting dashboard so the team can see the difference in query
--    complexity."
--
-- You have one table: census_raw - 20 records across 9 households.

-- Explore: measure the redundancy
--
-- Before touching anything, measure how bad the redundancy is.
-- Compare the total row count against the count of DISTINCT households,
-- people, districts, regions and enumerators.
-- Expected: 20 rows, 9 households, 20 people, 5 districts, 4 regions, 4 enumerators.

-- Write your query here:


-- Task 1: Split Into Normalised Tables
--
-- Split census_raw into six focused tables, in an order that respects
-- foreign keys (parents before children):
--   census_regions            - one row per region, with its region_type
--                                (the 3NF fix - region_type depends on the
--                                region, not the person)
--   census_households          - one row per household, with its address,
--                                district and region
--   census_persons             - one row per person, linked to their
--                                household (the 2NF fix)
--   census_languages           - one row per language, split out of the
--                                comma-separated languages_spoken column
--                                (a 1NF fix)
--   census_enumerators         - one row per enumerator
--   census_enumerator_phones   - one row per phone number, split out of the
--                                comma-separated enumerator_phone column
--                                (another 1NF fix)
--
-- Use string_to_array() + unnest() to split the comma-separated columns.
-- Use DISTINCT when migrating facts that should land once (regions,
-- households, enumerators); skip DISTINCT for census_persons - all 20
-- people are real, separate rows.
-- Expected: 4 regions, 9 households, 20 persons, 34 languages,
-- 4 enumerators, 5 phone numbers.

-- Write your queries here:


-- Task 2: Reconstruct With a JOIN
--
-- Prove the normalised structure works. JOIN census_persons,
-- census_households and census_regions back together to reassemble the
-- full picture - person, household and region details pulled from three
-- separate tables.
-- Expected: 20 rows.

-- Write your query here:


-- Task 3: Denormalise for Reporting (Capstone)
--
-- Build a view called v_census_report that joins census_persons,
-- census_households and census_regions, so the reporting team can query
-- one view instead of writing the JOIN themselves every time.
-- Then use the view to find the population per region.
-- Expected: 4 rows - East 7, North 6, South 4, West 3.

-- Write your queries here:
