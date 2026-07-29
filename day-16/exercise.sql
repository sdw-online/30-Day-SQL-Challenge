-- Day 16: JOINs Part 2: CROSS and Self - Exercise Script
-- 30 Day SQL Challenge | Stephen | Data

-- ============================================
-- EXERCISE TABLES: Pharmaceutical drug interactions
-- ============================================

-- TABLE 1: medications
CREATE TABLE medications (
    med_id         SERIAL PRIMARY KEY,
    med_name       VARCHAR(80)  NOT NULL,
    med_class      VARCHAR(60)  NOT NULL,
    dosage_form    VARCHAR(40)  NOT NULL
);

-- TABLE 2: interactions
CREATE TABLE interactions (
    interaction_id  SERIAL PRIMARY KEY,
    med_id_1        INTEGER NOT NULL REFERENCES medications(med_id),
    med_id_2        INTEGER NOT NULL REFERENCES medications(med_id),
    severity        VARCHAR(20) NOT NULL,
    effect          VARCHAR(200) NOT NULL,
    CHECK (med_id_1 < med_id_2)
);

-- TABLE 3: patient_prescriptions
CREATE TABLE patient_prescriptions (
    prescription_id  SERIAL PRIMARY KEY,
    patient_name     VARCHAR(80)  NOT NULL,
    med_id           INTEGER NOT NULL REFERENCES medications(med_id),
    prescribed_date  DATE    NOT NULL,
    prescribing_doctor VARCHAR(80) NOT NULL
);

-- ============================================
-- INSERT: 10 medications
-- ============================================

INSERT INTO medications
    (med_name, med_class, dosage_form)
VALUES
    ('Warfarin',       'Anticoagulant',           'Tablet'),
    ('Aspirin',        'NSAID',                   'Tablet'),
    ('Lisinopril',     'ACE Inhibitor',           'Tablet'),
    ('Metformin',      'Antidiabetic',            'Tablet'),
    ('Amoxicillin',    'Antibiotic',              'Capsule'),
    ('Ibuprofen',      'NSAID',                   'Tablet'),
    ('Simvastatin',    'Statin',                  'Tablet'),
    ('Omeprazole',     'Proton Pump Inhibitor',   'Capsule'),
    ('Amlodipine',     'Calcium Channel Blocker', 'Tablet'),
    ('Ciprofloxacin',  'Antibiotic',              'Tablet');

-- ============================================
-- INSERT: 8 known drug interactions
-- ============================================

INSERT INTO interactions
    (med_id_1, med_id_2, severity, effect)
VALUES
    (1, 2,  'High',     'Increased bleeding risk - aspirin amplifies warfarin anticoagulant effect'),
    (1, 6,  'High',     'Increased bleeding risk - ibuprofen amplifies warfarin anticoagulant effect'),
    (1, 7,  'Moderate', 'Simvastatin may increase warfarin effect - monitor INR closely'),
    (2, 6,  'Moderate', 'Combined NSAIDs increase gastrointestinal bleeding risk'),
    (3, 4,  'Low',      'Minor risk of hypoglycaemia when combined - monitor blood sugar'),
    (3, 9,  'Low',      'May enhance blood pressure lowering effect - monitor BP'),
    (5, 10, 'Moderate', 'Combined antibiotics may reduce effectiveness of both'),
    (7, 8,  'Moderate', 'Omeprazole may increase simvastatin levels - risk of muscle damage');

-- ============================================
-- INSERT: 20 patient prescriptions
-- ============================================
-- Some patients are on multiple medications (creates self-join patterns)
-- Some combinations match known interactions (creates dangerous flags)

INSERT INTO patient_prescriptions
    (patient_name, med_id, prescribed_date, prescribing_doctor)
VALUES
    -- Kenji: on Warfarin + Aspirin (HIGH interaction)
    ('Kenji Hayashi',    1, '2025-01-10', 'Dr Aziz'),
    ('Kenji Hayashi',    2, '2025-02-05', 'Dr Singh'),

    -- Dalia: on Warfarin + Ibuprofen (HIGH interaction)
    ('Dalia Mansour',    1, '2025-01-15', 'Dr Aziz'),
    ('Dalia Mansour',    6, '2025-03-01', 'Dr Farrell'),

    -- Vikram: on Warfarin + Simvastatin (MODERATE interaction)
    ('Vikram Rao',       1, '2025-02-01', 'Dr Aziz'),
    ('Vikram Rao',       7, '2025-02-01', 'Dr Aziz'),

    -- Hana: on Lisinopril + Metformin (LOW interaction)
    ('Hana Eriksen',     3, '2025-01-20', 'Dr Singh'),
    ('Hana Eriksen',     4, '2025-01-20', 'Dr Singh'),

    -- Zahra: on Simvastatin + Omeprazole (MODERATE interaction)
    ('Zahra Haddad',     7, '2025-03-10', 'Dr Farrell'),
    ('Zahra Haddad',     8, '2025-03-10', 'Dr Farrell'),

    -- Additional patients with single or safe combinations
    ('Kenji Hayashi',    4, '2025-04-01', 'Dr Singh'),
    ('Dalia Mansour',    8, '2025-02-15', 'Dr Farrell'),
    ('Vikram Rao',       9, '2025-03-05', 'Dr Aziz'),
    ('Hana Eriksen',     9, '2025-02-10', 'Dr Singh'),
    ('Zahra Haddad',     5, '2025-04-05', 'Dr Farrell'),

    -- Patients with no interaction risk
    ('Kenji Hayashi',    5, '2025-05-01', 'Dr Singh'),
    ('Dalia Mansour',    4, '2025-04-20', 'Dr Aziz'),
    ('Vikram Rao',       5, '2025-04-15', 'Dr Farrell'),
    ('Hana Eriksen',     5, '2025-03-25', 'Dr Singh'),
    ('Zahra Haddad',     4, '2025-05-10', 'Dr Aziz');

SELECT COUNT(*) AS total_airports FROM airports;

SELECT COUNT(*) AS total_flights FROM flights;

SELECT COUNT(*) AS route_grid
FROM airports o
CROSS JOIN airports d;

SELECT COUNT(*) AS total_meds FROM medications;

SELECT COUNT(*) AS total_interactions FROM interactions;

SELECT COUNT(*) AS total_prescriptions FROM patient_prescriptions;
