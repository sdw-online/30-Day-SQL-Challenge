# Day 16 - JOINs Part 2: CROSS JOIN & Self Joins

[Watch the video](COMING_SOON) | [← Day 15: JOINs Part 1](../day-15/) | [Day 17: UNION & UNION ALL →](../day-17/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How CROSS JOIN generates every possible combination of two tables - and when you'd actually want that
- How self joins let you join a table to itself to query hierarchies, compare rows, and find colleague pairs
- How non-equi joins match values to ranges using BETWEEN instead of equals
- The `<` trick for producing unique pairs without duplicates

## Prerequisites
- Complete Days 1-15
- Comfortable with INNER, LEFT, RIGHT, and FULL OUTER JOINs (Day 15)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS project_assignments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salary_bands;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(80)     NOT NULL,
    floor_number    INTEGER         NOT NULL,
    budget          NUMERIC(12, 2)  NOT NULL
);

CREATE TABLE salary_bands (
    band_id         SERIAL PRIMARY KEY,
    band_name       VARCHAR(40)     NOT NULL,
    min_salary      NUMERIC(10, 2)  NOT NULL,
    max_salary      NUMERIC(10, 2)  NOT NULL
);

CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    job_title       VARCHAR(80)     NOT NULL,
    department_id   INTEGER         NOT NULL REFERENCES departments(department_id),
    manager_id      INTEGER         REFERENCES employees(employee_id),
    salary          NUMERIC(10, 2)  NOT NULL,
    hire_date       DATE            NOT NULL,
    city            VARCHAR(60)     NOT NULL
);

CREATE TABLE project_assignments (
    assignment_id   SERIAL PRIMARY KEY,
    employee_id     INTEGER         NOT NULL REFERENCES employees(employee_id),
    project_name    VARCHAR(100)    NOT NULL,
    role_on_project VARCHAR(60)     NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE
);

INSERT INTO departments (department_name, floor_number, budget)
VALUES
    ('Engineering',         3, 1200000.00),
    ('Data',                3,  850000.00),
    ('Product',             2,  600000.00),
    ('Sales',               1,  750000.00),
    ('Human Resources',     1,  400000.00),
    ('Finance',             2,  500000.00);

INSERT INTO salary_bands (band_name, min_salary, max_salary)
VALUES
    ('Junior',      28000.00,  40000.00),
    ('Mid-Level',   38000.00,  55000.00),
    ('Senior',      52000.00,  75000.00),
    ('Lead',        70000.00,  95000.00),
    ('Executive',   90000.00, 150000.00);

INSERT INTO employees (full_name, job_title, department_id, manager_id, salary, hire_date, city)
VALUES
    ('Adaeze Obi',          'Chief Executive Officer',      3, NULL,   135000.00, '2019-03-01', 'London'),
    ('Rohan Kapoor',        'VP of Engineering',            1, 1,       105000.00, '2020-06-15', 'London'),
    ('Isla Mackenzie',      'Head of Data',                 2, 1,        98000.00, '2020-09-01', 'Edinburgh'),
    ('Tariq El-Amin',       'Head of Product',              3, 1,        95000.00, '2021-01-10', 'London'),
    ('Ffion Harries',       'Sales Director',               4, 1,        92000.00, '2021-04-20', 'Cardiff'),
    ('Niamh Brennan',       'HR Director',                  5, 1,        88000.00, '2021-07-05', 'Manchester'),
    ('Kwame Mensah',        'Senior Software Engineer',     1, 2,        72000.00, '2022-02-14', 'London'),
    ('Anika Johansson',     'Senior Software Engineer',     1, 2,        70000.00, '2022-05-01', 'Bristol'),
    ('Declan Murray',       'Software Engineer',            1, 2,        52000.00, '2023-03-20', 'Manchester'),
    ('Priya Nair',          'Junior Developer',             1, 2,        35000.00, '2024-09-01', 'London'),
    ('Euan Forsyth',        'Senior Data Engineer',         2, 3,        68000.00, '2022-08-10', 'Edinburgh'),
    ('Yuki Tanaka',         'Data Analyst',                 2, 3,        48000.00, '2023-06-15', 'London'),
    ('Safiya Abdi',         'Junior Data Analyst',          2, 3,        32000.00, '2024-11-01', 'Edinburgh'),
    ('Luca Bianchi',        'Senior Product Manager',       3, 4,        74000.00, '2022-04-01', 'London'),
    ('Mei-Lin Chen',        'Product Manager',              3, 4,        55000.00, '2023-08-12', 'Bristol'),
    ('Oran Gallagher',      'Senior Account Manager',       4, 5,        62000.00, '2022-10-01', 'Cardiff'),
    ('Zara Hussain',        'Account Manager',              4, 5,        45000.00, '2023-11-20', 'London'),
    ('River Okonkwo',       'HR Business Partner',          5, 6,        50000.00, '2023-02-01', 'Manchester'),
    ('Callum Reid',         'Finance Manager',              6, 1,        65000.00, '2022-01-15', 'Edinburgh'),
    ('Amira Saeed',         'Finance Analyst',              6, 19,       42000.00, '2024-06-01', 'Edinburgh');

INSERT INTO project_assignments (employee_id, project_name, role_on_project, start_date, end_date)
VALUES
    (2,  'Platform Migration',   'Technical Lead',       '2024-09-01', NULL),
    (7,  'Platform Migration',   'Backend Developer',    '2024-09-01', NULL),
    (8,  'Platform Migration',   'Backend Developer',    '2024-09-15', NULL),
    (9,  'Platform Migration',   'Frontend Developer',   '2024-10-01', NULL),
    (11, 'Platform Migration',   'Data Engineer',        '2024-09-01', NULL),
    (3,  'Customer Analytics Dashboard',  'Project Sponsor',     '2024-07-01', '2025-01-31'),
    (12, 'Customer Analytics Dashboard',  'Lead Analyst',        '2024-07-01', '2025-01-31'),
    (13, 'Customer Analytics Dashboard',  'Junior Analyst',      '2024-11-01', '2025-01-31'),
    (14, 'Customer Analytics Dashboard',  'Product Owner',       '2024-07-01', '2025-01-31'),
    (15, 'Customer Analytics Dashboard',  'Product Manager',     '2024-08-01', '2025-01-31'),
    (5,  'Sales CRM Rollout',    'Executive Sponsor',    '2025-01-15', NULL),
    (16, 'Sales CRM Rollout',    'Implementation Lead',  '2025-01-15', NULL),
    (17, 'Sales CRM Rollout',    'User Champion',        '2025-01-15', NULL),
    (7,  'Sales CRM Rollout',    'Integration Developer','2025-02-01', NULL),
    (6,  'Employee Wellbeing Programme', 'Programme Lead',      '2025-02-01', NULL),
    (18, 'Employee Wellbeing Programme', 'HR Coordinator',      '2025-02-01', NULL),
    (19, 'Employee Wellbeing Programme', 'Budget Owner',        '2025-02-01', NULL),
    (20, 'Employee Wellbeing Programme', 'Finance Support',     '2025-03-01', NULL),
    (3,  'Data Warehouse Rebuild', 'Project Sponsor',    '2025-03-01', NULL),
    (11, 'Data Warehouse Rebuild', 'Lead Engineer',       '2025-03-01', NULL),
    (12, 'Data Warehouse Rebuild', 'Analytics Engineer',  '2025-03-01', NULL),
    (9,  'Data Warehouse Rebuild', 'Backend Developer',   '2025-04-01', NULL),
    (19, 'Q1 Revenue Forecast',  'Lead Analyst',         '2025-01-05', '2025-03-31'),
    (20, 'Q1 Revenue Forecast',  'Supporting Analyst',   '2025-01-05', '2025-03-31'),
    (5,  'Q1 Revenue Forecast',  'Sales Data Provider',  '2025-01-05', '2025-03-31'),
    (1,  'Annual Strategy Review',  'Chair',             '2025-01-10', '2025-02-28'),
    (2,  'Annual Strategy Review',  'Engineering Rep',   '2025-01-10', '2025-02-28'),
    (3,  'Annual Strategy Review',  'Data Rep',          '2025-01-10', '2025-02-28'),
    (4,  'Annual Strategy Review',  'Product Rep',       '2025-01-10', '2025-02-28'),
    (5,  'Annual Strategy Review',  'Sales Rep',         '2025-01-10', '2025-02-28');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM departments;
-- Expected: 6 rows

SELECT COUNT(*) FROM salary_bands;
-- Expected: 5 rows

SELECT COUNT(*) FROM employees;
-- Expected: 20 rows

SELECT COUNT(*) FROM project_assignments;
-- Expected: 30 rows
```

## Exercises

You are a product manager at a UK software consultancy with 20 employees. The Head of People, Marcus, stops you on Monday morning. He has got a restructuring presentation on Wednesday, and he needs answers fast.

Marcus needs clean, accurate numbers before Wednesday. If the restructuring recommendations are based on gut feeling instead of data, the board will push back.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Write a CROSS JOIN between `departments` and `salary_bands`. How many rows does it produce? Why is that number what it is?

**Q2:** Use a self join to list every employee alongside their manager's name. Include the CEO (who has no manager) in your results. Which join type should you use to keep the CEO visible?

### 🟡 Practice

**Q3:** Build a workforce planning matrix showing which departments have gaps in which salary bands. Use a CROSS JOIN to create every department-band combination, then count how many employees fill each cell. Which cells are marked as "GAP" (zero employees)?

**Q4:** Build a management hierarchy report with salary compression analysis. Show each employee alongside their manager's name, both salaries, and the percentage of the manager's salary the employee earns. Flag any cases where an employee earns 90% or more of their manager's salary as "CRITICAL."

**Q5:** Build a collaboration map showing which pairs of employees share the most projects. Include whether each pair works in the same department or across departments. Which pair shares the most projects?

### 🔴 Challenge

**Q6:** Find all pairs of employees from different departments whose salaries are within $3,000 of each other. Which cross-department pair has the smallest salary gap, and what are their roles?

**Q7:** Combine a CROSS JOIN, a non-equi join, and a LEFT JOIN in a single query: generate every department-band combination, classify each employee into their highest matching salary band (using BETWEEN with DISTINCT ON), then LEFT JOIN the results onto the framework. Show headcount per cell and flag cells as "GAP", "Single", or "Staffed." Which department has the best salary band coverage?

## Key Concepts Covered
- **CROSS JOIN:** Pairs every row from one table with every row from another - no ON clause, no matching condition. Useful for building calendar tables, test matrices, and workforce planning grids
- **Self join:** Joining a table to itself using two different aliases - essential for employee-manager hierarchies and comparing rows within the same table
- **Non-equi join:** Using BETWEEN or inequalities in the ON clause instead of equals - ideal for matching values to ranges like salary bands
- **The `<` trick for unique pairs:** Using `a.id < b.id` instead of `a.id != b.id` to avoid duplicate pairs and self-pairs
- **DISTINCT ON:** A PostgreSQL-specific feature that keeps only the first row per group based on your ORDER BY

---

[← Day 15: JOINs Part 1](../day-15/) | [Day 17: UNION & UNION ALL →](../day-17/)
