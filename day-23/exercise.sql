-- Day 23: Window Functions (Part 2) - Exercise Script
-- 30 Day SQL Challenge | Stephen | Data
--
-- Creates ONLY the exercise table. If you have already run setup.sql you do
-- not need this file - setup.sql builds the teaching AND the exercise tables.
--
-- The exercise (the Board-Ready Performance Report) uses monthly_revenue:
-- 5 departments x 18 months (Jul 2023 to Dec 2024) = 90 rows.
--
-- WARNING: this script DROPs and rebuilds monthly_revenue in the PUBLIC schema.
-- Do not run against a live database without first confirming that is intended.

DROP TABLE IF EXISTS monthly_revenue;

-- ============================================
-- TABLE 1: monthly_revenue
-- ============================================
-- Each row is one department's revenue for a specific month
-- 18 months of data (Jul 2023 to Dec 2024) across 5 departments
-- Intentional patterns:
--   - Sales department has clear growth trend (for running totals)
--   - Engineering has a dip in Nov 2024 (for LAG/LEAD comparisons)
--   - Marketing has seasonal peaks in Q4 (for moving averages)

CREATE TABLE monthly_revenue (
    revenue_id      SERIAL PRIMARY KEY,
    department_id   INTEGER         NOT NULL,
    department_name VARCHAR(50)     NOT NULL,
    revenue_month   DATE            NOT NULL,
    revenue_amount  NUMERIC(12, 2)  NOT NULL,
    new_clients     INTEGER         NOT NULL DEFAULT 0,
    renewal_rate    NUMERIC(5, 2)   NOT NULL DEFAULT 0.00
);

-- ============================================
-- INSERT: 90 monthly revenue records (5 departments x 18 months)
-- ============================================
-- Date range: July 2023 to December 2024
-- Patterns built in:
--   Sales (dept 1): Steady upward trend -- good for cumulative running totals
--   Engineering (dept 2): Consulting revenue with a Nov 2024 dip
--   Marketing (dept 3): Seasonal Q4 peaks in both years
--   Customer Success (dept 4): Upsell revenue growing gradually
--   Data & Analytics (dept 5): Project-based, some flat months

INSERT INTO monthly_revenue
    (department_id, department_name, revenue_month, revenue_amount, new_clients, renewal_rate)
VALUES
    -- Sales department (department_id = 1) - 18 months
    (1, 'Sales', '2023-07-01',  145000.00,  8, 85.50),
    (1, 'Sales', '2023-08-01',  152000.00,  9, 86.20),
    (1, 'Sales', '2023-09-01',  148000.00,  7, 84.90),
    (1, 'Sales', '2023-10-01',  161000.00, 11, 87.30),
    (1, 'Sales', '2023-11-01',  175000.00, 13, 89.10),
    (1, 'Sales', '2023-12-01',  192000.00, 15, 91.40),
    (1, 'Sales', '2024-01-01',  158000.00, 10, 88.00),
    (1, 'Sales', '2024-02-01',  163000.00, 11, 88.50),
    (1, 'Sales', '2024-03-01',  171000.00, 12, 89.20),
    (1, 'Sales', '2024-04-01',  178000.00, 13, 89.80),
    (1, 'Sales', '2024-05-01',  185000.00, 14, 90.10),
    (1, 'Sales', '2024-06-01',  189000.00, 14, 90.50),
    (1, 'Sales', '2024-07-01',  195000.00, 15, 91.00),
    (1, 'Sales', '2024-08-01',  201000.00, 16, 91.30),
    (1, 'Sales', '2024-09-01',  198000.00, 15, 90.80),
    (1, 'Sales', '2024-10-01',  212000.00, 18, 92.10),
    (1, 'Sales', '2024-11-01',  225000.00, 20, 93.50),
    (1, 'Sales', '2024-12-01',  241000.00, 22, 94.80),

    -- Engineering department (department_id = 2) - 18 months
    (2, 'Engineering', '2023-07-01',   82000.00,  3, 78.00),
    (2, 'Engineering', '2023-08-01',   85000.00,  3, 79.20),
    (2, 'Engineering', '2023-09-01',   79000.00,  2, 77.50),
    (2, 'Engineering', '2023-10-01',   88000.00,  4, 80.10),
    (2, 'Engineering', '2023-11-01',   91000.00,  4, 81.00),
    (2, 'Engineering', '2023-12-01',   95000.00,  5, 82.30),
    (2, 'Engineering', '2024-01-01',   83000.00,  3, 79.50),
    (2, 'Engineering', '2024-02-01',   86000.00,  3, 80.00),
    (2, 'Engineering', '2024-03-01',   92000.00,  4, 81.20),
    (2, 'Engineering', '2024-04-01',   89000.00,  4, 80.60),
    (2, 'Engineering', '2024-05-01',   94000.00,  5, 81.80),
    (2, 'Engineering', '2024-06-01',   97000.00,  5, 82.50),
    (2, 'Engineering', '2024-07-01',  101000.00,  6, 83.00),
    (2, 'Engineering', '2024-08-01',  104000.00,  6, 83.50),
    (2, 'Engineering', '2024-09-01',  108000.00,  7, 84.10),
    (2, 'Engineering', '2024-10-01',  112000.00,  7, 84.80),
    (2, 'Engineering', '2024-11-01',   78000.00,  2, 76.00),
    (2, 'Engineering', '2024-12-01',  115000.00,  8, 85.20),

    -- Marketing department (department_id = 3) - 18 months
    (3, 'Marketing', '2023-07-01',   55000.00,  4, 72.00),
    (3, 'Marketing', '2023-08-01',   58000.00,  5, 73.10),
    (3, 'Marketing', '2023-09-01',   52000.00,  3, 71.00),
    (3, 'Marketing', '2023-10-01',   68000.00,  7, 76.50),
    (3, 'Marketing', '2023-11-01',   79000.00,  9, 80.20),
    (3, 'Marketing', '2023-12-01',   85000.00, 10, 82.00),
    (3, 'Marketing', '2024-01-01',   54000.00,  4, 71.50),
    (3, 'Marketing', '2024-02-01',   57000.00,  4, 72.80),
    (3, 'Marketing', '2024-03-01',   61000.00,  5, 74.00),
    (3, 'Marketing', '2024-04-01',   59000.00,  5, 73.50),
    (3, 'Marketing', '2024-05-01',   63000.00,  6, 75.00),
    (3, 'Marketing', '2024-06-01',   66000.00,  6, 75.80),
    (3, 'Marketing', '2024-07-01',   64000.00,  6, 75.20),
    (3, 'Marketing', '2024-08-01',   67000.00,  7, 76.00),
    (3, 'Marketing', '2024-09-01',   62000.00,  5, 74.50),
    (3, 'Marketing', '2024-10-01',   75000.00,  8, 78.50),
    (3, 'Marketing', '2024-11-01',   88000.00, 11, 82.80),
    (3, 'Marketing', '2024-12-01',   94000.00, 12, 84.00),

    -- Customer Success department (department_id = 4) - 18 months
    (4, 'Customer Success', '2023-07-01',   38000.00,  2, 82.00),
    (4, 'Customer Success', '2023-08-01',   40000.00,  3, 82.50),
    (4, 'Customer Success', '2023-09-01',   39000.00,  2, 81.80),
    (4, 'Customer Success', '2023-10-01',   42000.00,  3, 83.20),
    (4, 'Customer Success', '2023-11-01',   45000.00,  4, 84.50),
    (4, 'Customer Success', '2023-12-01',   48000.00,  4, 85.00),
    (4, 'Customer Success', '2024-01-01',   41000.00,  3, 83.00),
    (4, 'Customer Success', '2024-02-01',   43000.00,  3, 83.50),
    (4, 'Customer Success', '2024-03-01',   46000.00,  4, 84.30),
    (4, 'Customer Success', '2024-04-01',   44000.00,  3, 83.80),
    (4, 'Customer Success', '2024-05-01',   47000.00,  4, 84.60),
    (4, 'Customer Success', '2024-06-01',   49000.00,  4, 85.20),
    (4, 'Customer Success', '2024-07-01',   50000.00,  5, 85.50),
    (4, 'Customer Success', '2024-08-01',   52000.00,  5, 86.00),
    (4, 'Customer Success', '2024-09-01',   51000.00,  5, 85.70),
    (4, 'Customer Success', '2024-10-01',   54000.00,  6, 86.50),
    (4, 'Customer Success', '2024-11-01',   57000.00,  6, 87.20),
    (4, 'Customer Success', '2024-12-01',   60000.00,  7, 88.00),

    -- Data & Analytics department (department_id = 5) - 18 months
    (5, 'Data & Analytics', '2023-07-01',   32000.00,  2, 75.00),
    (5, 'Data & Analytics', '2023-08-01',   35000.00,  2, 76.20),
    (5, 'Data & Analytics', '2023-09-01',   33000.00,  2, 75.50),
    (5, 'Data & Analytics', '2023-10-01',   38000.00,  3, 77.80),
    (5, 'Data & Analytics', '2023-11-01',   41000.00,  3, 79.00),
    (5, 'Data & Analytics', '2023-12-01',   44000.00,  4, 80.50),
    (5, 'Data & Analytics', '2024-01-01',   34000.00,  2, 76.00),
    (5, 'Data & Analytics', '2024-02-01',   36000.00,  2, 76.50),
    (5, 'Data & Analytics', '2024-03-01',   39000.00,  3, 78.00),
    (5, 'Data & Analytics', '2024-04-01',   37000.00,  3, 77.20),
    (5, 'Data & Analytics', '2024-05-01',   40000.00,  3, 78.50),
    (5, 'Data & Analytics', '2024-06-01',   42000.00,  3, 79.30),
    (5, 'Data & Analytics', '2024-07-01',   43000.00,  4, 79.80),
    (5, 'Data & Analytics', '2024-08-01',   45000.00,  4, 80.50),
    (5, 'Data & Analytics', '2024-09-01',   44000.00,  3, 80.00),
    (5, 'Data & Analytics', '2024-10-01',   48000.00,  5, 81.50),
    (5, 'Data & Analytics', '2024-11-01',   51000.00,  5, 82.80),
    (5, 'Data & Analytics', '2024-12-01',   55000.00,  6, 84.00);


SELECT 'monthly_revenue' AS table_name, COUNT(*) AS row_count FROM monthly_revenue;
