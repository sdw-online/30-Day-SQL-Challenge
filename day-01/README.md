# Day 1 - Introduction to SQL & Databases

[Watch the video](https://www.youtube.com/watch?v=mFIMPhiO-N0) | Start of challenge | [Day 2: SELECT & WHERE →](../day-02/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What SQL is and why every data role uses it daily
- How databases organise data into tables, rows, and columns
- The four essential data types: VARCHAR, INTEGER, DATE, and BOOLEAN
- What primary keys are and why every table needs one
- How to set up PostgreSQL and pgAdmin on your machine

## Prerequisites
- None - this is Day 1!

## Dataset

Run this SQL in pgAdmin to create today's practice table.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  UNIQUE NOT NULL,
    department      VARCHAR(50)   NOT NULL,
    job_title       VARCHAR(100)  NOT NULL,
    salary          INTEGER       NOT NULL,
    hire_date       DATE          NOT NULL,
    is_active       BOOLEAN       DEFAULT TRUE
);

INSERT INTO employees (first_name, last_name, email, department, job_title, salary, hire_date, is_active)
VALUES
    ('Amara',  'Osei',      'amara.osei@techcorp.com',      'Engineering',  'Data Engineer',          72000, '2025-01-15', TRUE),
    ('Ravi',   'Mehta',     'ravi.mehta@techcorp.com',       'Engineering',  'Backend Developer',      68000, '2025-02-01', TRUE),
    ('Isla',   'Campbell',  'isla.campbell@techcorp.com',     'Analytics',    'Data Analyst',           55000, '2025-03-10', TRUE),
    ('Kwame',  'Asante',    'kwame.asante@techcorp.com',     'Analytics',    'Analytics Engineer',     65000, '2025-01-20', TRUE),
    ('Freya',  'Lindqvist', 'freya.lindqvist@techcorp.com',  'Marketing',    'Marketing Analyst',      52000, '2025-04-05', TRUE),
    ('Mateo',  'Rivera',    'mateo.rivera@techcorp.com',     'Engineering',  'Senior Data Engineer',   85000, '2025-02-15', TRUE),
    ('Priya',  'Sharma',    'priya.sharma@techcorp.com',     'Product',      'Product Analyst',        58000, '2025-03-01', TRUE),
    ('Finn',   'O''Brien',  'finn.obrien@techcorp.com',      'Engineering',  'DevOps Engineer',        70000, '2025-05-12', TRUE),
    ('Yuki',   'Tanaka',    'yuki.tanaka@techcorp.com',      'Analytics',    'Senior Data Analyst',    67000, '2025-01-08', TRUE),
    ('Sienna', 'Walsh',     'sienna.walsh@techcorp.com',     'Marketing',    'Growth Analyst',         54000, '2025-06-01', FALSE);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM employees;
-- Expected: 10 rows
```

## Exercises

You've just joined TechCorp as a junior data analyst. It's your first day. Your manager, Priya, the Head of Analytics, sends you a message:

> "Welcome to the team! Before you can start querying our data, you need to get your tools set up. Install PostgreSQL and pgAdmin, create a database called sql_challenge, and connect to it. Once you're connected, let me know and I'll send you the employee data to load in."

Using the instructions below, complete these tasks:

### 🟢 Warm-Up

**Q1:** Install PostgreSQL and pgAdmin, create a database called `sql_challenge`, and open the Query Tool. Run `SELECT 'Hello, SQL!' AS greeting;` - what do you see?

**Q2:** Run `SELECT version();` in your Query Tool. What PostgreSQL version are you running?

### 🟡 Practice

**Q3:** Create the `employees` table using the dataset above, then run `SELECT * FROM employees;`. How many rows and columns does the table have?

**Q4:** Run `SELECT COUNT(*) FROM employees;` to verify the row count. Now run `SELECT * FROM employees;` and look at the column headers. List every column name and identify its data type (e.g. VARCHAR, INTEGER, DATE, BOOLEAN) based on the CREATE TABLE statement above.

### 🔴 Challenge

**Q5:** Looking at the `salary` column, explain why it is stored as INTEGER rather than TEXT. What would go wrong if salaries were stored as text and you tried to sort them from lowest to highest?

**Q6:** The `employee_id` column is defined as a `SERIAL PRIMARY KEY`. What two rules does a primary key enforce, and why would using `first_name` as the primary key cause problems if two employees shared the same first name?

## Key Concepts Covered
- **SQL (Structured Query Language):** The language used to communicate with databases - every data role uses it daily
- **Tables, rows, and columns:** Tables store data about one thing; columns define the structure, rows are the records
- **Data types:** VARCHAR (text with a max length), INTEGER (whole numbers), DATE (calendar dates), BOOLEAN (true/false)
- **Primary keys:** A column that uniquely identifies every row - must be unique and never empty
- **PostgreSQL & pgAdmin:** PostgreSQL is the database engine; pgAdmin is the graphical interface you use to write and run SQL

---

Start of challenge | [Day 2: SELECT & WHERE →](../day-02/)
