# Day 4 - Aggregate Functions & GROUP BY

[Watch the video](https://www.youtube.com/watch?v=7IWrvTIrIkg) | [← Day 3: ORDER BY & LIMIT](../day-03/) | [Day 5: INSERT, UPDATE & DELETE →](../day-05/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to summarise data with the five core aggregate functions: COUNT, SUM, AVG, MIN, MAX
- How to count unique values with COUNT(DISTINCT)
- How to split data into categories with GROUP BY
- How to filter groups after aggregation with HAVING
- How SQL execution order works (FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT)

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Day 3 (comfortable with ORDER BY, LIMIT, DISTINCT, LIKE, IN, and BETWEEN)

## Dataset

Today uses two tables: a teaching table (`company_spending`) for following along with the lesson, and an exercise table (`client_transactions`) for practising independently.

**Teaching table:** BrightWave company spending - 50 expenses across 4 departments, 4 categories, 10 approvers, and 8 UK regions.

**Exercise table:** Client transactions - 120 rows across 5 departments, 10 clients, 5 payment methods, and 10 sales reps.

Run [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand full setup SQL</summary>

```sql
-- Day 04: Aggregate Functions & GROUP BY - Setup Script
-- Run this in pgAdmin to create today's tables

-- Drop previous day tables if they exist (safe to re-run)
DROP TABLE IF EXISTS company_spending;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS loan_applications;
DROP TABLE IF EXISTS online_orders;

-- Create the company_spending table
CREATE TABLE company_spending (
    expense_id      SERIAL PRIMARY KEY,
    approved_by     VARCHAR(100)   NOT NULL,
    department      VARCHAR(50)    NOT NULL,
    vendor          VARCHAR(100)   NOT NULL,
    category        VARCHAR(20)    NOT NULL,
    amount          NUMERIC(10, 2) NOT NULL,
    expense_date    DATE           NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    is_recurring    BOOLEAN        NOT NULL DEFAULT FALSE,
    cost_centre     VARCHAR(50)    DEFAULT NULL
);

INSERT INTO company_spending (approved_by, department, vendor, category, amount, expense_date, region, is_recurring)
VALUES
    ('Amara Osei',      'Engineering',   'Whitfield Group',        'Consulting',        52340.00, '2025-01-07', 'London',         FALSE),
    ('Amara Osei',      'Engineering',   'Tanaka Ltd',             'Equipment',         18750.50, '2025-01-14', 'London',         TRUE),
    ('Amara Osei',      'Engineering',   'Patel & Co',             'Consulting',        67200.00, '2025-02-03', 'South East',     FALSE),
    ('Amara Osei',      'Engineering',   'Bryson Tech',            'Equipment',         12800.00, '2025-03-18', 'London',         TRUE),
    ('Amara Osei',      'Engineering',   'Kwon Systems',           'Software Licences',  7450.00, '2025-04-22', 'South East',     FALSE),
    ('Ravi Kapoor',     'Marketing',     'Birch & Partners',       'Software Licences',  5200.00, '2025-01-10', 'North West',     FALSE),
    ('Ravi Kapoor',     'Marketing',     'Clearview Data',         'Equipment',         11340.75, '2025-01-28', 'Scotland',       TRUE),
    ('Ravi Kapoor',     'Marketing',     'Forge Analytics',        'Software Licences',  3890.00, '2025-02-15', 'North West',     FALSE),
    ('Ravi Kapoor',     'Marketing',     'Rivera Labs',            'Office Supplies',    1250.00, '2025-03-05', 'Scotland',       FALSE),
    ('Ravi Kapoor',     'Marketing',     'Clarke Digital',         'Equipment',         15600.00, '2025-04-12', 'North West',     TRUE),
    ('Sienna Clarke',   'Finance',       'Little Oak Studio',      'Office Supplies',     890.00, '2025-01-15', 'Wales',          FALSE),
    ('Sienna Clarke',   'Finance',       'Fern & Ivy Co',          'Office Supplies',    1450.00, '2025-02-01', 'Wales',          FALSE),
    ('Sienna Clarke',   'Finance',       'Coastal Creative',       'Software Licences',  4200.00, '2025-02-20', 'South East',     TRUE),
    ('Sienna Clarke',   'Finance',       'Sorensen Inc',           'Office Supplies',    2100.00, '2025-03-14', 'West Midlands',  FALSE),
    ('Sienna Clarke',   'Finance',       'River Digital',          'Software Licences',  6780.00, '2025-04-30', 'Wales',          TRUE),
    ('Finn McCarthy',   'Operations',    'TechBridge UK',          'Equipment',         22000.00, '2025-01-20', 'East Midlands',  FALSE),
    ('Finn McCarthy',   'Operations',    'Innovate Alliance',      'Consulting',        45800.00, '2025-02-10', 'London',         FALSE),
    ('Finn McCarthy',   'Operations',    'DataFlow Partners',      'Equipment',         19500.00, '2025-03-01', 'North East',     TRUE),
    ('Finn McCarthy',   'Operations',    'Catalyst Group',         'Consulting',        58900.00, '2025-04-08', 'London',         FALSE),
    ('Finn McCarthy',   'Operations',    'NexGen Solutions',       'Software Licences',  7100.00, '2025-05-15', 'East Midlands',  TRUE),
    ('Yuki Tanaka',     'Engineering',   'Helix Corp',             'Consulting',        41200.00, '2025-01-25', 'Scotland',       FALSE),
    ('Yuki Tanaka',     'Engineering',   'Meridian Global',        'Equipment',         24500.00, '2025-02-18', 'London',         TRUE),
    ('Yuki Tanaka',     'Engineering',   'Apex Industries',        'Consulting',        63000.00, '2025-03-10', 'South East',     FALSE),
    ('Yuki Tanaka',     'Engineering',   'Crown Analytics',        'Software Licences',  5800.00, '2025-04-20', 'Scotland',       FALSE),
    ('Yuki Tanaka',     'Engineering',   'Skyline Digital',        'Equipment',         16300.00, '2025-05-28', 'London',         TRUE),
    ('Kwame Mensah',    'Marketing',     'Bolt Media',             'Software Licences',  4100.00, '2025-01-30', 'West Midlands',  FALSE),
    ('Kwame Mensah',    'Marketing',     'Prism Analytics',        'Equipment',          9800.00, '2025-02-22', 'North East',     FALSE),
    ('Kwame Mensah',    'Marketing',     'Echo Ventures',          'Office Supplies',    1800.00, '2025-03-15', 'West Midlands',  TRUE),
    ('Kwame Mensah',    'Marketing',     'Crest Solutions',        'Software Licences',  6200.00, '2025-04-25', 'North East',     FALSE),
    ('Kwame Mensah',    'Marketing',     'Horizon Labs',           'Equipment',         13400.00, '2025-05-30', 'West Midlands',  TRUE),
    ('Isla Nguyen',     'Finance',       'Amber & Co',             'Office Supplies',    1100.00, '2025-01-12', 'East Midlands',  FALSE),
    ('Isla Nguyen',     'Finance',       'Jade Digital',           'Software Licences',  3500.00, '2025-02-05', 'North West',     FALSE),
    ('Isla Nguyen',     'Finance',       'Willow Creative',        'Office Supplies',     750.00, '2025-03-20', 'East Midlands',  TRUE),
    ('Isla Nguyen',     'Finance',       'Maple Analytics',        'Software Licences',  5900.00, '2025-04-15', 'North West',     FALSE),
    ('Isla Nguyen',     'Finance',       'Cedar Tech',             'Equipment',          8500.00, '2025-05-22', 'East Midlands',  TRUE),
    ('Mateo Silva',     'Operations',    'LinkBridge Co',          'Equipment',         20100.00, '2025-01-18', 'London',         FALSE),
    ('Mateo Silva',     'Operations',    'Unity Partners',         'Consulting',        35600.00, '2025-02-25', 'South East',     TRUE),
    ('Mateo Silva',     'Operations',    'Synergy Group',          'Software Licences',  6400.00, '2025-03-28', 'London',         FALSE),
    ('Mateo Silva',     'Operations',    'Pathway Digital',        'Equipment',         17800.00, '2025-04-18', 'South East',     FALSE),
    ('Mateo Silva',     'Operations',    'Alliance Tech',          'Consulting',        48200.00, '2025-05-10', 'London',         TRUE),
    ('Leila Hussain',   'Engineering',   'Zenith Corp',            'Consulting',        55400.00, '2025-02-08', 'North West',     FALSE),
    ('Leila Hussain',   'Engineering',   'Vanguard Analytics',     'Equipment',         21700.00, '2025-03-12', 'London',         TRUE),
    ('Leila Hussain',   'Engineering',   'Frontier Systems',       'Consulting',        70100.00, '2025-04-02', 'North West',     FALSE),
    ('Leila Hussain',   'Engineering',   'Titan Digital',          'Software Licences',  4600.00, '2025-05-05', 'London',         FALSE),
    ('Leila Hussain',   'Engineering',   'Summit Analytics',       'Equipment',         19200.00, '2025-06-18', 'North West',     TRUE),
    ('Euan Campbell',   'Finance',       'Glen Tech',              'Office Supplies',    1600.00, '2025-01-22', 'Scotland',       FALSE),
    ('Euan Campbell',   'Finance',       'Thistle Digital',        'Software Licences',  3200.00, '2025-02-14', 'Scotland',       TRUE),
    ('Euan Campbell',   'Finance',       'Loch Analytics',         'Office Supplies',    2400.00, '2025-03-25', 'Scotland',       FALSE),
    ('Euan Campbell',   'Finance',       'Highland Solutions',     'Equipment',         10500.00, '2025-04-28', 'Scotland',       FALSE),
    ('Euan Campbell',   'Finance',       'Cairn Media',            'Software Licences',  5100.00, '2025-06-02', 'Scotland',       TRUE);

-- Assign cost centres (~2/3 of rows, rest stay NULL)
UPDATE company_spending
SET cost_centre = 'CC-' ||
    CASE department
        WHEN 'Engineering' THEN 'ENG'
        WHEN 'Marketing' THEN 'MKT'
        WHEN 'Finance' THEN 'FIN'
        WHEN 'Operations' THEN 'OPS'
    END || '-' ||
    LPAD((MOD(expense_id, 3) + 1)::TEXT, 3, '0')
WHERE MOD(expense_id, 3) != 0;
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM company_spending;
-- Expected: 50 rows

SELECT department, COUNT(*) AS expenses
FROM company_spending
GROUP BY department
ORDER BY department;
-- Expected: Engineering 15, Finance 15, Marketing 10, Operations 10
```

## Exercises

You're a junior data analyst at an auditing firm. It's the year-end review period and your manager, Priya, drops a message on Teams: "Before the client meeting tomorrow, I need a quick breakdown of the transaction data. Can you pull together some headline numbers?"

Using the `client_transactions` table, complete these tasks:

### Warm-Up

**Q1:** Priya wants a single-row summary to kick off the report. Write a query that shows: the total number of transactions, the total revenue across all transactions, the average transaction value (rounded to 2 decimal places), and the smallest and largest single transaction.

<details>
<summary>Hint</summary>

Use COUNT(*), SUM(amount), ROUND(AVG(amount), 2), MIN(amount), and MAX(amount) in a single SELECT with no GROUP BY.

</details>

**Q2:** Priya asks: "How many unique clients and unique sales reps are in the data?" Write a single query that returns both counts.

<details>
<summary>Hint</summary>

Use COUNT(DISTINCT client_name) and COUNT(DISTINCT sales_rep) together in one SELECT.

</details>

### Practice

**Q3:** Priya needs a department-level revenue breakdown. Write a query that shows each department, the number of transactions in it, and the total revenue for that department. Sort by total revenue descending so the highest-earning department appears first.

<details>
<summary>Hint</summary>

GROUP BY department. Use COUNT(*) for transaction count and SUM(amount) for revenue. ORDER BY the SUM descending.

</details>

**Q4:** Priya now wants to see how each sales rep is performing. Write a query that shows each sales rep, their department, the number of transactions they handled, and their total revenue. Filter to show only sales reps whose total revenue exceeds $300,000. Sort by total revenue descending.

<details>
<summary>Hint</summary>

GROUP BY sales_rep, department. Use HAVING SUM(amount) > 300000 to filter after aggregation - you cannot use WHERE for this because the filter applies to a grouped total, not individual rows.

</details>

### Challenge

**Q5:** Priya wants to flag any departments where cash transactions account for more than $75,000 in total. Write a query that shows the department, the total cash revenue (where payment_method = 'Cash'), and the number of cash transactions - but only for departments that exceed the $75,000 threshold.

<details>
<summary>Hint</summary>

Filter to Cash rows first using WHERE payment_method = 'Cash', then GROUP BY department, then use HAVING SUM(amount) > 75000.

</details>

## Key Concepts Covered
- **COUNT(*):** Counts all rows including NULLs - use this when you want a row total
- **COUNT(column):** Counts only non-NULL values in that column
- **COUNT(DISTINCT column):** Counts unique values - useful for "how many different X are there?"
- **SUM / AVG / MIN / MAX:** Aggregate the values in a column across all rows or within a group
- **GROUP BY:** Splits rows into groups by the values in one or more columns - each group becomes one output row
- **HAVING:** Filters groups after aggregation - like WHERE but for grouped results; required when your filter references an aggregate function
- **SQL execution order:** FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT - WHERE runs before grouping, HAVING runs after

---

[← Day 3: ORDER BY & LIMIT](../day-03/) | [Day 5: INSERT, UPDATE & DELETE →](../day-05/)
