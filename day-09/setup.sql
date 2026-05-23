-- ============================================
-- DAY 9 SETUP: Messy customer data for cleaning
-- ============================================
-- This creates a realistic dataset from a UK
-- e-commerce company with data quality issues
-- that need string and numeric functions to fix

DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(100)    NOT NULL,
    last_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    phone           VARCHAR(30),
    city            VARCHAR(80)     NOT NULL,
    country         VARCHAR(80)     NOT NULL,
    signup_date     DATE            NOT NULL,
    total_spent     NUMERIC(12, 2)  NOT NULL,
    discount_pct    NUMERIC(5, 2),
    product_code    VARCHAR(30),
    notes           VARCHAR(300)
);

-- INSERT: 25 customers with intentional data quality issues

INSERT INTO raw_customers (first_name, last_name, email, phone, city, country, signup_date, total_spent, discount_pct, product_code, notes)
VALUES
    ('  amara',     'OKAFOR',       'Amara.Okafor@GMAIL.COM',       '+44 7700 900123',  '  london  ',       'united kingdom',   '2025-01-15',   1249.99,    12.50,  'UK-ELEC-2025-0441',    'VIP customer - handle with care'),
    ('CALLUM',      '  reid',       'CALLUM.REID@OUTLOOK.COM',      '07700 900456',     'EDINBURGH',        'UNITED KINGDOM',   '2025-02-03',   87.45,      NULL,   'UK-HOME-2025-0112',    'first time buyer'),
    ('priya',       'Sharma',       'priya.sharma@Yahoo.co.uk',     '+447700900789',    'London',           'United Kingdom',   '2025-01-22',   3450.00,    7.75,   'UK-FASH-2025-0287',    '  RETURNS FREQUENTLY  '),
    ('  FINN  ',    'gallagher',    'finn.gallagher@gmail.com',     '0161 496 0000',    'manchester  ',     'united kingdom',   '2024-11-10',   562.30,     15.00,  'UK-ELEC-2025-0398',    'Loyal customer since 2024'),
    ('Isla',        'CAMPBELL',     'isla.campbell@Hotmail.COM',    '+44 131 496 0001', '  Edinburgh',      'United Kingdom',   '2025-03-01',   2105.75,    10.00,  'UK-HOME-2025-0445',    NULL),
    ('ravi  ',      'PATEL',        'RAVI.PATEL@COMPANY.CO.UK',     '07911 123456',     'london',           'UNITED KINGDOM',   '2025-01-08',   945.60,     5.25,   'UK-FASH-2025-0190',    'corporate account'),
    ('SIENNA',      'brooks',       'Sienna.Brooks@gmail.com',      '+44 117 496 0002', 'Bristol',          'united kingdom',   '2025-04-12',   178.90,     NULL,   'UK-GROC-2025-0567',    'NEW CUSTOMER - NEEDS WELCOME EMAIL'),
    ('  idris',     'MENSAH  ',     'idris.mensah@YAHOO.COM',       '07700 900321',     'LONDON  ',         'United Kingdom',   '2024-12-05',   4782.15,    20.00,  'UK-ELEC-2025-0502',    'premium member'),
    ('FREYA',       '  nilsson',    'FREYA.NILSSON@outlook.com',    '+46 70 123 4567',  'Stockholm',        'sweden',           '2025-02-18',   1567.80,    8.50,   'SE-HOME-2025-0089',    'International shipping required'),
    ('euan  ',      'MacLeod',      'euan.macleod@Gmail.Com',       '07700 900654',     '  edinburgh  ',    'UNITED KINGDOM',   '2025-03-22',   324.10,     NULL,   'UK-GROC-2025-0601',    'prefers email contact'),
    ('NIA',         'williams',     'nia.williams@COMPANY.CO.UK',   '+44 29 2049 6000', 'Cardiff',          'united kingdom',   '2025-01-30',   6230.00,    12.00,  'UK-ELEC-2025-0389',    '  Key account manager: Priya  '),
    ('kwame  ',     'ASANTE',       'Kwame.Asante@outlook.com',     '0161 496 0003',    'Manchester',       'United Kingdom',   '2024-10-15',   789.25,     3.75,   'UK-FASH-2025-0211',    'Referred by Ravi Patel'),
    ('  MEI  ',     'zhang',        'mei.zhang@GMAIL.COM',          '+86 138 0013 8000','  Shanghai  ',     'china',            '2025-04-01',   2890.50,    15.00,  'CN-ELEC-2025-0045',    'bulk order - wholesale pricing'),
    ('JAMAL',       '  hassan  ',   'jamal.hassan@yahoo.co.uk',     '07700 900987',     'bristol',          'UNITED KINGDOM',   '2025-02-14',   156.75,     NULL,   'UK-GROC-2025-0588',    'GIFT PURCHASE'),
    ('safiya',      'ABDI',         'Safiya.Abdi@Hotmail.com',      '+44 20 7946 0958', 'London',           'united kingdom',   '2025-03-10',   1834.20,    9.00,   'UK-HOME-2025-0334',    'delivery to office address'),
    ('  arjun',     'nair  ',       'ARJUN.NAIR@company.co.uk',     '07911 654321',     'MANCHESTER  ',     'United Kingdom',   '2024-09-28',   5120.00,    18.50,  'UK-ELEC-2025-0478',    '  corporate account  '),
    ('Quinn',       'TAYLOR',       'quinn.taylor@Gmail.COM',       '+1 212 555 0147',  'New York',         'united states',    '2025-01-05',   3275.90,    11.25,  'US-FASH-2025-0023',    'International - USD pricing'),
    ('  WEI',       'chen  ',       'WEI.CHEN@outlook.com',         '+886 2 2771 3456', '  Taipei  ',       'taiwan',           '2025-04-08',   467.80,     6.00,   'TW-ELEC-2025-0012',    'express shipping requested'),
    ('mateo',       'RIVERA',       'Mateo.Rivera@yahoo.com',       '+34 91 555 1234',  'Madrid',           'SPAIN',            '2025-02-25',   2156.40,    14.75,  'ES-HOME-2025-0034',    NULL),
    ('  RIVER  ',   'jordan',       'river.jordan@GMAIL.COM',       '07700 900111',     'manchester',       'united kingdom',   '2025-03-15',   98.50,      NULL,   'UK-GROC-2025-0612',    'student discount applied'),
    ('Aisha',       '  yusuf',      'AISHA.YUSUF@Outlook.com',      '+44 121 496 0004', 'Birmingham',       'United Kingdom',   '2025-01-18',   1445.30,    7.00,   'UK-FASH-2025-0255',    'LOYAL CUSTOMER - 3 YEARS'),
    ('  liam  ',    'FLETCHER',     'liam.fletcher@YAHOO.CO.UK',    '07700 900222',     'BRISTOL  ',        'UNITED KINGDOM',   '2025-04-20',   612.90,     4.50,   'UK-HOME-2025-0401',    'repeat buyer'),
    ('Yuki',        'tanaka  ',     'yuki.tanaka@gmail.com',        '+81 3 1234 5678',  'Tokyo',            'japan',            '2025-03-05',   7890.00,    22.00,  'JP-ELEC-2025-0008',    'Wholesale account - large orders'),
    ('  SAGE',      'mwangi',       'SAGE.MWANGI@company.co.uk',    '+254 20 271 0000', 'Nairobi',          'kenya',            '2025-02-10',   345.60,     NULL,   'KE-GROC-2025-0003',    '  new international customer  '),
    ('PHOENIX',     '  oduya  ',    'phoenix.oduya@Hotmail.COM',    '07700 900333',     '  London',         'united kingdom',   '2025-04-15',   2678.45,    16.50,  'UK-ELEC-2025-0521',    'referred by Idris Mensah');

-- Verify: Expected 25 rows
SELECT COUNT(*) AS total_customers FROM raw_customers;
