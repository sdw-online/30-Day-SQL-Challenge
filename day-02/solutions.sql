-- ============================================
-- DAY 2 SOLUTIONS: SELECT & WHERE
-- ============================================

-- Q1: Select three columns
SELECT applicant_name, credit_score, requested_amount
FROM loan_applications;

-- Q2: Applications from London
SELECT *
FROM loan_applications
WHERE city = 'London';

-- Q3: High-risk: low credit + high amount
SELECT *
FROM loan_applications
WHERE credit_score < 650
  AND requested_amount > 50000;

-- Q4: London/Edinburgh, Home Improvement, Approved
SELECT *
FROM loan_applications
WHERE city IN ('London', 'Edinburgh')
  AND loan_purpose = 'Home Improvement'
  AND decision = 'Approved';

-- Q5: Self-employed with no decision (pending)
SELECT COUNT(*) AS pending_self_employed
FROM loan_applications
WHERE employment_type = 'Self-employed'
  AND decision IS NULL;

-- Q6: Requested more than double annual income
SELECT *
FROM loan_applications
WHERE requested_amount > annual_income * 2;

-- Q7: Urgent review - pending with low credit OR over-income requests
SELECT *
FROM loan_applications
WHERE decision IS NULL
  AND (credit_score < 600 OR requested_amount > annual_income);
