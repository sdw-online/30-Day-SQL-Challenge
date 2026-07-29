-- Day 18: Normalisation and Denormalisation - Exercise Script
-- 30 Day SQL Challenge | Stephen | Data

DROP TABLE IF EXISTS census_raw;

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

SELECT * FROM census_raw LIMIT 5;

SELECT COUNT(*) AS total_rows FROM song_plays;

SELECT
    COUNT(DISTINCT song_title)   AS unique_songs,
    COUNT(DISTINCT artist)       AS unique_artists,
    COUNT(DISTINCT album)        AS unique_albums,
    COUNT(DISTINCT release_year) AS unique_years
FROM song_plays;

SELECT COUNT(*) AS total_records FROM census_raw;

SELECT
    household_ref,
    COUNT(*) AS people_count
FROM census_raw
GROUP BY household_ref
ORDER BY household_ref;

SELECT playlist_name, song_title, artist, album, release_year
FROM song_plays
WHERE album = 'Thriller'
ORDER BY playlist_name, position;
