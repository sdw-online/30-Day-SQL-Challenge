# Day 10 - Date Functions & CAST

[Watch the video](https://youtu.be/Iturx2kgs1A) | [← Day 9: String & Numeric Functions](../day-09/) | [Day 11: CASE WHEN →](../day-11/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- CURRENT_DATE and NOW() - getting today's date and the current timestamp
- EXTRACT - pulling year, month, quarter, and day of week from a date
- DATE_TRUNC - rounding dates down to the start of a period
- AGE and INTERVAL - calculating durations and doing date arithmetic
- CAST and the :: shorthand - converting between data types
- TO_CHAR and TO_DATE - formatting dates for reports and parsing date strings

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-9
- pgAdmin open and connected to your `sql_challenge` database
- Comfortable with SELECT, WHERE, GROUP BY, NULL handling, string and numeric functions

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS contract_invoices;
DROP TABLE IF EXISTS employee_contracts;

-- TABLE 1: employee_contracts
CREATE TABLE employee_contracts (
    contract_id         SERIAL PRIMARY KEY,
    employee_name       VARCHAR(100)    NOT NULL,
    date_of_birth       DATE            NOT NULL,
    department          VARCHAR(60)     NOT NULL,
    job_title           VARCHAR(100)    NOT NULL,
    client_company      VARCHAR(100)    NOT NULL,
    contract_start      DATE            NOT NULL,
    contract_end        DATE,
    annual_salary       NUMERIC(10, 2)  NOT NULL,
    daily_rate          NUMERIC(8, 2),
    last_review_date    DATE,
    notes               VARCHAR(300)
);

-- TABLE 2: contract_invoices
CREATE TABLE contract_invoices (
    invoice_id          SERIAL PRIMARY KEY,
    contract_id         INTEGER         NOT NULL REFERENCES employee_contracts(contract_id),
    invoice_date        DATE            NOT NULL,
    amount_billed       NUMERIC(10, 2)  NOT NULL,
    amount_paid         NUMERIC(10, 2),
    payment_date        DATE,
    due_date            DATE            NOT NULL,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'GBP'
);

-- 25 employee contracts with varied date patterns
INSERT INTO employee_contracts
    (employee_name, date_of_birth, department, job_title, client_company,
     contract_start, contract_end, annual_salary, daily_rate, last_review_date, notes)
VALUES
    ('Amara Okafor',     '1990-03-15', 'Engineering',    'Data Engineer',          'Barclays',          '2024-01-15', '2025-06-30', 72000.00, 380.00, '2025-01-10', 'Extended twice'),
    ('Callum Reid',      '1985-11-22', 'Engineering',    'Backend Developer',      'Revolut',           '2024-06-01', NULL,         68000.00, 350.00, '2025-03-15', 'Permanent placement'),
    ('Priya Sharma',     '1992-07-08', 'Analytics',      'Senior Data Analyst',    'Deliveroo',         '2025-01-06', '2025-12-31', 58000.00, NULL,   '2025-04-01', NULL),
    ('Finn Gallagher',   '1988-01-30', 'Engineering',    'DevOps Engineer',        'Monzo',             '2024-09-01', '2025-03-31', 75000.00, 400.00, '2025-02-20', 'Contract completed on time'),
    ('Isla Campbell',    '1995-12-05', 'Analytics',      'BI Analyst',             'Tesco',             '2025-02-17', NULL,         52000.00, NULL,   NULL,         'New hire -- no review yet'),
    ('Ravi Patel',       '1983-04-18', 'Engineering',    'Platform Engineer',      'Sky',               '2023-11-01', '2024-10-31', 80000.00, 420.00, '2024-08-15', 'Moved to permanent role at Sky'),
    ('Sienna Brooks',    '1997-08-25', 'Marketing',      'Growth Analyst',         'ASOS',              '2025-03-01', '2025-08-31', 48000.00, NULL,   NULL,         'First contract role'),
    ('Idris Mensah',     '1991-06-12', 'Engineering',    'Senior Data Engineer',   'Barclays',          '2024-03-01', '2025-02-28', 85000.00, 450.00, '2024-12-01', 'Completed -- rehire likely'),
    ('Freya Nilsson',    '1993-09-03', 'Analytics',      'Analytics Engineer',     'Spotify',           '2025-04-01', NULL,         70000.00, 370.00, '2025-04-15', 'Remote from Stockholm'),
    ('Euan MacLeod',     '1986-02-14', 'Finance',        'Finance Analyst',        'Standard Life',     '2024-07-15', '2025-07-14', 55000.00, NULL,   '2025-01-20', NULL),
    ('Nia Williams',     '1994-10-20', 'Engineering',    'Full Stack Developer',   'Monzo',             '2025-01-13', NULL,         65000.00, 340.00, '2025-04-10', 'Strong performer'),
    ('Kwame Asante',     '1989-05-07', 'Analytics',      'Product Analyst',        'Deliveroo',         '2024-04-01', '2024-12-31', 56000.00, NULL,   '2024-10-15', 'Contract ended -- client budget cut'),
    ('Mei Zhang',        '1996-01-28', 'Engineering',    'ML Engineer',            'Revolut',           '2025-02-03', NULL,         78000.00, 410.00, NULL,         'New hire -- probation period'),
    ('Jamal Hassan',     '1987-07-19', 'Marketing',      'Marketing Analyst',      'ASOS',              '2024-08-12', '2025-02-11', 46000.00, NULL,   '2024-11-30', 'Completed six-month contract'),
    ('Safiya Abdi',      '1990-11-01', 'Finance',        'Senior Finance Analyst', 'Barclays',          '2024-10-01', NULL,         62000.00, 330.00, '2025-03-01', 'Permanent conversion pending'),
    ('Arjun Nair',       '1984-03-25', 'Engineering',    'Lead Data Engineer',     'Sky',               '2025-01-20', '2026-01-19', 92000.00, 480.00, '2025-04-20', 'Twelve-month fixed term'),
    ('Quinn Taylor',     '1998-06-15', 'Analytics',      'Junior Data Analyst',    'Tesco',             '2025-03-10', NULL,         42000.00, NULL,   NULL,         'Graduate programme placement'),
    ('Wei Chen',         '1991-12-09', 'Engineering',    'Cloud Engineer',         'Sky',               '2024-05-01', '2025-04-30', 74000.00, 390.00, '2025-01-05', NULL),
    ('Mateo Rivera',     '1993-02-20', 'Marketing',      'Content Analyst',        'ASOS',              '2025-04-14', NULL,         44000.00, NULL,   NULL,         'New hire -- first week'),
    ('River Jordan',     '1999-04-01', 'Analytics',      'Data Analyst',           'Deliveroo',         '2025-01-27', '2025-07-26', 47000.00, NULL,   '2025-04-25', 'Six-month placement'),
    ('Aisha Yusuf',      '1992-08-30', 'Finance',        'Risk Analyst',           'Standard Life',     '2024-12-02', NULL,         58000.00, 310.00, '2025-03-20', 'Extended from original 6-month'),
    ('Liam Fletcher',    '1986-10-11', 'Engineering',    'Site Reliability Eng',   'Monzo',             '2024-02-01', '2025-01-31', 82000.00, 430.00, '2024-11-15', 'Completed -- excellent feedback'),
    ('Yuki Tanaka',      '1994-05-17', 'Engineering',    'Data Engineer',          'Spotify',           '2025-03-17', NULL,         71000.00, 375.00, NULL,         'Remote from Tokyo'),
    ('Sage Mwangi',      '1988-09-08', 'Analytics',      'Senior BI Analyst',      'Tesco',             '2024-11-04', '2025-05-03', 60000.00, 320.00, '2025-02-10', 'Six-month fixed term'),
    ('Phoenix Oduya',    '1995-07-22', 'Engineering',    'Software Engineer',      'Revolut',           '2025-02-10', NULL,         67000.00, 355.00, '2025-04-08', 'Joined mid-sprint');

-- 30 invoices with varied payment patterns
INSERT INTO contract_invoices
    (contract_id, invoice_date, amount_billed, amount_paid, payment_date, due_date, currency)
VALUES
    (1,  '2024-02-01', 6000.00, 6000.00, '2024-02-20', '2024-02-28', 'GBP'),
    (1,  '2024-03-01', 6000.00, 6000.00, '2024-03-18', '2024-03-28', 'GBP'),
    (1,  '2024-04-01', 6000.00, 6000.00, '2024-04-25', '2024-04-28', 'GBP'),
    (2,  '2024-07-01', 5666.67, 5666.67, '2024-07-22', '2024-07-28', 'GBP'),
    (2,  '2024-08-01', 5666.67, 5666.67, '2024-08-15', '2024-08-28', 'GBP'),
    (2,  '2025-01-01', 5666.67, 5666.67, '2025-01-25', '2025-01-28', 'GBP'),
    (3,  '2025-02-01', 4833.33, 4833.33, '2025-02-18', '2025-02-28', 'GBP'),
    (3,  '2025-03-01', 4833.33, 4833.33, '2025-03-20', '2025-03-28', 'GBP'),
    (3,  '2025-04-01', 4833.33, NULL,     NULL,         '2025-04-28', 'GBP'),
    (4,  '2024-10-01', 6250.00, 6250.00, '2024-10-28', '2024-10-28', 'GBP'),
    (4,  '2024-11-01', 6250.00, 6250.00, '2024-11-30', '2024-11-28', 'GBP'),
    (4,  '2025-01-01', 6250.00, 6250.00, '2025-01-28', '2025-01-28', 'GBP'),
    (6,  '2024-01-01', 6666.67, 6666.67, '2024-01-20', '2024-01-28', 'GBP'),
    (6,  '2024-06-01', 6666.67, 6666.67, '2024-06-28', '2024-06-28', 'GBP'),
    (8,  '2024-04-01', 7083.33, 7083.33, '2024-04-22', '2024-04-28', 'GBP'),
    (8,  '2024-05-01', 7083.33, 7083.33, '2024-05-18', '2024-05-28', 'GBP'),
    (8,  '2024-12-01', 7083.33, 7083.33, '2024-12-30', '2024-12-28', 'GBP'),
    (9,  '2025-05-01', 5833.33, NULL,     NULL,         '2025-05-28', 'SEK'),
    (10, '2024-08-01', 4583.33, 4583.33, '2024-08-25', '2024-08-28', 'GBP'),
    (10, '2025-01-01', 4583.33, 4583.33, '2025-01-28', '2025-01-28', 'GBP'),
    (12, '2024-05-01', 4666.67, 4666.67, '2024-05-20', '2024-05-28', 'GBP'),
    (12, '2024-09-01', 4666.67, 4666.67, '2024-09-15', '2024-09-28', 'GBP'),
    (15, '2024-11-01', 5166.67, 5166.67, '2024-11-25', '2024-11-28', 'GBP'),
    (15, '2025-02-01', 5166.67, 5166.67, '2025-02-20', '2025-02-28', 'GBP'),
    (16, '2025-02-01', 7666.67, 7666.67, '2025-02-25', '2025-02-28', 'GBP'),
    (16, '2025-03-01', 7666.67, NULL,     NULL,         '2025-03-28', 'GBP'),
    (18, '2024-06-01', 6166.67, 6166.67, '2024-06-20', '2024-06-28', 'GBP'),
    (18, '2025-01-01', 6166.67, 6166.67, '2025-01-30', '2025-01-28', 'GBP'),
    (22, '2024-03-01', 6833.33, 6833.33, '2024-03-28', '2024-03-28', 'GBP'),
    (22, '2025-01-01', 6833.33, 6833.33, '2025-01-15', '2025-01-28', 'GBP');
```

</details>

Now create the exercise table.

<details>
<summary>Click to expand exercise dataset SQL</summary>

```sql
-- Project milestone tracking data for the exercise
DROP TABLE IF EXISTS project_milestones;

CREATE TABLE project_milestones (
    milestone_id        SERIAL PRIMARY KEY,
    project_name        VARCHAR(150)    NOT NULL,
    client_name         VARCHAR(100)    NOT NULL,
    milestone_name      VARCHAR(150)    NOT NULL,
    planned_date        DATE            NOT NULL,
    actual_date         DATE,
    assigned_to         VARCHAR(100)    NOT NULL,
    budget_hours        NUMERIC(6, 1)   NOT NULL,
    actual_hours        NUMERIC(6, 1),
    hourly_rate         NUMERIC(8, 2)   NOT NULL,
    status              VARCHAR(30)     NOT NULL,
    created_at          TIMESTAMP       NOT NULL DEFAULT NOW()
);

INSERT INTO project_milestones
    (project_name, client_name, milestone_name, planned_date, actual_date,
     assigned_to, budget_hours, actual_hours, hourly_rate, status)
VALUES
    ('Data Platform Migration',  'Barclays',      'Requirements Gathering',    '2025-01-15', '2025-01-12', 'Amara Okafor',     40.0, 35.0,  125.00, 'Completed'),
    ('Data Platform Migration',  'Barclays',      'Architecture Design',       '2025-02-01', '2025-02-05', 'Amara Okafor',     60.0, 68.0,  125.00, 'Completed'),
    ('Data Platform Migration',  'Barclays',      'Bronze Layer Build',        '2025-03-15', '2025-03-20', 'Idris Mensah',     80.0, 85.0,  140.00, 'Completed'),
    ('Data Platform Migration',  'Barclays',      'Silver Layer Build',        '2025-04-30', NULL,         'Idris Mensah',     80.0, NULL,   140.00, 'In Progress'),
    ('Data Platform Migration',  'Barclays',      'Gold Layer Build',          '2025-06-15', NULL,         'Idris Mensah',     60.0, NULL,   140.00, 'Not Started'),
    ('E-Commerce Replatform',    'ASOS',          'Discovery Workshop',        '2025-02-10', '2025-02-08', 'Sienna Brooks',    24.0, 20.0,  110.00, 'Completed'),
    ('E-Commerce Replatform',    'ASOS',          'API Integration',           '2025-03-20', '2025-03-28', 'Callum Reid',      100.0, 112.0, 130.00, 'Completed'),
    ('E-Commerce Replatform',    'ASOS',          'Performance Testing',       '2025-04-25', NULL,         'Callum Reid',      40.0, NULL,   130.00, 'In Progress'),
    ('E-Commerce Replatform',    'ASOS',          'Go-Live Support',           '2025-05-30', NULL,         'Sienna Brooks',    30.0, NULL,   110.00, 'Not Started'),
    ('BI Dashboard Suite',       'Tesco',         'Stakeholder Interviews',    '2024-11-01', '2024-10-28', 'Priya Sharma',     20.0, 18.0,  120.00, 'Completed'),
    ('BI Dashboard Suite',       'Tesco',         'Data Model Design',         '2024-12-01', '2024-12-01', 'Priya Sharma',     50.0, 50.0,  120.00, 'Completed'),
    ('BI Dashboard Suite',       'Tesco',         'Dashboard Development',     '2025-01-31', '2025-02-10', 'Sage Mwangi',      70.0, 82.0,  115.00, 'Completed'),
    ('BI Dashboard Suite',       'Tesco',         'UAT & Sign-Off',           '2025-03-01', '2025-02-28', 'Sage Mwangi',      30.0, 25.0,  115.00, 'Completed'),
    ('Risk Analytics Platform',  'Standard Life', 'Data Sourcing',            '2025-01-20', '2025-01-22', 'Euan MacLeod',     35.0, 38.0,  118.00, 'Completed'),
    ('Risk Analytics Platform',  'Standard Life', 'Model Development',        '2025-03-01', '2025-03-10', 'Aisha Yusuf',      90.0, 95.0,  125.00, 'Completed'),
    ('Risk Analytics Platform',  'Standard Life', 'Backtesting',              '2025-04-15', NULL,         'Aisha Yusuf',      45.0, NULL,   125.00, 'In Progress'),
    ('Risk Analytics Platform',  'Standard Life', 'Deployment',               '2025-06-01', NULL,         'Euan MacLeod',     25.0, NULL,   118.00, 'Not Started'),
    ('Cloud Cost Optimisation',  'Sky',           'Cost Audit',               '2025-02-01', '2025-01-29', 'Wei Chen',         30.0, 28.0,  135.00, 'Completed'),
    ('Cloud Cost Optimisation',  'Sky',           'Rightsizing Implementation','2025-03-15', '2025-03-22', 'Arjun Nair',       50.0, 55.0,  150.00, 'Completed'),
    ('Cloud Cost Optimisation',  'Sky',           'Monitoring & Reporting',   '2025-04-30', NULL,         'Wei Chen',         35.0, NULL,   135.00, 'In Progress');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM employee_contracts;
-- Expected: 25

SELECT COUNT(*) FROM contract_invoices;
-- Expected: 30

SELECT COUNT(*) FROM project_milestones;
-- Expected: 20
```

## Exercises

You are a data analyst at a UK-based digital consultancy. The Head of Delivery, **Priya**, sends you a message before a board meeting on Friday. She needs three reports from the project tracking data.

The board needs clean, formatted numbers - no raw timestamps or unformatted decimals. Consultancies live and die by their project delivery performance, and the board needs to see trends before they become crises.

Using the `project_milestones` table, answer these questions:

### 🟢 Warm-Up

**Q1:** Use CURRENT_DATE and EXTRACT to find all milestones with a planned date in 2025. Show the project name, milestone name, planned date formatted as DD/MM/YYYY using TO_CHAR, and the quarter (using EXTRACT). Sort by planned date.

**Q2:** For each completed milestone, calculate how many days it took from planned date to actual date using simple date subtraction (actual_date - planned_date). Show the project name, milestone name, planned date, actual date, and the days difference. Sort by days difference descending.

### 🟡 Practice

**Q3:** Build a project timeline report. For each project, show the project name, client name, project start date (formatted as DD/MM/YYYY using TO_CHAR on the MIN of planned_date), the last completed milestone date (formatted using TO_CHAR on the MAX of actual_date), the planned finish date, total milestones, completed count, and in-progress count. Sort by project start date.

**Q4:** Build a milestone delivery performance report. For each completed milestone, show the project name, milestone name, assigned consultant, planned and actual dates (both formatted as DD/MM/YYYY), the days variance (actual_date - planned_date), a delivery status label using CASE WHEN ('Early', 'On time', or 'Late' with the number of days), and the cost variance in GBP formatted with TO_CHAR. Sort by cost variance descending.

**Q5:** Build a consultant utilisation summary. For each consultant, show total milestones, completed count, utilisation percentage (actual hours / budget hours * 100 using COALESCE and NULLIF), average days variance for completed milestones, and a performance flag ('Ahead of schedule', 'Slightly behind', or 'Needs attention'). Sort by utilisation percentage descending.

### 🔴 Challenge

**Q6:** Write a query that classifies each employee contract from `employee_contracts` into a tenure category: 'Long-term (1+ year)', 'Mid-term (6-12 months)', or 'Short-term (< 6 months)' using COALESCE to handle NULL end dates, AGE to calculate duration, and EXTRACT to pull the year count. Include the employee name, department, contract start date, years on contract, and the tenure category label.

**Q7:** Priya wants to know which months are the busiest for milestone completions, and whether those months tend to run over budget. Write a query that groups completed milestones by month (using DATE_TRUNC on actual_date, formatted with TO_CHAR as 'Mon YYYY'), showing the total milestones completed that month, the average days variance, the total cost overrun (SUM of (actual_hours - budget_hours) * hourly_rate for milestones that ran over), and the total cost saving for milestones that came in under budget. Sort chronologically.

## Key Concepts Covered
- **CURRENT_DATE and NOW()**: Self-updating date references so your queries never go stale
- **EXTRACT**: Pulls a single component (year, month, quarter, day of week) out of a date - the standard pattern for time-based grouping
- **DATE_TRUNC**: Rounds a date down to the start of a period and keeps it as a date - preferred for time series charts
- **AGE and INTERVAL**: Calculate durations between dates and add/subtract time periods - handles leap years and varying month lengths automatically
- **CAST and :: shorthand**: Convert between data types - essential for CSV imports and avoiding integer division
- **TO_CHAR and TO_DATE**: Format dates and numbers for board-ready reports, and parse date strings from external sources with explicit format patterns

---

[← Day 9: String & Numeric Functions](../day-09/) | [Day 11: CASE WHEN →](../day-11/)
