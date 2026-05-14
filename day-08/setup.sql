-- Day 08: NULL Handling - Setup Script
-- Run this in pgAdmin to create today's tables

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS customer_orders;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    email           VARCHAR(100),
    phone           VARCHAR(20),
    city            VARCHAR(50)     NOT NULL,
    signup_date     DATE            NOT NULL,
    referral_source VARCHAR(50),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: customer_orders
CREATE TABLE customer_orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customers(customer_id),
    order_date      DATE            NOT NULL,
    total_amount    NUMERIC(10, 2)  NOT NULL,
    discount_code   VARCHAR(20),
    discount_pct    NUMERIC(5, 2),
    shipping_date   DATE,
    delivery_date   DATE,
    delivery_note   VARCHAR(200),
    order_status    VARCHAR(20)     NOT NULL DEFAULT 'pending'
);

-- INSERT: 20 customers with intentional NULL patterns
INSERT INTO customers (first_name, last_name, email, phone, city, signup_date, referral_source, is_active)
VALUES
    ('Amara',   'Okafor',    'amara.okafor@email.com',     '+44 7700 100001',  'London',       '2024-03-10',   'Google Ads',       TRUE),
    ('Callum',  'Reid',      'callum.reid@email.com',      '+44 7700 100002',  'Edinburgh',    '2024-05-22',   'Referral',         TRUE),
    ('Priya',   'Sharma',    NULL,                         '+44 7700 100003',  'London',       '2024-07-15',   NULL,               TRUE),
    ('Finn',    'Gallagher', 'finn.g@email.com',           NULL,               'Manchester',   '2024-08-01',   'Instagram',        TRUE),
    ('Isla',    'Campbell',  'isla.campbell@email.com',     '+44 7700 100005',  'Edinburgh',    '2024-09-12',   'Google Ads',       TRUE),
    ('Ravi',    'Patel',     NULL,                         NULL,               'London',       '2024-10-05',   NULL,               TRUE),
    ('Sienna',  'Brooks',    'sienna.b@email.com',         '+44 7700 100007',  'Bristol',      '2024-11-20',   'Referral',         FALSE),
    ('Idris',   'Mensah',    'idris.mensah@email.com',     '+44 7700 100008',  'London',       '2024-12-01',   'Organic Search',   TRUE),
    ('Freya',   'Nilsson',   'freya.n@email.com',          NULL,               'Manchester',   '2025-01-08',   NULL,               TRUE),
    ('Euan',    'MacLeod',   NULL,                         '+44 7700 100010',  'Edinburgh',    '2025-01-15',   'Instagram',        TRUE),
    ('Nia',     'Williams',  'nia.williams@email.com',     '+44 7700 100011',  'London',       '2025-02-03',   'Google Ads',       TRUE),
    ('Kwame',   'Asante',    'kwame.a@email.com',          '+44 7700 100012',  'Manchester',   '2025-02-18',   'Referral',         TRUE),
    ('Mei',     'Zhang',     NULL,                         '+44 7700 100013',  'London',       '2025-03-01',   'Organic Search',   TRUE),
    ('Jamal',   'Hassan',    'jamal.hassan@email.com',     NULL,               'Bristol',      '2025-03-10',   NULL,               TRUE),
    ('Safiya',  'Abdi',      'safiya.abdi@email.com',      '+44 7700 100015',  'London',       '2025-03-22',   'Instagram',        TRUE),
    ('Arjun',   'Nair',      NULL,                         NULL,               'Manchester',   '2025-04-05',   NULL,               FALSE),
    ('Quinn',   'Taylor',    'quinn.t@email.com',          '+44 7700 100017',  'London',       '2025-04-15',   'Google Ads',       TRUE),
    ('Wei',     'Chen',      'wei.chen@email.com',         '+44 7700 100018',  'Edinburgh',    '2025-05-01',   NULL,               TRUE),
    ('Mateo',   'Rivera',    NULL,                         '+44 7700 100019',  'Bristol',      '2025-05-20',   'Referral',         TRUE),
    ('River',   'Jordan',    'river.j@email.com',          NULL,               'Manchester',   '2025-06-01',   NULL,               TRUE);

-- INSERT: 30 orders with intentional NULL patterns
INSERT INTO customer_orders (customer_id, order_date, total_amount, discount_code, discount_pct, shipping_date, delivery_date, delivery_note, order_status)
VALUES
    (1,  '2025-01-05',  89.99,   'WELCOME10',   10.00,  '2025-01-06',  '2025-01-09',  'Leave at front door',          'delivered'),
    (1,  '2025-02-14',  245.00,  NULL,           NULL,   '2025-02-15',  '2025-02-18',  NULL,                           'delivered'),
    (2,  '2025-01-12',  67.50,   'WINTER15',    15.00,  '2025-01-13',  '2025-01-16',  'Ring doorbell',                'delivered'),
    (3,  '2025-01-20',  120.00,  NULL,           NULL,   '2025-01-21',  '2025-01-25',  NULL,                           'delivered'),
    (4,  '2025-02-01',  340.00,  'FLASH20',     20.00,  '2025-02-02',  '2025-02-05',  'Leave with neighbour at no.4', 'delivered'),
    (5,  '2025-02-10',  55.00,   NULL,           NULL,   '2025-02-11',  '2025-02-14',  NULL,                           'delivered'),
    (6,  '2025-02-15',  199.99,  'LOYALTY10',   10.00,  '2025-02-16',  '2025-02-20',  'Fragile items inside',         'delivered'),
    (7,  '2025-02-20',  78.50,   NULL,           NULL,   '2025-02-21',  NULL,           NULL,                           'returned'),
    (8,  '2025-03-01',  425.00,  'VIP25',       25.00,  '2025-03-02',  '2025-03-05',  NULL,                           'delivered'),
    (9,  '2025-03-05',  92.00,   NULL,           NULL,   '2025-03-06',  '2025-03-10',  'Call before delivery',         'delivered'),
    (10, '2025-03-08',  156.75,  'SPRING10',    10.00,  '2025-03-09',  '2025-03-12',  NULL,                           'delivered'),
    (11, '2025-03-12',  310.00,  NULL,           NULL,   '2025-03-13',  '2025-03-16',  'Deliver after 5pm',            'delivered'),
    (12, '2025-03-15',  88.25,   'REFER20',     20.00,  '2025-03-16',  '2025-03-19',  NULL,                           'delivered'),
    (1,  '2025-03-20',  175.50,  NULL,           NULL,   '2025-03-21',  '2025-03-24',  'Leave at front door',          'delivered'),
    (13, '2025-03-25',  260.00,  'WELCOME10',   10.00,  '2025-03-26',  '2025-03-30',  NULL,                           'delivered'),
    (14, '2025-04-01',  142.00,  NULL,           NULL,   '2025-04-02',  '2025-04-06',  NULL,                           'delivered'),
    (3,  '2025-04-05',  315.00,  'FLASH20',     20.00,  '2025-04-06',  '2025-04-09',  NULL,                           'delivered'),
    (15, '2025-04-10',  67.99,   NULL,           NULL,   '2025-04-11',  '2025-04-14',  'Ring doorbell',                'delivered'),
    (5,  '2025-04-15',  198.50,  'LOYALTY10',   10.00,  '2025-04-16',  '2025-04-20',  NULL,                           'delivered'),
    (16, '2025-04-20',  450.00,  NULL,           NULL,   NULL,           NULL,           NULL,                           'cancelled'),
    (17, '2025-04-25',  230.00,  'SPRING10',    10.00,  '2025-04-26',  NULL,           'Leave in safe place',          'shipped'),
    (18, '2025-05-01',  89.00,   NULL,           NULL,   '2025-05-02',  NULL,           NULL,                           'shipped'),
    (2,  '2025-05-05',  167.50,  'REFER20',     20.00,  '2025-05-06',  NULL,           'Deliver after 6pm',            'shipped'),
    (19, '2025-05-10',  520.00,  NULL,           NULL,   NULL,           NULL,           NULL,                           'pending'),
    (20, '2025-05-12',  95.00,   'WELCOME10',   10.00,  NULL,           NULL,           'Call before delivery',         'pending'),
    (8,  '2025-05-15',  380.00,  'VIP25',       25.00,  NULL,           NULL,           NULL,                           'pending'),
    (11, '2025-05-18',  210.00,  NULL,           NULL,   NULL,           NULL,           'Fragile items inside',         'processing'),
    (4,  '2025-05-20',  145.00,  'FLASH20',     20.00,  NULL,           NULL,           NULL,                           'processing'),
    (6,  '2025-05-22',  275.00,  NULL,           NULL,   NULL,           NULL,           'Leave with neighbour at no.4', 'processing'),
    (9,  '2025-05-25',  188.00,  'LOYALTY10',   10.00,  NULL,           NULL,           NULL,                           'pending');
