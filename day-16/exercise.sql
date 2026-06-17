-- Day 16: CROSS JOIN & Self Joins - Exercise Script
-- Exercise tables: medications (10 rows) + interactions (8 rows) + patient_prescriptions (20 rows)

DROP TABLE IF EXISTS patient_prescriptions;
DROP TABLE IF EXISTS interactions;
DROP TABLE IF EXISTS medications;

-- TABLE 1: medications
CREATE TABLE medications (
    med_id         SERIAL PRIMARY KEY,
    med_name       VARCHAR(80)  NOT NULL,
    med_class      VARCHAR(60)  NOT NULL,
    dosage_form    VARCHAR(40)  NOT NULL
);

-- TABLE 2: interactions
-- Each row records one known dangerous combination between two medications.
-- med_id_1 is always the lower ID (enforced by CHECK constraint).
CREATE TABLE interactions (
    interaction_id  SERIAL PRIMARY KEY,
    med_id_1        INTEGER NOT NULL REFERENCES medications(med_id),
    med_id_2        INTEGER NOT NULL REFERENCES medications(med_id),
    severity        VARCHAR(20) NOT NULL,
    effect          VARCHAR(200) NOT NULL,
    CHECK (med_id_1 < med_id_2)
);

-- TABLE 3: patient_prescriptions
-- One row per patient per medication. A patient on three drugs has three rows.
CREATE TABLE patient_prescriptions (
    prescription_id    SERIAL PRIMARY KEY,
    patient_name       VARCHAR(80)  NOT NULL,
    med_id             INTEGER NOT NULL REFERENCES medications(med_id),
    prescribed_date    DATE    NOT NULL,
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

-- ============================================
-- EXERCISES
-- ============================================
-- You are supporting Nneka, Head of Pharmacy Compliance at a hospital.
-- She asks: "I need to know which of our patients are currently on two drugs
-- that interact badly. Flag the dangerous combinations and tell me what to do."
--
-- You have three tables:
--   medications          - 10 drugs with their class and form
--   interactions         - 8 known dangerous drug pairs with severity and effect
--   patient_prescriptions - 20 prescriptions (one row per patient per drug)

-- Task 1: Generate All Drug Pairs
--
-- Part A: Use a CROSS JOIN on medications to produce every unique pair of
-- drugs (no self-pairs, no duplicates). Use the less-than trick (m1.med_id < m2.med_id)
-- to keep unique pairs only. Show drug_1, class_1, drug_2, class_2.
-- Expected: 45 rows.

-- Write your query here:


-- Part B: Extend Part A by adding an INNER JOIN to interactions to filter
-- to only the 8 known dangerous pairs. Add severity and effect columns.
-- Order by severity (High first, then Moderate, then Low).
-- Expected: 8 rows.

-- Write your query here:


-- Task 2: Find Patients on Multiple Medications
--
-- Self join patient_prescriptions to find every patient who is currently
-- prescribed more than one drug. Show patient_name, medication_1, medication_2,
-- doctor_1, and doctor_2 (the prescribing doctors for each drug).
-- Use pp1.med_id < pp2.med_id to avoid duplicate pairs.
-- Expected: 30 rows.

-- Write your query here:


-- Task 3: Flag Dangerous Combinations
--
-- Part A: Extend Task 2 by adding an INNER JOIN to interactions to keep
-- only patient-drug pairs where a known dangerous interaction exists.
-- Add severity and effect columns. Order by severity (High first), then patient_name.
-- Expected: 6 rows.

-- Write your query here:


-- Part B: Extend Part A by adding a recommended_action column using CASE:
--   'High'     -> 'STOP - immediate review'
--   'Moderate' -> 'MONITOR - schedule follow-up'
--   'Low'      -> 'NOTE - document in records'
-- Also add class_1 and class_2 columns.
-- Expected: 6 rows (same patients, one extra column).

-- Write your query here:
