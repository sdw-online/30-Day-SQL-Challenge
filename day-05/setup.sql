-- Day 05: INSERT, UPDATE & DELETE - Setup Script
-- Run this in pgAdmin to create today's tables

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS products;

-- Create the products table
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(100)    NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    price_monthly   NUMERIC(8, 2)   NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    launch_date     DATE            NOT NULL,
    max_users       INTEGER         NOT NULL,
    region          VARCHAR(50)     NOT NULL DEFAULT 'Global'
);

-- Insert 15 products
INSERT INTO products (product_name, category, price_monthly, is_active, launch_date, max_users, region)
VALUES
    ('Starter Dashboard',       'Core Plan',    29.00,   TRUE,   '2024-01-15',   5,      'Global'),
    ('Growth Dashboard',        'Core Plan',    79.00,   TRUE,   '2024-01-15',   25,     'Global'),
    ('Enterprise Dashboard',    'Core Plan',    199.00,  TRUE,   '2024-01-15',   100,    'Global'),
    ('Real-Time Alerts',        'Add-On',       15.00,   TRUE,   '2024-03-01',   25,     'Global'),
    ('Custom Reports',          'Add-On',       25.00,   TRUE,   '2024-03-01',   25,     'Global'),
    ('API Access',              'Add-On',       45.00,   TRUE,   '2024-06-10',   50,     'Global'),
    ('White-Label Branding',    'Add-On',       35.00,   TRUE,   '2024-06-10',   10,     'Global'),
    ('Heatmap Tracker',         'Analytics',    19.00,   TRUE,   '2024-09-01',   25,     'UK'),
    ('SEO Audit Tool',          'Analytics',    39.00,   TRUE,   '2024-09-01',   10,     'UK'),
    ('Funnel Analyser',         'Analytics',    49.00,   TRUE,   '2025-01-10',   50,     'Global'),
    ('Session Replay',          'Analytics',    29.00,   FALSE,  '2024-04-15',   25,     'UK'),
    ('Legacy Tracker',          'Deprecated',   0.00,    FALSE,  '2023-06-01',   5,      'UK'),
    ('Beta Uptime Monitor',     'Beta',         0.00,    TRUE,   '2025-02-01',   10,     'Global'),
    ('A/B Test Runner',         'Analytics',    55.00,   TRUE,   '2025-03-01',   25,     'Global'),
    ('GDPR Compliance Pack',    'Add-On',       20.00,   TRUE,   '2025-01-20',   100,    'EU');

-- Create the support_tickets table
CREATE TABLE support_tickets (
    ticket_id       SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100)    NOT NULL,
    customer_email  VARCHAR(150)    NOT NULL,
    subject         VARCHAR(200)    NOT NULL,
    priority        VARCHAR(20)     NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Open',
    assigned_to     VARCHAR(100),
    created_date    DATE            NOT NULL,
    product_name    VARCHAR(100)    NOT NULL
);

-- Insert 25 support tickets
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    ('Amara Osei',      'amara@brightshop.co.uk',       'Dashboard not loading',            'High',     'Open',         'Ravi Kapoor',      '2025-03-01',   'Growth Dashboard'),
    ('Callum Fraser',   'callum@frasermedia.com',       'Cannot export PDF reports',        'Medium',   'Open',         'Priya Sharma',     '2025-03-02',   'Custom Reports'),
    ('Priya Deshpande', 'priya.d@technovate.io',        'API rate limit exceeded',          'High',     'In Progress',  'Wei Chen',         '2025-03-03',   'API Access'),
    ('Finn McCarthy',   'finn@greenleafcafe.ie',        'Billing discrepancy Q1',           'Low',      'Open',         NULL,               '2025-03-04',   'Starter Dashboard'),
    ('Isla Nguyen',     'isla@blueoceanhr.com',         'Heatmap data missing for Feb',     'High',     'In Progress',  'Safiya Abdi',      '2025-03-05',   'Heatmap Tracker'),
    ('Ravi Kapoor',     'ravi.k@kapoordesign.co.uk',    'White-label logo not rendering',   'Medium',   'Open',         NULL,               '2025-03-06',   'White-Label Branding'),
    ('Sienna Clarke',   'sienna@clarkeconsulting.com',  'Need to upgrade plan',             'Low',      'Resolved',     'Priya Sharma',     '2025-03-06',   'Starter Dashboard'),
    ('Euan Campbell',   'euan@campbelleng.co.uk',       'SEO audit timing out',             'High',     'Open',         'Wei Chen',         '2025-03-07',   'SEO Audit Tool'),
    ('Nia Williams',    'nia@williamsfinance.co.uk',     'GDPR report format question',      'Low',      'Resolved',     'Safiya Abdi',      '2025-03-08',   'GDPR Compliance Pack'),
    ('Kwame Mensah',    'kwame@mensahlogistics.com',    'Funnel drop-off not tracking',     'High',     'In Progress',  'Ravi Kapoor',      '2025-03-09',   'Funnel Analyser'),
    ('Mei Zhang',       'mei@zhangcreative.co.uk',      'Custom report filter broken',      'Medium',   'Open',         NULL,               '2025-03-10',   'Custom Reports'),
    ('Jamal Williams',  'jamal@jwdigital.com',          'Alert emails going to spam',       'Medium',   'Open',         'Priya Sharma',     '2025-03-11',   'Real-Time Alerts'),
    ('Safiya Noor',     'safiya@noorbeauty.co.uk',      'Session replay not recording',     'High',     'Cancelled',    NULL,               '2025-03-11',   'Session Replay'),
    ('Arjun Nair',      'arjun@nairanalytics.com',      'A/B test results inconsistent',    'High',     'Open',         'Wei Chen',         '2025-03-12',   'A/B Test Runner'),
    ('Quinn Taylor',    'quinn@taylorretail.co.uk',     'Dashboard slow on mobile',         'Medium',   'In Progress',  'Ravi Kapoor',      '2025-03-13',   'Enterprise Dashboard'),
    ('Wei Lin',         'wei.l@lintech.io',             'Cannot add team members',          'High',     'Open',         NULL,               '2025-03-14',   'Growth Dashboard'),
    ('Mateo Garcia',    'mateo@garciastudio.es',        'Uptime monitor false alarm',       'Low',      'Open',         'Safiya Abdi',      '2025-03-15',   'Beta Uptime Monitor'),
    ('Zara Ibrahim',    'zara@ibrahimlaw.co.uk',        'Invoice not matching usage',       'Medium',   'In Progress',  'Priya Sharma',     '2025-03-16',   'Enterprise Dashboard'),
    ('River Chen',      'river@chenmedia.com',          'Feature request: dark mode',       'Low',      'Resolved',     'Wei Chen',         '2025-03-17',   'Growth Dashboard'),
    ('Phoenix Taylor',  'phoenix@taylorfitness.co.uk',  'Heatmap colours not showing',      'Medium',   'Open',         NULL,               '2025-03-18',   'Heatmap Tracker'),
    ('Aisha Yusuf',     'aisha@yusufevents.com',        'Need to cancel subscription',      'Low',      'Cancelled',    'Priya Sharma',     '2025-03-19',   'Starter Dashboard'),
    ('Lucas Fernandez', 'lucas@fernandezdesign.com',    'SEO tool missing pages',           'High',     'Open',         'Safiya Abdi',      '2025-03-20',   'SEO Audit Tool'),
    ('Nina Volkov',     'nina@volkovtravel.co.uk',      'Real-time alert delay',            'High',     'In Progress',  'Ravi Kapoor',      '2025-03-21',   'Real-Time Alerts'),
    ('Sage Kowalski',   'sage@kowalskicraft.com',       'Funnel setup wizard broken',       'Medium',   'Open',         NULL,               '2025-03-22',   'Funnel Analyser'),
    ('Leila Hussain',   'leila@hussainconsult.co.uk',   'API documentation unclear',        'Low',      'Resolved',     'Wei Chen',         '2025-03-23',   'API Access');
