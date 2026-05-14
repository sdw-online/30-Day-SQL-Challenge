-- Day 01: Introduction to SQL & Databases - Setup Script
-- Run this in pgAdmin to create today's tables

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
