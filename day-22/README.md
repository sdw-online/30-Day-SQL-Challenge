# Day 22 - Window Functions Part 1: ROW_NUMBER, RANK & DENSE_RANK

[Watch the video](COMING_SOON) | [← Day 21: Project: SaaS Trial-to-Paid Conversion Analysis](../day-21/) | [Day 23: Window Functions Part 2 →](../day-23/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How window functions calculate across rows without collapsing them (unlike GROUP BY)
- The difference between ROW_NUMBER, RANK, and DENSE_RANK - and when to use each one
- How NTILE splits rows into equal buckets (quartiles, deciles, percentiles)
- How PARTITION BY creates independent ranking windows within groups

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-21
- Comfortable with SELECT, WHERE, GROUP BY, JOINs, subqueries, and CTEs

## Dataset

Today's lesson uses sales and employee data from a UK-based fintech company. The dataset includes employees across departments with performance scores and salary bands, plus quarterly sales records with intentional ties (identical values) so you can see exactly how ROW_NUMBER, RANK, and DENSE_RANK handle them differently.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS quarterly_sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- TABLE 1: departments
CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(60)     NOT NULL,
    floor_number    INTEGER         NOT NULL,
    head_count      INTEGER         NOT NULL DEFAULT 0
);

-- TABLE 2: employees
CREATE TABLE employees (
    employee_id         SERIAL PRIMARY KEY,
    first_name          VARCHAR(60)     NOT NULL,
    last_name           VARCHAR(60)     NOT NULL,
    email               VARCHAR(150)    NOT NULL UNIQUE,
    department_id       INTEGER         NOT NULL REFERENCES departments(department_id),
    job_title           VARCHAR(80)     NOT NULL,
    salary              NUMERIC(10, 2)  NOT NULL,
    performance_score   NUMERIC(3, 1)   NOT NULL,
    hire_date           DATE            NOT NULL,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 3: quarterly_sales
CREATE TABLE quarterly_sales (
    sale_id         SERIAL PRIMARY KEY,
    employee_id     INTEGER         NOT NULL REFERENCES employees(employee_id),
    quarter         VARCHAR(10)     NOT NULL,
    revenue         NUMERIC(12, 2)  NOT NULL,
    deals_closed    INTEGER         NOT NULL,
    region          VARCHAR(40)     NOT NULL
);

-- INSERT: 5 departments
INSERT INTO departments (department_name, floor_number, head_count)
VALUES
    ('Sales',           3, 8),
    ('Engineering',     5, 6),
    ('Marketing',       2, 5),
    ('Customer Success', 4, 4),
    ('Data & Analytics', 5, 3);

-- INSERT: 25 employees across departments
INSERT INTO employees
    (first_name, last_name, email, department_id, job_title, salary, performance_score, hire_date, is_active)
VALUES
    ('Amara',   'Okafor',    'amara.okafor@novafintech.com',    1, 'Senior Sales Executive',    62000.00, 4.7, '2023-03-15', TRUE),
    ('Callum',  'Reid',      'callum.reid@novafintech.com',     1, 'Sales Executive',           48000.00, 4.2, '2023-09-20', TRUE),
    ('Priya',   'Sharma',    'priya.sharma@novafintech.com',    1, 'Sales Executive',           47500.00, 4.2, '2024-01-10', TRUE),
    ('Finn',    'Gallagher', 'finn.gallagher@novafintech.com',  1, 'Junior Sales Executive',    38000.00, 3.8, '2024-06-01', TRUE),
    ('Isla',    'Campbell',  'isla.campbell@novafintech.com',    1, 'Junior Sales Executive',    37000.00, 3.8, '2024-07-15', TRUE),
    ('Ravi',    'Patel',     'ravi.patel@novafintech.com',      1, 'Sales Manager',             72000.00, 4.9, '2022-11-08', TRUE),
    ('Sienna',  'Brooks',    'sienna.brooks@novafintech.com',   1, 'Sales Executive',           50000.00, 4.4, '2023-05-22', TRUE),
    ('Idris',   'Mensah',    'idris.mensah@novafintech.com',    1, 'Sales Executive',           49000.00, 3.5, '2024-02-14', TRUE),
    ('Freya',   'Nilsson',   'freya.nilsson@novafintech.com',   2, 'Senior Software Engineer',  78000.00, 4.5, '2022-07-14', TRUE),
    ('Euan',    'MacLeod',   'euan.macleod@novafintech.com',    2, 'Software Engineer',         58000.00, 4.5, '2023-04-03', TRUE),
    ('Nia',     'Williams',  'nia.williams@novafintech.com',    2, 'Software Engineer',         56000.00, 4.1, '2024-01-19', TRUE),
    ('Kwame',   'Asante',    'kwame.asante@novafintech.com',    2, 'Junior Software Engineer',  42000.00, 3.6, '2024-08-25', TRUE),
    ('Mei',     'Zhang',     'mei.zhang@novafintech.com',       2, 'Data Engineer',             65000.00, 4.8, '2023-01-06', TRUE),
    ('Jamal',   'Hassan',    'jamal.hassan@novafintech.com',    2, 'DevOps Engineer',           63000.00, 4.0, '2023-06-11', TRUE),
    ('Safiya',  'Abdi',      'safiya.abdi@novafintech.com',     3, 'Marketing Manager',         60000.00, 4.3, '2023-02-28', TRUE),
    ('Arjun',   'Nair',      'arjun.nair@novafintech.com',     3, 'Content Strategist',        45000.00, 3.9, '2023-08-14', TRUE),
    ('Quinn',   'Taylor',    'quinn.taylor@novafintech.com',    3, 'Growth Marketer',           46000.00, 3.9, '2024-03-18', TRUE),
    ('Wei',     'Chen',      'wei.chen@novafintech.com',        3, 'SEO Specialist',            43000.00, 3.5, '2024-05-25', TRUE),
    ('Mateo',   'Rivera',    'mateo.rivera@novafintech.com',    3, 'Brand Designer',            44000.00, 4.1, '2024-09-07', TRUE),
    ('Aisha',   'Yusuf',     'aisha.yusuf@novafintech.com',    4, 'CS Manager',                55000.00, 4.6, '2023-04-12', TRUE),
    ('Lucas',   'Fernandes', 'lucas.fernandes@novafintech.com', 4, 'CS Executive',              40000.00, 3.7, '2024-02-20', TRUE),
    ('Nina',    'Kowalski',  'nina.kowalski@novafintech.com',   4, 'CS Executive',              41000.00, 4.0, '2024-06-08', TRUE),
    ('Jordan',  'Ellis',     'jordan.ellis@novafintech.com',    4, 'Onboarding Specialist',     39000.00, 3.4, '2024-10-01', TRUE),
    ('Leila',   'Osman',     'leila.osman@novafintech.com',    5, 'Analytics Lead',            68000.00, 4.7, '2023-01-20', TRUE),
    ('River',   'Nguyen',    'river.nguyen@novafintech.com',   5, 'Data Analyst',              48000.00, 4.2, '2024-04-15', TRUE),
    ('Phoenix', 'Moreau',    'phoenix.moreau@novafintech.com',  5, 'Junior Data Analyst',       38000.00, 3.6, '2025-01-13', TRUE);

-- INSERT: 60 quarterly sales records (with intentional ties)
INSERT INTO quarterly_sales (employee_id, quarter, revenue, deals_closed, region)
VALUES
    (1, '2024-Q1', 78000.00,  12, 'London'),
    (1, '2024-Q2', 82000.00,  14, 'London'),
    (1, '2024-Q3', 91000.00,  16, 'London'),
    (1, '2024-Q4', 95000.00,  18, 'London'),
    (1, '2025-Q1', 87500.00,  15, 'London'),
    (2, '2024-Q1', 55000.00,   9, 'North'),
    (2, '2024-Q2', 58000.00,  10, 'North'),
    (2, '2024-Q3', 61000.00,  11, 'North'),
    (2, '2024-Q4', 64000.00,  12, 'North'),
    (2, '2025-Q1', 62000.00,  11, 'North'),
    (3, '2024-Q1', 52000.00,   8, 'North'),
    (3, '2024-Q2', 59000.00,  10, 'North'),
    (3, '2024-Q3', 57000.00,  10, 'North'),
    (3, '2024-Q4', 63000.00,  11, 'North'),
    (3, '2025-Q1', 62000.00,  11, 'North'),
    (4, '2024-Q2', 35000.00,   6, 'Midlands'),
    (4, '2024-Q3', 41000.00,   7, 'Midlands'),
    (4, '2024-Q4', 45000.00,   8, 'Midlands'),
    (4, '2025-Q1', 48000.00,   9, 'Midlands'),
    (5, '2024-Q3', 32000.00,   5, 'Scotland'),
    (5, '2024-Q4', 38000.00,   7, 'Scotland'),
    (5, '2025-Q1', 42000.00,   8, 'Scotland'),
    (6, '2024-Q1', 92000.00,  17, 'London'),
    (6, '2024-Q2', 98000.00,  19, 'London'),
    (6, '2024-Q3', 105000.00, 21, 'London'),
    (6, '2024-Q4', 95000.00,  18, 'London'),
    (6, '2025-Q1', 101000.00, 20, 'London'),
    (7, '2024-Q1', 68000.00,  11, 'London'),
    (7, '2024-Q2', 72000.00,  13, 'London'),
    (7, '2024-Q3', 76000.00,  14, 'London'),
    (7, '2024-Q4', 80000.00,  15, 'London'),
    (7, '2025-Q1', 87500.00,  15, 'London'),
    (8, '2024-Q1', 45000.00,   7, 'South East'),
    (8, '2024-Q2', 48000.00,   8, 'South East'),
    (8, '2024-Q3', 43000.00,   7, 'South East'),
    (8, '2024-Q4', 50000.00,   9, 'South East'),
    (8, '2025-Q1', 52000.00,   9, 'South East'),
    (15, '2024-Q3', 25000.00,  4, 'London'),
    (15, '2024-Q4', 30000.00,  5, 'London'),
    (15, '2025-Q1', 28000.00,  5, 'London'),
    (16, '2024-Q3', 18000.00,  3, 'South East'),
    (16, '2024-Q4', 22000.00,  4, 'South East'),
    (16, '2025-Q1', 20000.00,  3, 'South East'),
    (20, '2024-Q1', 35000.00,  6, 'London'),
    (20, '2024-Q2', 40000.00,  7, 'London'),
    (20, '2024-Q3', 38000.00,  6, 'London'),
    (20, '2024-Q4', 42000.00,  8, 'London'),
    (20, '2025-Q1', 45000.00,  8, 'London'),
    (21, '2024-Q2', 22000.00,  4, 'Midlands'),
    (21, '2024-Q3', 25000.00,  5, 'Midlands'),
    (21, '2024-Q4', 28000.00,  5, 'Midlands'),
    (21, '2025-Q1', 30000.00,  6, 'Midlands'),
    (24, '2024-Q1', 42000.00,  5, 'London'),
    (24, '2024-Q2', 45000.00,  6, 'London'),
    (24, '2024-Q3', 48000.00,  7, 'London'),
    (24, '2024-Q4', 50000.00,  7, 'London'),
    (24, '2025-Q1', 52000.00,  8, 'London'),
    (25, '2024-Q2', 28000.00,  4, 'South East'),
    (25, '2024-Q3', 32000.00,  5, 'South East'),
    (25, '2024-Q4', 35000.00,  6, 'South East'),
    (25, '2025-Q1', 38000.00,  6, 'South East');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM departments;
-- Expected: 5 rows

SELECT COUNT(*) FROM employees;
-- Expected: 25 rows

SELECT COUNT(*) FROM quarterly_sales;
-- Expected: 60 rows
```

## Exercises

You are an analytics lead at a UK-based fintech company. The Head of Sales, Ravi, has asked for a quarterly performance review pack for the executive leadership meeting. The meeting is Monday at 10am and he needs answers fast.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Show every employee's salary alongside their department's total salary spend using a window function. Do not use GROUP BY - every row must remain visible. Which department has the highest total spend?

**Q2:** Rank all 25 employees by salary company-wide using ROW_NUMBER. Who is ranked 1st? What happens to employees who share the same salary - do they get the same rank or different ranks?

### 🟡 Practice

**Q3:** Rank every salesperson in Q1 2025 - both company-wide and within their region. Show ROW_NUMBER, RANK, and DENSE_RANK side by side so Ravi can see how each handles the ties between Amara and Sienna (both earned $87,500).

**Q4:** Break the sales team into four performance tiers (top 25%, upper-middle, lower-middle, bottom 25%) based on their total revenue across all quarters. Use NTILE and add a human-readable tier label (e.g., "Top Performer", "Needs Support").

**Q5:** Compare each employee's Q1 2025 revenue to both their department average and the company-wide average. Flag each person as "Significantly Above", "Above Average", "Near Average", or "Below Average" relative to their department.

### 🔴 Challenge

**Q6:** Write a single query that finds the highest-paid employee in each department using ROW_NUMBER + PARTITION BY + WHERE rank = 1. Return exactly one row per department showing the department name, employee name, and salary.

**Q7:** Ravi wants to identify the single best quarter each salesperson has ever had. Write a query that returns one row per salesperson showing their name, the quarter, the revenue, and the region - using ROW_NUMBER partitioned by employee and ordered by revenue descending. Filter to only the top quarter per person.

## Key Concepts Covered
- **Window functions vs GROUP BY** - window functions add summary columns alongside detail rows without collapsing them
- **ROW_NUMBER** - assigns unique sequential numbers; perfect for "give me exactly one row per group" problems
- **RANK** - gives tied rows the same number, then skips (like Olympic medals)
- **DENSE_RANK** - gives tied rows the same number, then continues without gaps (like tier levels)
- **NTILE** - splits rows into equal-ish buckets for quartile/percentile analysis
- **PARTITION BY** - creates independent windows within groups, resetting the ranking for each group

---

[← Day 21: Project: SaaS Trial-to-Paid Conversion Analysis](../day-21/) | [Day 23: Window Functions Part 2 →](../day-23/)
