-- Day 02: SELECT & WHERE - Exercise Script
-- Run this in pgAdmin to create today's exercise table

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
