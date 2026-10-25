-- Day 23: Window Functions (Part 2) - Exercise Solutions
-- 30 Day SQL Challenge | Stephen | Data
--
-- Scenario: the Board-Ready Performance Report. Ruth, Head of Finance, needs to know
-- whether Engineering's bad November was the start of a decline or just one bad month.
--
-- Run setup.sql (or exercise.sql) first. Every query below reads monthly_revenue.
-- Try each task yourself before you read the answer.

-- =====================================================================
-- EXPLORE THE DATA
-- =====================================================================

-- Preview the table: expect 90 rows (5 departments x 18 months)
SELECT *
FROM monthly_revenue
ORDER BY
    department_id,
    revenue_month;

-- Which departments are in it?
SELECT DISTINCT
    department_id,
    department_name
FROM monthly_revenue
ORDER BY department_id;

-- =====================================================================
-- TASK 1: Month-over-month change for every department
-- =====================================================================

-- Step 1: LAG pulls last month's revenue onto the current row.
-- PARTITION BY department_id keeps each department in its own lane, so Sales
-- never borrows a number from Marketing.
SELECT
    mr.department_name,
    mr.revenue_month,
    mr.revenue_amount,
    LAG(mr.revenue_amount, 1) OVER (
        PARTITION BY mr.department_id
        ORDER BY mr.revenue_month
    ) AS prev_month
FROM monthly_revenue mr
WHERE mr.revenue_month >= '2024-07-01'
ORDER BY mr.department_id, mr.revenue_month;

-- Step 2: turn it into a change (in pounds and in percent).
-- NULLIF(..., 0) stops a divide-by-zero if a previous month were ever 0.
-- The first month of each department has no previous month, so its change is NULL.
SELECT
    mr.department_name,
    mr.revenue_month,
    mr.revenue_amount,
    mr.revenue_amount - LAG(mr.revenue_amount, 1) OVER (
        PARTITION BY mr.department_id
        ORDER BY mr.revenue_month
    ) AS abs_change,
    ROUND(
        (mr.revenue_amount - LAG(mr.revenue_amount, 1) OVER (
            PARTITION BY mr.department_id
            ORDER BY mr.revenue_month
        )) / NULLIF(LAG(mr.revenue_amount, 1) OVER (
            PARTITION BY mr.department_id
            ORDER BY mr.revenue_month
        ), 0) * 100,
        1
    ) AS pct_change
FROM monthly_revenue mr
WHERE mr.revenue_month >= '2024-07-01'
ORDER BY mr.department_id, mr.revenue_month;

-- =====================================================================
-- TASK 2: Year-to-date running total for each department
-- =====================================================================

-- SUM() OVER with an ORDER BY inside the brackets makes the total grow row by row.
-- PARTITION BY department_id restarts it from zero for each department.
-- Filtering to 2024 means "year to date" starts in January 2024.
SELECT
    mr.department_name,
    mr.revenue_month,
    mr.revenue_amount,
    SUM(mr.revenue_amount) OVER (
        PARTITION BY mr.department_id
        ORDER BY mr.revenue_month
    ) AS ytd_revenue
FROM monthly_revenue mr
WHERE mr.revenue_month >= '2024-01-01'
  AND mr.department_id IN (1, 2)
ORDER BY mr.department_id, mr.revenue_month;

-- =====================================================================
-- TASK 3: Smooth the trend and label it (the capstone)
-- =====================================================================

-- Step 1 lives in a CTE: a 3-month moving average per department.
-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW = this month and the two before it.
-- Step 2, the outer query, compares each moving average to the previous one with LAG
-- and labels the direction. A window function cannot be nested inside another window
-- function, which is why the average is built first and compared second.
WITH smoothed AS (
    SELECT
        mr.department_name,
        mr.department_id,
        mr.revenue_month,
        mr.revenue_amount,
        ROUND(
            AVG(mr.revenue_amount) OVER (
                PARTITION BY mr.department_id
                ORDER BY mr.revenue_month
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ), 2
        ) AS moving_avg_3m
    FROM monthly_revenue mr
    WHERE mr.revenue_month >= '2024-01-01'
)
SELECT
    department_name,
    revenue_month,
    revenue_amount,
    moving_avg_3m,
    CASE
        WHEN moving_avg_3m > LAG(moving_avg_3m, 1) OVER (
            PARTITION BY department_id
            ORDER BY revenue_month
        ) THEN 'Accelerating'
        WHEN moving_avg_3m < LAG(moving_avg_3m, 1) OVER (
            PARTITION BY department_id
            ORDER BY revenue_month
        ) THEN 'Decelerating'
        ELSE 'Stable'
    END AS trend_direction
FROM smoothed
WHERE department_id IN (1, 2)
ORDER BY department_id, revenue_month;

-- =====================================================================
-- TAKE IT FURTHER (the homework)
-- =====================================================================

-- FIRST_VALUE / LAST_VALUE: start and end of year per department.
-- LAST_VALUE needs the full frame (UNBOUNDED FOLLOWING) or it stops at the current row.
SELECT
    mr.department_name,
    mr.revenue_month,
    mr.revenue_amount,
    FIRST_VALUE(mr.revenue_amount) OVER (
        PARTITION BY mr.department_id
        ORDER BY mr.revenue_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_month_revenue,
    LAST_VALUE(mr.revenue_amount) OVER (
        PARTITION BY mr.department_id
        ORDER BY mr.revenue_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_month_revenue
FROM monthly_revenue mr
WHERE mr.revenue_month >= '2024-01-01'
ORDER BY mr.department_id, mr.revenue_month;

-- Top 2 months per department. PostgreSQL has no QUALIFY, so rank in a CTE and filter outside.
WITH ranked_months AS (
    SELECT
        mr.department_name,
        mr.department_id,
        mr.revenue_month,
        mr.revenue_amount,
        RANK() OVER (
            PARTITION BY mr.department_id
            ORDER BY mr.revenue_amount DESC
        ) AS dept_rank
    FROM monthly_revenue mr
)
SELECT
    department_name,
    revenue_month,
    revenue_amount,
    dept_rank
FROM ranked_months
WHERE dept_rank <= 2
ORDER BY department_id, dept_rank;
