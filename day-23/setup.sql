-- Day 23: Window Functions (Part 2) - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

-- ============================================
-- DAY 23 SETUP: Monthly revenue + daily web metrics
-- ============================================
-- This creates time-series data for:
--   - Running totals with SUM() OVER (cumulative aggregation)
--   - Moving averages with frame clauses (ROWS BETWEEN)
--   - LAG/LEAD for month-over-month and day-over-day comparisons
--   - FIRST_VALUE/LAST_VALUE for period extremes
--   - QUALIFY concept demonstration (CTE workaround in PostgreSQL)

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS daily_web_metrics;
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
-- TABLE 2: daily_web_metrics
-- ============================================
-- Each row is one day's web traffic and conversion data
-- 92 days of data (Oct 2024 to Dec 2024)
-- Used for:
--   - Moving averages (7-day, 14-day)
--   - Day-over-day comparisons with LAG/LEAD
--   - FIRST_VALUE/LAST_VALUE across weekly windows

CREATE TABLE daily_web_metrics (
    metric_id       SERIAL PRIMARY KEY,
    metric_date     DATE            NOT NULL UNIQUE,
    page_views      INTEGER         NOT NULL,
    unique_visitors INTEGER         NOT NULL,
    signups         INTEGER         NOT NULL DEFAULT 0,
    conversion_rate NUMERIC(5, 2)   NOT NULL DEFAULT 0.00
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

-- ============================================
-- INSERT: 92 daily web metric records (01/10/2024 to 31/12/2024)
-- ============================================
-- Patterns built in:
--   - Weekday traffic higher than weekends (for moving average smoothing)
--   - Gradual growth trend across the quarter
--   - Black Friday spike on 29/11/2024
--   - Christmas dip in late December
--   - Enough variance for frame clause demonstrations

INSERT INTO daily_web_metrics
    (metric_date, page_views, unique_visitors, signups, conversion_rate)
VALUES
    -- October 2024
    ('2024-10-01', 12400, 4800, 42, 0.88),
    ('2024-10-02', 13100, 5100, 48, 0.94),
    ('2024-10-03', 12800, 4950, 45, 0.91),
    ('2024-10-04', 13500, 5200, 50, 0.96),
    ('2024-10-05',  8200, 3100, 22, 0.71),
    ('2024-10-06',  7800, 2900, 18, 0.62),
    ('2024-10-07', 13000, 5050, 47, 0.93),
    ('2024-10-08', 13400, 5150, 49, 0.95),
    ('2024-10-09', 12900, 5000, 46, 0.92),
    ('2024-10-10', 13800, 5300, 52, 0.98),
    ('2024-10-11', 14200, 5450, 55, 1.01),
    ('2024-10-12',  8500, 3200, 24, 0.75),
    ('2024-10-13',  8100, 3050, 20, 0.66),
    ('2024-10-14', 13600, 5250, 51, 0.97),
    ('2024-10-15', 14000, 5400, 54, 1.00),
    ('2024-10-16', 13300, 5120, 48, 0.94),
    ('2024-10-17', 14100, 5420, 53, 0.98),
    ('2024-10-18', 14500, 5550, 57, 1.03),
    ('2024-10-19',  8800, 3350, 26, 0.78),
    ('2024-10-20',  8400, 3180, 23, 0.72),
    ('2024-10-21', 14200, 5480, 56, 1.02),
    ('2024-10-22', 14600, 5600, 58, 1.04),
    ('2024-10-23', 13900, 5380, 53, 0.99),
    ('2024-10-24', 14800, 5680, 60, 1.06),
    ('2024-10-25', 15100, 5800, 62, 1.07),
    ('2024-10-26',  9200, 3500, 28, 0.80),
    ('2024-10-27',  8700, 3300, 25, 0.76),
    ('2024-10-28', 14700, 5650, 59, 1.04),
    ('2024-10-29', 15000, 5750, 61, 1.06),
    ('2024-10-30', 14400, 5520, 56, 1.01),
    ('2024-10-31', 15300, 5850, 63, 1.08),

    -- November 2024
    ('2024-11-01', 15500, 5950, 65, 1.09),
    ('2024-11-02',  9500, 3600, 30, 0.83),
    ('2024-11-03',  9100, 3450, 27, 0.78),
    ('2024-11-04', 15200, 5830, 63, 1.08),
    ('2024-11-05', 15700, 6020, 66, 1.10),
    ('2024-11-06', 15100, 5800, 62, 1.07),
    ('2024-11-07', 15900, 6100, 68, 1.11),
    ('2024-11-08', 16200, 6220, 70, 1.13),
    ('2024-11-09',  9800, 3720, 32, 0.86),
    ('2024-11-10',  9400, 3580, 29, 0.81),
    ('2024-11-11', 15800, 6060, 67, 1.11),
    ('2024-11-12', 16100, 6180, 69, 1.12),
    ('2024-11-13', 15600, 5980, 65, 1.09),
    ('2024-11-14', 16400, 6300, 72, 1.14),
    ('2024-11-15', 16800, 6450, 74, 1.15),
    ('2024-11-16', 10200, 3880, 34, 0.88),
    ('2024-11-17',  9700, 3700, 31, 0.84),
    ('2024-11-18', 16500, 6340, 73, 1.15),
    ('2024-11-19', 17000, 6520, 76, 1.17),
    ('2024-11-20', 16300, 6260, 71, 1.13),
    ('2024-11-21', 17200, 6600, 78, 1.18),
    ('2024-11-22', 17500, 6720, 80, 1.19),
    ('2024-11-23', 11000, 4200, 38, 0.90),
    ('2024-11-24', 10500, 4000, 35, 0.88),
    ('2024-11-25', 17800, 6830, 82, 1.20),
    ('2024-11-26', 18200, 6980, 85, 1.22),
    ('2024-11-27', 18500, 7100, 88, 1.24),
    ('2024-11-28', 19000, 7290, 92, 1.26),
    ('2024-11-29', 28500, 10950, 145, 1.32),
    ('2024-11-30', 15000, 5750, 60, 1.04),

    -- December 2024
    ('2024-12-01', 10000, 3800, 33, 0.87),
    ('2024-12-02', 17500, 6720, 78, 1.16),
    ('2024-12-03', 18000, 6900, 82, 1.19),
    ('2024-12-04', 17200, 6600, 76, 1.15),
    ('2024-12-05', 18300, 7020, 84, 1.20),
    ('2024-12-06', 18800, 7210, 88, 1.22),
    ('2024-12-07', 11500, 4380, 40, 0.91),
    ('2024-12-08', 10800, 4120, 36, 0.87),
    ('2024-12-09', 18500, 7100, 86, 1.21),
    ('2024-12-10', 19000, 7290, 90, 1.23),
    ('2024-12-11', 18200, 6980, 84, 1.20),
    ('2024-12-12', 19500, 7480, 94, 1.26),
    ('2024-12-13', 20000, 7670, 98, 1.28),
    ('2024-12-14', 12200, 4650, 44, 0.95),
    ('2024-12-15', 11500, 4380, 40, 0.91),
    ('2024-12-16', 19200, 7370, 92, 1.25),
    ('2024-12-17', 19800, 7600, 96, 1.26),
    ('2024-12-18', 18800, 7210, 88, 1.22),
    ('2024-12-19', 19000, 7290, 90, 1.23),
    ('2024-12-20', 18500, 7100, 85, 1.20),
    ('2024-12-21', 11000, 4200, 38, 0.90),
    ('2024-12-22', 10200, 3880, 34, 0.88),
    ('2024-12-23', 16000, 6140, 68, 1.11),
    ('2024-12-24', 12000, 4600, 42, 0.91),
    ('2024-12-25',  6500, 2480, 12, 0.48),
    ('2024-12-26',  8200, 3120, 20, 0.64),
    ('2024-12-27', 13500, 5180, 52, 0.99),
    ('2024-12-28', 10500, 4020, 36, 0.89),
    ('2024-12-29',  9800, 3740, 32, 0.86),
    ('2024-12-30', 14500, 5560, 58, 1.04),
    ('2024-12-31', 11000, 4200, 38, 0.90);

-- Quick validation: row counts for all tables
SELECT 'monthly_revenue' AS table_name, COUNT(*) AS row_count FROM monthly_revenue
UNION ALL
SELECT 'daily_web_metrics', COUNT(*) FROM daily_web_metrics;

-- Verify monthly revenue date range and department coverage
SELECT
    mr.department_name,
    MIN(mr.revenue_month) AS earliest_month,
    MAX(mr.revenue_month) AS latest_month,
    COUNT(*) AS months_of_data,
    SUM(mr.revenue_amount) AS total_revenue
FROM monthly_revenue mr
GROUP BY mr.department_name
ORDER BY total_revenue DESC;

-- Verify Black Friday spike in daily metrics
SELECT
    metric_date,
    page_views,
    unique_visitors,
    signups
FROM daily_web_metrics
WHERE metric_date = '2024-11-29';