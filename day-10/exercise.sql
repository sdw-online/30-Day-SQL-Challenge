-- Day 10: Date Functions & CAST - Exercise Script
-- Run this in pgAdmin to create today's exercise table

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
