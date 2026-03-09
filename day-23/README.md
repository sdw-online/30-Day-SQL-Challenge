# Day 23 - Window Functions Part 2: LAG, LEAD & Running Totals

[Watch the video](COMING_SOON) | [← Day 22: Window Functions Part 1](../day-22/) | [Day 24: SCD Types & MERGE →](../day-24/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to build running totals with SUM() OVER and cumulative aggregation
- How frame clauses (ROWS BETWEEN) power moving averages that smooth out noise
- How LAG and LEAD let you compare each row to its previous or next row for period-over-period analysis
- How FIRST_VALUE and LAST_VALUE anchor comparisons to fixed reference points

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Day 22 (comfortable with ROW_NUMBER, RANK, DENSE_RANK, NTILE, PARTITION BY, OVER clause)
- **Day 22's tables must still be in your database** (`departments`, `employees`, `quarterly_sales`) - Day 23 reuses them and adds new tables on top

## Dataset

Today's lesson reuses the `departments`, `employees`, and `quarterly_sales` tables from Day 22 and adds two new time-series tables: monthly revenue by department and daily web metrics.

First, verify Day 22's tables still exist:

```sql
SELECT 'departments' AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'quarterly_sales', COUNT(*) FROM quarterly_sales;

-- Expected: departments = 5, employees = 25, quarterly_sales = 60
```

If those tables are missing, go back to the [Day 22 setup](../day-22/) and run it first.

Then run this SQL in pgAdmin to create today's new tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS daily_web_metrics;
DROP TABLE IF EXISTS monthly_revenue;

-- TABLE 1: monthly_revenue
CREATE TABLE monthly_revenue (
    revenue_id      SERIAL PRIMARY KEY,
    department_id   INTEGER         NOT NULL REFERENCES departments(department_id),
    revenue_month   DATE            NOT NULL,
    revenue_amount  NUMERIC(12, 2)  NOT NULL,
    new_clients     INTEGER         NOT NULL DEFAULT 0,
    renewal_rate    NUMERIC(5, 2)   NOT NULL DEFAULT 0.00
);

-- TABLE 2: daily_web_metrics
CREATE TABLE daily_web_metrics (
    metric_id       SERIAL PRIMARY KEY,
    metric_date     DATE            NOT NULL UNIQUE,
    page_views      INTEGER         NOT NULL,
    unique_visitors INTEGER         NOT NULL,
    signups         INTEGER         NOT NULL DEFAULT 0,
    conversion_rate NUMERIC(5, 2)   NOT NULL DEFAULT 0.00
);

-- INSERT: 90 monthly revenue records (5 departments x 18 months)
INSERT INTO monthly_revenue (department_id, revenue_month, revenue_amount, new_clients, renewal_rate)
VALUES
    (1, '2023-07-01', 145000.00,  8, 85.50), (1, '2023-08-01', 152000.00,  9, 86.20),
    (1, '2023-09-01', 148000.00,  7, 84.90), (1, '2023-10-01', 161000.00, 11, 87.30),
    (1, '2023-11-01', 175000.00, 13, 89.10), (1, '2023-12-01', 192000.00, 15, 91.40),
    (1, '2024-01-01', 158000.00, 10, 88.00), (1, '2024-02-01', 163000.00, 11, 88.50),
    (1, '2024-03-01', 171000.00, 12, 89.20), (1, '2024-04-01', 178000.00, 13, 89.80),
    (1, '2024-05-01', 185000.00, 14, 90.10), (1, '2024-06-01', 189000.00, 14, 90.50),
    (1, '2024-07-01', 195000.00, 15, 91.00), (1, '2024-08-01', 201000.00, 16, 91.30),
    (1, '2024-09-01', 198000.00, 15, 90.80), (1, '2024-10-01', 212000.00, 18, 92.10),
    (1, '2024-11-01', 225000.00, 20, 93.50), (1, '2024-12-01', 241000.00, 22, 94.80),
    (2, '2023-07-01',  82000.00,  3, 78.00), (2, '2023-08-01',  85000.00,  3, 79.20),
    (2, '2023-09-01',  79000.00,  2, 77.50), (2, '2023-10-01',  88000.00,  4, 80.10),
    (2, '2023-11-01',  91000.00,  4, 81.00), (2, '2023-12-01',  95000.00,  5, 82.30),
    (2, '2024-01-01',  83000.00,  3, 79.50), (2, '2024-02-01',  86000.00,  3, 80.00),
    (2, '2024-03-01',  92000.00,  4, 81.20), (2, '2024-04-01',  89000.00,  4, 80.60),
    (2, '2024-05-01',  94000.00,  5, 81.80), (2, '2024-06-01',  97000.00,  5, 82.50),
    (2, '2024-07-01', 101000.00,  6, 83.00), (2, '2024-08-01', 104000.00,  6, 83.50),
    (2, '2024-09-01', 108000.00,  7, 84.10), (2, '2024-10-01', 112000.00,  7, 84.80),
    (2, '2024-11-01',  78000.00,  2, 76.00), (2, '2024-12-01', 115000.00,  8, 85.20),
    (3, '2023-07-01',  55000.00,  4, 72.00), (3, '2023-08-01',  58000.00,  5, 73.10),
    (3, '2023-09-01',  52000.00,  3, 71.00), (3, '2023-10-01',  68000.00,  7, 76.50),
    (3, '2023-11-01',  79000.00,  9, 80.20), (3, '2023-12-01',  85000.00, 10, 82.00),
    (3, '2024-01-01',  54000.00,  4, 71.50), (3, '2024-02-01',  57000.00,  4, 72.80),
    (3, '2024-03-01',  61000.00,  5, 74.00), (3, '2024-04-01',  59000.00,  5, 73.50),
    (3, '2024-05-01',  63000.00,  6, 75.00), (3, '2024-06-01',  66000.00,  6, 75.80),
    (3, '2024-07-01',  64000.00,  6, 75.20), (3, '2024-08-01',  67000.00,  7, 76.00),
    (3, '2024-09-01',  62000.00,  5, 74.50), (3, '2024-10-01',  75000.00,  8, 78.50),
    (3, '2024-11-01',  88000.00, 11, 82.80), (3, '2024-12-01',  94000.00, 12, 84.00),
    (4, '2023-07-01',  38000.00,  2, 82.00), (4, '2023-08-01',  40000.00,  3, 82.50),
    (4, '2023-09-01',  39000.00,  2, 81.80), (4, '2023-10-01',  42000.00,  3, 83.20),
    (4, '2023-11-01',  45000.00,  4, 84.50), (4, '2023-12-01',  48000.00,  4, 85.00),
    (4, '2024-01-01',  41000.00,  3, 83.00), (4, '2024-02-01',  43000.00,  3, 83.50),
    (4, '2024-03-01',  46000.00,  4, 84.30), (4, '2024-04-01',  44000.00,  3, 83.80),
    (4, '2024-05-01',  47000.00,  4, 84.60), (4, '2024-06-01',  49000.00,  4, 85.20),
    (4, '2024-07-01',  50000.00,  5, 85.50), (4, '2024-08-01',  52000.00,  5, 86.00),
    (4, '2024-09-01',  51000.00,  5, 85.70), (4, '2024-10-01',  54000.00,  6, 86.50),
    (4, '2024-11-01',  57000.00,  6, 87.20), (4, '2024-12-01',  60000.00,  7, 88.00),
    (5, '2023-07-01',  32000.00,  2, 75.00), (5, '2023-08-01',  35000.00,  2, 76.20),
    (5, '2023-09-01',  33000.00,  2, 75.50), (5, '2023-10-01',  38000.00,  3, 77.80),
    (5, '2023-11-01',  41000.00,  3, 79.00), (5, '2023-12-01',  44000.00,  4, 80.50),
    (5, '2024-01-01',  34000.00,  2, 76.00), (5, '2024-02-01',  36000.00,  2, 76.50),
    (5, '2024-03-01',  39000.00,  3, 78.00), (5, '2024-04-01',  37000.00,  3, 77.20),
    (5, '2024-05-01',  40000.00,  3, 78.50), (5, '2024-06-01',  42000.00,  3, 79.30),
    (5, '2024-07-01',  43000.00,  4, 79.80), (5, '2024-08-01',  45000.00,  4, 80.50),
    (5, '2024-09-01',  44000.00,  3, 80.00), (5, '2024-10-01',  48000.00,  5, 81.50),
    (5, '2024-11-01',  51000.00,  5, 82.80), (5, '2024-12-01',  55000.00,  6, 84.00);

-- INSERT: 92 daily web metric records (Oct-Dec 2024)
INSERT INTO daily_web_metrics (metric_date, page_views, unique_visitors, signups, conversion_rate)
VALUES
    ('2024-10-01', 12400, 4800, 42, 0.88), ('2024-10-02', 13100, 5100, 48, 0.94),
    ('2024-10-03', 12800, 4950, 45, 0.91), ('2024-10-04', 13500, 5200, 50, 0.96),
    ('2024-10-05',  8200, 3100, 22, 0.71), ('2024-10-06',  7800, 2900, 18, 0.62),
    ('2024-10-07', 13000, 5050, 47, 0.93), ('2024-10-08', 13400, 5150, 49, 0.95),
    ('2024-10-09', 12900, 5000, 46, 0.92), ('2024-10-10', 13800, 5300, 52, 0.98),
    ('2024-10-11', 14200, 5450, 55, 1.01), ('2024-10-12',  8500, 3200, 24, 0.75),
    ('2024-10-13',  8100, 3050, 20, 0.66), ('2024-10-14', 13600, 5250, 51, 0.97),
    ('2024-10-15', 14000, 5400, 54, 1.00), ('2024-10-16', 13300, 5120, 48, 0.94),
    ('2024-10-17', 14100, 5420, 53, 0.98), ('2024-10-18', 14500, 5550, 57, 1.03),
    ('2024-10-19',  8800, 3350, 26, 0.78), ('2024-10-20',  8400, 3180, 23, 0.72),
    ('2024-10-21', 14200, 5480, 56, 1.02), ('2024-10-22', 14600, 5600, 58, 1.04),
    ('2024-10-23', 13900, 5380, 53, 0.99), ('2024-10-24', 14800, 5680, 60, 1.06),
    ('2024-10-25', 15100, 5800, 62, 1.07), ('2024-10-26',  9200, 3500, 28, 0.80),
    ('2024-10-27',  8700, 3300, 25, 0.76), ('2024-10-28', 14700, 5650, 59, 1.04),
    ('2024-10-29', 15000, 5750, 61, 1.06), ('2024-10-30', 14400, 5520, 56, 1.01),
    ('2024-10-31', 15300, 5850, 63, 1.08),
    ('2024-11-01', 15500, 5950, 65, 1.09), ('2024-11-02',  9500, 3600, 30, 0.83),
    ('2024-11-03',  9100, 3450, 27, 0.78), ('2024-11-04', 15200, 5830, 63, 1.08),
    ('2024-11-05', 15700, 6020, 66, 1.10), ('2024-11-06', 15100, 5800, 62, 1.07),
    ('2024-11-07', 15900, 6100, 68, 1.11), ('2024-11-08', 16200, 6220, 70, 1.13),
    ('2024-11-09',  9800, 3720, 32, 0.86), ('2024-11-10',  9400, 3580, 29, 0.81),
    ('2024-11-11', 15800, 6060, 67, 1.11), ('2024-11-12', 16100, 6180, 69, 1.12),
    ('2024-11-13', 15600, 5980, 65, 1.09), ('2024-11-14', 16400, 6300, 72, 1.14),
    ('2024-11-15', 16800, 6450, 74, 1.15), ('2024-11-16', 10200, 3880, 34, 0.88),
    ('2024-11-17',  9700, 3700, 31, 0.84), ('2024-11-18', 16500, 6340, 73, 1.15),
    ('2024-11-19', 17000, 6520, 76, 1.17), ('2024-11-20', 16300, 6260, 71, 1.13),
    ('2024-11-21', 17200, 6600, 78, 1.18), ('2024-11-22', 17500, 6720, 80, 1.19),
    ('2024-11-23', 11000, 4200, 38, 0.90), ('2024-11-24', 10500, 4000, 35, 0.88),
    ('2024-11-25', 17800, 6830, 82, 1.20), ('2024-11-26', 18200, 6980, 85, 1.22),
    ('2024-11-27', 18500, 7100, 88, 1.24), ('2024-11-28', 19000, 7290, 92, 1.26),
    ('2024-11-29', 28500, 10950, 145, 1.32), ('2024-11-30', 15000, 5750, 60, 1.04),
    ('2024-12-01', 10000, 3800, 33, 0.87), ('2024-12-02', 17500, 6720, 78, 1.16),
    ('2024-12-03', 18000, 6900, 82, 1.19), ('2024-12-04', 17200, 6600, 76, 1.15),
    ('2024-12-05', 18300, 7020, 84, 1.20), ('2024-12-06', 18800, 7210, 88, 1.22),
    ('2024-12-07', 11500, 4380, 40, 0.91), ('2024-12-08', 10800, 4120, 36, 0.87),
    ('2024-12-09', 18500, 7100, 86, 1.21), ('2024-12-10', 19000, 7290, 90, 1.23),
    ('2024-12-11', 18200, 6980, 84, 1.20), ('2024-12-12', 19500, 7480, 94, 1.26),
    ('2024-12-13', 20000, 7670, 98, 1.28), ('2024-12-14', 12200, 4650, 44, 0.95),
    ('2024-12-15', 11500, 4380, 40, 0.91), ('2024-12-16', 19200, 7370, 92, 1.25),
    ('2024-12-17', 19800, 7600, 96, 1.26), ('2024-12-18', 18800, 7210, 88, 1.22),
    ('2024-12-19', 19000, 7290, 90, 1.23), ('2024-12-20', 18500, 7100, 85, 1.20),
    ('2024-12-21', 11000, 4200, 38, 0.90), ('2024-12-22', 10200, 3880, 34, 0.88),
    ('2024-12-23', 16000, 6140, 68, 1.11), ('2024-12-24', 12000, 4600, 42, 0.91),
    ('2024-12-25',  6500, 2480, 12, 0.48), ('2024-12-26',  8200, 3120, 20, 0.64),
    ('2024-12-27', 13500, 5180, 52, 0.99), ('2024-12-28', 10500, 4020, 36, 0.89),
    ('2024-12-29',  9800, 3740, 32, 0.86), ('2024-12-30', 14500, 5560, 58, 1.04),
    ('2024-12-31', 11000, 4200, 38, 0.90);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM monthly_revenue;
-- Expected: 90 rows

SELECT COUNT(*) FROM daily_web_metrics;
-- Expected: 92 rows
```

## Exercises

You are an analytics lead at a UK-based fintech company. The CFO, David, has a board presentation at 4pm. He needs a comprehensive monthly performance report for Q4 2024. He wants to understand three things: how each department's revenue changed month over month, whether the Engineering dip in November was a one-off or the start of a decline, and the cumulative year-to-date picture.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Build a running total of revenue for the Sales department (department_id = 1) across all months. Use SUM() OVER with ORDER BY. What is the cumulative total by December 2024?

**Q2:** Use LAG to show each month's revenue alongside the previous month's revenue for Engineering (department_id = 2). Which month had the largest single-month decline?

### 🟡 Practice

**Q3:** For each department, show the month-over-month revenue change (both absolute and percentage) for H2 2024 (July onwards). Use LAG with PARTITION BY to keep each department's comparison independent. Which department had the largest single-month decline?

**Q4:** Build year-to-date running totals for Sales and Engineering across all of 2024. Use SUM() OVER with PARTITION BY and ORDER BY. How much cumulative revenue did each department generate by December?

**Q5:** Build a 7-day moving average for page views from the `daily_web_metrics` table. Use ROWS BETWEEN 6 PRECEDING AND CURRENT ROW. How does the Black Friday spike (29 November) look when smoothed?

### 🔴 Challenge

**Q6:** Create a 3-month moving average for Engineering's revenue across 2024. Use ROWS BETWEEN 2 PRECEDING AND CURRENT ROW. Then add a trend direction column (Accelerating / Decelerating / Stable) by comparing the current moving average to the previous one using LAG. Was November's dip the start of a decline, or an isolated event?

**Q7:** Build a single query that combines LAG (month-over-month change), SUM() OVER (running total), and AVG() OVER with a frame clause (3-month moving average) for all five departments - using a named window (`WINDOW w AS ...`) to avoid repeating the PARTITION BY and ORDER BY. This is how CFO-ready reports are structured in production.

## Key Concepts Covered
- **Running totals** - SUM() OVER with ORDER BY creates cumulative sums; PARTITION BY resets the total for each group
- **Frame clauses (ROWS BETWEEN)** - define a sliding window of rows for moving averages; remember that boundaries are inclusive
- **LAG and LEAD** - LAG reaches back to the previous row for period-over-period comparisons; LEAD looks forward to the next row
- **FIRST_VALUE and LAST_VALUE** - anchor comparisons to a fixed starting or ending point; LAST_VALUE needs an explicit frame clause
- **Named windows (WINDOW w AS ...)** - define once, reuse across multiple window functions to reduce repetition
- **QUALIFY workaround** - PostgreSQL does not support QUALIFY; use a CTE + WHERE instead

---

[← Day 22: Window Functions Part 1](../day-22/) | [Day 24: SCD Types & MERGE →](../day-24/)
