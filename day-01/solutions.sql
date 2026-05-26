-- ============================================
-- DAY 1 SOLUTIONS: Introduction to SQL
-- ============================================

-- Q1: Run a greeting query
SELECT 'Hello, SQL!' AS greeting;

-- Q2: Check your PostgreSQL version
SELECT version();

-- Q3: Count rows and columns in employees
SELECT * FROM employees;
-- 10 rows, 8 columns

-- Q4: Verify row count and list columns
SELECT COUNT(*) FROM employees;
-- Expected: 10 rows
-- Columns: employee_id (SERIAL), first_name (VARCHAR), last_name (VARCHAR),
-- email (VARCHAR), department (VARCHAR), job_title (VARCHAR),
-- salary (INTEGER), hire_date (DATE), is_active (BOOLEAN)

-- Q5: Why INTEGER for salary, not TEXT?
-- INTEGER allows mathematical operations: sorting, summing, averaging.
-- TEXT sorts alphabetically, so '9000' would come after '80000'.
-- You cannot do arithmetic on text values without casting.

-- Q6: What does PRIMARY KEY enforce?
-- 1. UNIQUE - every value must be different (no duplicates)
-- 2. NOT NULL - the column cannot be empty
-- Using first_name as PK would fail if two employees share the same
-- first name - the second INSERT would be rejected as a duplicate.
