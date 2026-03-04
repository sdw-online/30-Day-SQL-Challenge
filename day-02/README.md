# Day 2 - SELECT & WHERE

[Watch the video](COMING_SOON) | [← Day 1: Introduction to SQL & Databases](../day-01/) | [Day 3: ORDER BY, LIMIT & LIKE →](../day-03/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts](#key-concepts-covered)

---

## What You'll Learn
- How to pull data from a table using SELECT
- How to filter rows based on conditions using WHERE
- How to use comparison operators (=, <>, >, <, >=, <=)
- How to combine conditions with AND, OR, NOT, and parentheses
- How to handle NULL values with IS NULL

## Prerequisites
- Complete [Day 1](../day-01/) (PostgreSQL and pgAdmin installed, `sql_challenge` database created)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop table if it already exists (safe to re-run)
DROP TABLE IF EXISTS employees;

-- Create the employees table
CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    department      VARCHAR(50)     NOT NULL,
    job_title       VARCHAR(100)    NOT NULL,
    salary          NUMERIC(10, 2)  NOT NULL,
    hire_date       DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    city            VARCHAR(50)     NOT NULL,
    status          VARCHAR(30)
);

INSERT INTO employees (first_name, last_name, department, job_title, salary, hire_date, is_active, city, status)
VALUES
    ('Amara',   'Okafor',   'Engineering',  'Senior Data Engineer',         82000.00,   '2023-03-15',  TRUE,   'London',       'Active'),
    ('Callum',  'Reid',     'Engineering',  'Junior Software Developer',    38000.00,   '2025-01-10',  TRUE,   'Edinburgh',    NULL),
    ('Priya',   'Sharma',   'Analytics',    'Data Analyst',                 52000.00,   '2024-06-01',  TRUE,   'London',       'Active'),
    ('Finn',    'Gallagher','Analytics',    'Senior Data Analyst',          68000.00,   '2023-09-20',  TRUE,   'Manchester',   'Active'),
    ('Isla',    'Campbell', 'Marketing',    'Marketing Manager',            61000.00,   '2024-01-08',  TRUE,   'Edinburgh',    'Active'),
    ('Ravi',    'Patel',    'Engineering',  'Data Engineer',                65000.00,   '2024-04-22',  TRUE,   'London',       'Active'),
    ('Sienna',  'Brooks',   'Finance',      'Finance Analyst',              48000.00,   '2025-02-03',  TRUE,   'Bristol',      'Probation'),
    ('Idris',   'Mensah',   'Engineering',  'Lead Software Engineer',       95000.00,   '2022-11-01',  TRUE,   'London',       'Active'),
    ('Freya',   'Nilsson',  'Analytics',    'Analytics Engineer',           72000.00,   '2024-08-15',  FALSE,  'Manchester',   'On Leave'),
    ('Euan',    'MacLeod',  'Marketing',    'Content Strategist',           44000.00,   '2025-03-01',  TRUE,   'Edinburgh',    NULL),
    ('Nia',     'Williams', 'Finance',      'Head of Finance',              88000.00,   '2022-06-10',  TRUE,   'London',       'Active'),
    ('Kwame',   'Asante',   'Engineering',  'DevOps Engineer',              78000.00,   '2023-07-14',  TRUE,   'Manchester',   'Active'),
    ('Mei',     'Zhang',    'Analytics',    'Business Intelligence Analyst',55000.00,   '2024-11-20',  TRUE,   'London',       'Active'),
    ('Jamal',   'Hassan',   'Marketing',    'Digital Marketing Analyst',    46000.00,   '2025-01-15',  TRUE,   'Bristol',      NULL),
    ('Safiya',  'Abdi',     'Engineering',  'Backend Developer',            60000.00,   '2024-09-05',  TRUE,   'London',       'Active'),
    ('Arjun',   'Nair',     'Analytics',    'Data Scientist',               75000.00,   '2023-12-01',  TRUE,   'Manchester',   'Active'),
    ('Quinn',   'Taylor',   'Finance',      'Financial Controller',         70000.00,   '2024-03-18',  TRUE,   'London',       'Active'),
    ('Wei',     'Chen',     'Engineering',  'Frontend Developer',           58000.00,   '2025-02-20',  TRUE,   'Edinburgh',    NULL),
    ('Mateo',   'Rivera',   'Marketing',    'Brand Manager',                56000.00,   '2024-07-01',  FALSE,  'Bristol',      'On Leave'),
    ('River',   'Jordan',   'Finance',      'Payroll Specialist',           42000.00,   '2025-04-01',  TRUE,   'Manchester',   NULL);

-- Loan applications table for the exercise
DROP TABLE IF EXISTS loan_applications;

CREATE TABLE loan_applications (
    application_id      SERIAL PRIMARY KEY,
    applicant_name      VARCHAR(100)    NOT NULL,
    application_date    DATE            NOT NULL,
    credit_score        INTEGER         NOT NULL,
    annual_income       NUMERIC(12, 2)  NOT NULL,
    requested_amount    NUMERIC(12, 2)  NOT NULL,
    loan_purpose        VARCHAR(50)     NOT NULL,
    employment_status   VARCHAR(30)     NOT NULL,
    region              VARCHAR(30)     NOT NULL,
    is_approved         BOOLEAN
);

INSERT INTO loan_applications (applicant_name, application_date, credit_score, annual_income, requested_amount, loan_purpose, employment_status, region, is_approved)
VALUES
    ('Zara Hussain',        '2025-01-05',   720,    62000.00,   15000.00,   'Home Improvement',    'Full-time',    'London',           TRUE),
    ('Liam Fletcher',       '2025-01-08',   580,    34000.00,   55000.00,   'Debt Consolidation',  'Full-time',    'Manchester',       FALSE),
    ('Nina Osei',           '2025-01-12',   690,    48000.00,   30000.00,   'Business Startup',    'Self-employed','Birmingham',       NULL),
    ('Omar Bakri',          '2025-01-15',   610,    28000.00,   65000.00,   'Property Purchase',   'Contract',     'London',           FALSE),
    ('Riley Adams',         '2025-01-20',   750,    85000.00,   40000.00,   'Home Improvement',    'Full-time',    'Edinburgh',        TRUE),
    ('Sage Mwangi',         '2025-01-25',   520,    22000.00,   70000.00,   'Debt Consolidation',  'Part-time',    'Bristol',          FALSE),
    ('Kenji Watanabe',      '2025-02-01',   640,    45000.00,   52000.00,   'Business Startup',    'Self-employed','Manchester',       NULL),
    ('Freya Lindqvist',     '2025-02-04',   700,    56000.00,   25000.00,   'Vehicle Purchase',    'Full-time',    'London',           TRUE),
    ('Phoenix Oduya',       '2025-02-08',   550,    31000.00,   60000.00,   'Property Purchase',   'Contract',     'Birmingham',       FALSE),
    ('Isla Mackenzie',      '2025-02-12',   680,    52000.00,   35000.00,   'Home Improvement',    'Full-time',    'Edinburgh',        TRUE),
    ('Mateo Garcia',        '2025-02-15',   630,    39000.00,   58000.00,   'Debt Consolidation',  'Full-time',    'London',           FALSE),
    ('Aisha Yusuf',         '2025-02-20',   710,    67000.00,   20000.00,   'Vehicle Purchase',    'Full-time',    'Manchester',       TRUE),
    ('Callum Brodie',       '2025-02-22',   590,    33000.00,   72000.00,   'Property Purchase',   'Part-time',    'Edinburgh',        FALSE),
    ('Priya Deshpande',     '2025-02-28',   740,    78000.00,   45000.00,   'Business Startup',    'Full-time',    'London',           TRUE),
    ('Euan Sinclair',       '2025-03-02',   620,    41000.00,   55000.00,   'Debt Consolidation',  'Contract',     'Bristol',          NULL),
    ('Amara Diallo',        '2025-03-05',   670,    50000.00,   38000.00,   'Home Improvement',    'Full-time',    'Birmingham',       TRUE),
    ('Wei Lin',             '2025-03-08',   560,    27000.00,   62000.00,   'Property Purchase',   'Part-time',    'Manchester',       FALSE),
    ('Jordan Ellis',        '2025-03-10',   730,    72000.00,   28000.00,   'Vehicle Purchase',    'Full-time',    'London',           TRUE),
    ('Nia Thomas',          '2025-03-14',   600,    36000.00,   48000.00,   'Business Startup',    'Self-employed','Bristol',          NULL),
    ('Finn O''Connell',     '2025-03-17',   650,    44000.00,   53000.00,   'Debt Consolidation',  'Full-time',    'Edinburgh',        FALSE),
    ('Safiya Noor',         '2025-03-19',   760,    92000.00,   35000.00,   'Home Improvement',    'Full-time',    'London',           TRUE),
    ('Ravi Kapoor',         '2025-03-21',   540,    25000.00,   68000.00,   'Property Purchase',   'Contract',     'Birmingham',       FALSE),
    ('Sienna Byrne',        '2025-03-24',   695,    55000.00,   42000.00,   'Vehicle Purchase',    'Full-time',    'Manchester',       TRUE),
    ('Kwame Adjei',         '2025-03-27',   615,    38000.00,   57000.00,   'Business Startup',    'Self-employed','Bristol',          NULL),
    ('Maya Chen',           '2025-03-30',   720,    64000.00,   30000.00,   'Home Improvement',    'Full-time',    'Edinburgh',        TRUE);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM employees;
-- Expected: 20 rows

SELECT COUNT(*) FROM loan_applications;
-- Expected: 25 rows
```

## Exercises

You're a data analyst at ClearPath Finance - a fintech startup that provides personal loans across the UK. The head of risk, Nia, sends you a message on Thursday morning. She's got a board meeting at 2pm and she needs answers fast. ClearPath is regulated by the Financial Conduct Authority, so if the risk team can't demonstrate proper oversight of high-risk applications, it affects the company's lending licence.

Using the `loan_applications` table, answer the questions below.

### 🟢 Warm-Up

**Q1:** Select just the `applicant_name`, `credit_score`, and `requested_amount` columns for all applications. Don't use `SELECT *` - pick only the three columns Nia needs.

**Q2:** Find all applications from London. How many are there?

### 🟡 Practice

**Q3:** Which applications have a credit score below 650 AND are requesting more than $50,000? These are the highest-risk candidates.

**Q4:** Which applications from London or Edinburgh were for Home Improvement and got approved? The board wants data to support expanding in those cities.

**Q5:** How many self-employed applicants are still pending review (i.e. have no decision yet)? Applications sitting without a decision is a compliance risk.

### 🔴 Challenge

**Q6:** Find all applications where the requested amount is more than double the applicant's annual income. These represent cases where the borrower is asking for significantly more than they earn in a year - a key risk indicator that Nia would want flagged separately.

**Q7:** Nia wants a single query that flags every pending application (no decision yet) where the credit score is below 600 OR the requested amount exceeds the applicant's annual income. These are the cases that need urgent review before the board meeting. How many are there?

## Key Concepts Covered
- **SELECT:** Pulls data from a table - use `SELECT *` for exploring, specific columns for production queries
- **WHERE:** Filters rows based on conditions - only rows where the condition is TRUE appear in your results
- **Comparison operators:** `=` (equals), `<>` (not equal), `>` (greater than), `<` (less than), `>=` and `<=` (inclusive comparisons)
- **AND, OR, NOT:** Combine conditions - AND narrows results (all must be true), OR broadens them (any can be true), NOT reverses a condition
- **Parentheses:** Control evaluation order when mixing AND and OR - always use them to make intent explicit
- **IS NULL:** The only way to check for missing values - never use `= NULL` (it always returns zero rows)

---

[← Day 1: Introduction to SQL & Databases](../day-01/) | [Day 3: ORDER BY, LIMIT & LIKE →](../day-03/)
