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
