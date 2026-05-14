-- Day 02: SELECT & WHERE - Setup Script
-- Run this in pgAdmin to create today's tables

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
