-- ============================================
-- DAY 10 SOLUTIONS: Date Functions & CAST
-- ============================================

-- Task 1: AGE since referral
SELECT
    patient_name,
    department,
    referral_date,
    AGE(CURRENT_DATE, referral_date) AS time_since_referral
FROM patient_referrals;

-- Task 2: Patients waiting 90+ days
SELECT
    patient_name,
    department,
    urgency,
    referral_date,
    appointment_date,
    COALESCE(appointment_date, CURRENT_DATE) - referral_date AS wait_days
FROM patient_referrals
WHERE COALESCE(appointment_date, CURRENT_DATE) - referral_date >= 90;

-- Task 3: Referrals per month
SELECT
    TO_CHAR(DATE_TRUNC('month', referral_date), 'Mon YYYY') AS month,
    COUNT(*) AS referral_count
FROM patient_referrals
GROUP BY DATE_TRUNC('month', referral_date)
ORDER BY DATE_TRUNC('month', referral_date);

-- Task 4: Group by quarter
SELECT
    EXTRACT(YEAR FROM referral_date)    AS year,
    EXTRACT(QUARTER FROM referral_date) AS quarter,
    COUNT(*)                            AS referral_count
FROM patient_referrals
GROUP BY EXTRACT(YEAR FROM referral_date), EXTRACT(QUARTER FROM referral_date)
ORDER BY year, quarter;

-- Task 5: Format dates for report
SELECT
    patient_name,
    department,
    TO_CHAR(referral_date, 'DD Mon YYYY')    AS referral_date_fmt,
    COALESCE(TO_CHAR(appointment_date, 'DD Mon YYYY'), 'Awaiting appointment') AS appointment_date_fmt,
    urgency
FROM patient_referrals;

-- Task 6: Full combined triage report
SELECT
    patient_name,
    department,
    urgency,
    COALESCE(appointment_date, CURRENT_DATE) - referral_date AS days_waited,
    CASE
        WHEN appointment_date IS NOT NULL THEN 'Seen'
        ELSE 'Waiting'
    END AS status
FROM patient_referrals
ORDER BY days_waited DESC;
