-- ============================================
-- DAY 10 EXERCISE: Clinic patient referrals
-- ============================================
-- A data analyst at a health organisation needs
-- to report on referral-to-appointment wait times.
-- Some patients are still waiting (appointment_date IS NULL).
-- Referrals span 2024-2025 with varied urgencies.

DROP TABLE IF EXISTS patient_referrals;

CREATE TABLE patient_referrals (
    referral_id       SERIAL PRIMARY KEY,
    patient_name      VARCHAR(100)    NOT NULL,
    patient_dob       DATE            NOT NULL,
    department        VARCHAR(50)     NOT NULL,
    referral_date     DATE            NOT NULL,
    appointment_date  DATE,
    urgency           VARCHAR(20)     NOT NULL,
    referring_source  VARCHAR(30)     NOT NULL
);

INSERT INTO patient_referrals
    (patient_name, patient_dob, department, referral_date, appointment_date, urgency, referring_source)
VALUES
    ('Ruby Walters',       '1974-03-18', 'Cardiology',     '2024-04-02', '2024-04-30', 'Urgent',    'GP'),
    ('Miles Buckley',      '1989-07-25', 'Orthopaedics',   '2024-05-15', '2024-08-20', 'Routine',   'GP'),
    ('Tara Brennan',       '1965-11-09', 'Dermatology',    '2024-06-22', '2024-07-18', 'Routine',   'Self-referral'),
    ('Hamza Siddiqui',     '1998-02-14', 'Neurology',      '2024-07-10', '2024-07-15', 'Emergency', 'A&E'),
    ('Fiona Kemp',         '1982-09-01', 'Physiotherapy',  '2024-08-05', '2024-09-12', 'Routine',   'GP'),
    ('Patrick Doyle',      '1956-05-30', 'Cardiology',     '2024-09-18', '2024-10-02', 'Urgent',    'Specialist'),
    ('Naomi Kirby',        '2002-01-22', 'Orthopaedics',   '2024-10-01', '2025-01-14', 'Routine',   'GP'),
    ('Gideon Asare',       '1970-08-17', 'Neurology',      '2024-11-12', '2024-11-20', 'Emergency', 'A&E'),
    ('Jenna Howell',       '1991-04-06', 'Dermatology',    '2024-12-03', '2025-02-10', 'Routine',   'Self-referral'),
    ('Warren Hart',        '1963-12-28', 'Physiotherapy',  '2025-01-08', '2025-02-15', 'Routine',   'GP'),
    ('Celia Dunn',         '1985-06-15', 'Cardiology',     '2025-01-22', '2025-02-05', 'Urgent',    'GP'),
    ('Imani Boateng',      '1977-10-03', 'Orthopaedics',   '2025-02-10', NULL,          'Routine',   'Specialist'),
    ('Rex Hammond',        '2000-03-29', 'Neurology',      '2025-03-01', '2025-03-04', 'Emergency', 'A&E'),
    ('Verity Payne',       '1958-07-11', 'Dermatology',    '2025-03-14', NULL,          'Routine',   'Self-referral'),
    ('Duncan Craig',       '1994-11-20', 'Physiotherapy',  '2025-04-02', NULL,          'Routine',   'GP'),
    ('Binta Diallo',       '1969-01-08', 'Cardiology',     '2025-04-18', NULL,          'Urgent',    'GP'),
    ('Hugo Spencer',       '2004-08-05', 'Orthopaedics',   '2025-05-06', NULL,          'Routine',   'Self-referral'),
    ('Lydia Booth',        '1981-02-27', 'Neurology',      '2025-06-12', '2025-06-14', 'Emergency', 'A&E'),
    ('Erik Lindqvist',     '1973-09-14', 'Physiotherapy',  '2025-07-01', NULL,          'Routine',   'Specialist'),
    ('Abigail Stone',      '1996-05-19', 'Dermatology',    '2025-08-10', NULL,          'Routine',   'GP');

-- Verify: Expected 20 rows
SELECT COUNT(*) AS total_referrals FROM patient_referrals;

-- Verify: Expected 7 patients still waiting
SELECT COUNT(*) AS still_waiting FROM patient_referrals WHERE appointment_date IS NULL;
