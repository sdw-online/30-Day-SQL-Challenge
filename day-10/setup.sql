-- Day 10: Date Functions & CAST - Setup Script
-- Run this in pgAdmin to create today's tables

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
