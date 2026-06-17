-- ============================================
-- DAY 16 SOLUTIONS: CROSS JOIN & Self Joins
-- ============================================

-- Task 1a: All unique drug pairs (CROSS JOIN with less-than trick)
SELECT
    m1.med_name  AS drug_1,
    m1.med_class AS class_1,
    m2.med_name  AS drug_2,
    m2.med_class AS class_2
FROM medications m1
CROSS JOIN medications m2
WHERE m1.med_id < m2.med_id
ORDER BY m1.med_name, m2.med_name;

-- Task 1b: Known dangerous pairs only (CROSS JOIN + INNER JOIN to interactions)
SELECT
    m1.med_name  AS drug_1,
    m1.med_class AS class_1,
    m2.med_name  AS drug_2,
    m2.med_class AS class_2,
    i.severity,
    i.effect
FROM medications m1
CROSS JOIN medications m2
INNER JOIN interactions i
    ON m1.med_id = i.med_id_1
    AND m2.med_id = i.med_id_2
WHERE m1.med_id < m2.med_id
ORDER BY
    CASE i.severity
        WHEN 'High'     THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'Low'      THEN 3
    END;

-- Task 2: Patients on multiple medications (self join on patient_prescriptions)
SELECT
    pp1.patient_name,
    m1.med_name AS medication_1,
    m2.med_name AS medication_2,
    pp1.prescribing_doctor AS doctor_1,
    pp2.prescribing_doctor AS doctor_2
FROM patient_prescriptions pp1
INNER JOIN patient_prescriptions pp2
    ON pp1.patient_name = pp2.patient_name
    AND pp1.med_id < pp2.med_id
INNER JOIN medications m1 ON pp1.med_id = m1.med_id
INNER JOIN medications m2 ON pp2.med_id = m2.med_id
ORDER BY pp1.patient_name, m1.med_name;

-- Task 3a: Flag dangerous patient combinations (self join + filter to known interactions)
SELECT
    pp1.patient_name,
    m1.med_name AS drug_1,
    m2.med_name AS drug_2,
    i.severity,
    i.effect,
    pp1.prescribing_doctor AS doctor_1,
    pp2.prescribing_doctor AS doctor_2
FROM patient_prescriptions pp1
INNER JOIN patient_prescriptions pp2
    ON pp1.patient_name = pp2.patient_name
    AND pp1.med_id < pp2.med_id
INNER JOIN medications m1 ON pp1.med_id = m1.med_id
INNER JOIN medications m2 ON pp2.med_id = m2.med_id
INNER JOIN interactions i
    ON pp1.med_id = i.med_id_1
    AND pp2.med_id = i.med_id_2
ORDER BY
    CASE i.severity
        WHEN 'High'     THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'Low'      THEN 3
    END,
    pp1.patient_name;

-- Task 3b: Add recommended_action column (CASE on severity)
SELECT
    pp1.patient_name,
    m1.med_name  AS drug_1,
    m1.med_class AS class_1,
    m2.med_name  AS drug_2,
    m2.med_class AS class_2,
    i.severity,
    i.effect,
    pp1.prescribing_doctor AS doctor_1,
    pp2.prescribing_doctor AS doctor_2,
    CASE
        WHEN i.severity = 'High'
            THEN 'STOP - immediate review'
        WHEN i.severity = 'Moderate'
            THEN 'MONITOR - schedule follow-up'
        WHEN i.severity = 'Low'
            THEN 'NOTE - document in records'
    END AS recommended_action
FROM patient_prescriptions pp1
INNER JOIN patient_prescriptions pp2
    ON pp1.patient_name = pp2.patient_name
    AND pp1.med_id < pp2.med_id
INNER JOIN medications m1 ON pp1.med_id = m1.med_id
INNER JOIN medications m2 ON pp2.med_id = m2.med_id
INNER JOIN interactions i
    ON pp1.med_id = i.med_id_1
    AND pp2.med_id = i.med_id_2
ORDER BY
    CASE i.severity
        WHEN 'High'     THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'Low'      THEN 3
    END,
    pp1.patient_name;
