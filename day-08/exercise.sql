-- Day 08: NULL Handling - Exercise Script
-- Run this in pgAdmin to create today's exercise table

-- Exercise table: Product catalogue with data gaps
DROP TABLE IF EXISTS product_catalogue;

CREATE TABLE product_catalogue (
    product_id          SERIAL PRIMARY KEY,
    product_name        VARCHAR(100)    NOT NULL,
    category            VARCHAR(50)     NOT NULL,
    unit_price          NUMERIC(10, 2)  NOT NULL,
    cost_price          NUMERIC(10, 2),
    weight_kg           NUMERIC(6, 2),
    supplier_name       VARCHAR(100),
    supplier_email      VARCHAR(100),
    stock_quantity       INTEGER         NOT NULL DEFAULT 0,
    reorder_level       INTEGER,
    last_restock_date   DATE,
    discontinued_date   DATE,
    warehouse_location  VARCHAR(20)
);

INSERT INTO product_catalogue (product_name, category, unit_price, cost_price, weight_kg, supplier_name, supplier_email, stock_quantity, reorder_level, last_restock_date, discontinued_date, warehouse_location)
VALUES
    ('Wireless Headphones',     'Electronics',      79.99,   42.00,  0.35,   'TechWave Ltd',         'orders@techwave.co.uk',    150,    30,     '2025-04-10',   NULL,           'A-12'),
    ('USB-C Charging Cable',    'Electronics',      12.99,   4.50,   0.08,   'TechWave Ltd',         'orders@techwave.co.uk',    500,    100,    '2025-05-01',   NULL,           'A-14'),
    ('Organic Coffee Beans',    'Food & Drink',     18.50,   9.25,   1.00,   'Highland Roasters',    'supply@highland.co.uk',    200,    50,     '2025-04-28',   NULL,           'C-03'),
    ('Bamboo Desk Organiser',   'Home & Office',    34.99,   NULL,   0.85,   'EcoGoods Co',          'hello@ecogoods.com',       75,     20,     '2025-03-15',   NULL,           'B-07'),
    ('Running Shoes',           'Sports',           95.00,   48.00,  0.65,   NULL,                   NULL,                       45,     15,     '2025-04-20',   NULL,           'D-01'),
    ('Yoga Mat',                'Sports',           29.99,   12.00,  1.20,   'FitLife Supplies',     'orders@fitlife.co.uk',     180,    40,     '2025-05-05',   NULL,           'D-03'),
    ('E-Book Reader',           'Electronics',      129.99,  68.00,  0.18,   'TechWave Ltd',         'orders@techwave.co.uk',    60,     15,     '2025-04-01',   NULL,           'A-10'),
    ('Herbal Tea Selection',    'Food & Drink',     14.99,   6.50,   0.45,   'Highland Roasters',    'supply@highland.co.uk',    300,    75,     '2025-05-10',   NULL,           'C-05'),
    ('Standing Desk Converter', 'Home & Office',    189.99,  95.00,  8.50,   'EcoGoods Co',          'hello@ecogoods.com',       20,     5,      '2025-03-01',   NULL,           'B-01'),
    ('Bluetooth Speaker',       'Electronics',      49.99,   22.00,  0.55,   'TechWave Ltd',         'orders@techwave.co.uk',    90,     25,     '2025-04-15',   NULL,           'A-11'),
    ('Protein Bars (Box)',      'Food & Drink',     24.99,   NULL,   0.60,   NULL,                   NULL,                       0,      30,     NULL,           '2025-04-01',   NULL),
    ('Laptop Stand',            'Home & Office',    44.99,   18.00,  1.10,   'EcoGoods Co',          'hello@ecogoods.com',       110,    25,     '2025-05-08',   NULL,           'B-05'),
    ('Digital Gift Card',       'Digital',          25.00,   NULL,   NULL,   NULL,                   NULL,                       999,    NULL,   NULL,           NULL,           NULL),
    ('Online Course Voucher',   'Digital',          50.00,   NULL,   NULL,   NULL,                   NULL,                       999,    NULL,   NULL,           NULL,           NULL),
    ('Reusable Water Bottle',   'Sports',           19.99,   7.50,   0.30,   'FitLife Supplies',     'orders@fitlife.co.uk',     220,    50,     '2025-04-25',   NULL,           'D-05'),
    ('Noise-Cancelling Buds',   'Electronics',      59.99,   28.00,  0.05,   'TechWave Ltd',         'orders@techwave.co.uk',    0,      20,     '2025-02-10',   '2025-05-01',   'A-13'),
    ('Scented Candle Set',      'Home & Office',    22.99,   NULL,   0.90,   NULL,                   NULL,                       35,     10,     '2025-03-20',   NULL,           'B-09'),
    ('Fitness Tracker',         'Electronics',      69.99,   35.00,  0.04,   'TechWave Ltd',         'orders@techwave.co.uk',    85,     20,     '2025-05-12',   NULL,           NULL),
    ('Organic Honey Jar',       'Food & Drink',     12.50,   5.00,   0.50,   'Highland Roasters',    'supply@highland.co.uk',    0,      25,     NULL,           '2025-03-15',   'C-04'),
    ('Desk Lamp (LED)',         'Home & Office',    39.99,   NULL,   1.80,   'EcoGoods Co',          'hello@ecogoods.com',       55,     15,     '2025-04-30',   NULL,           'B-06'),
    ('Cycling Gloves',          'Sports',           15.99,   6.00,   0.15,   'FitLife Supplies',     'orders@fitlife.co.uk',     0,      20,     NULL,           '2025-04-10',   'D-04'),
    ('Portable Charger',        'Electronics',      35.99,   15.00,  0.25,   NULL,                   NULL,                       140,    30,     '2025-05-15',   NULL,           NULL),
    ('Chamomile Tea Bags',      'Food & Drink',     8.99,    3.50,   0.30,   'Highland Roasters',    'supply@highland.co.uk',    250,    60,     '2025-05-18',   NULL,           'C-06'),
    ('Adjustable Dumbbells',    'Sports',           74.99,   38.00,  5.00,   NULL,                   NULL,                       30,     10,     '2025-04-08',   NULL,           'D-02'),
    ('Mechanical Keyboard',     'Electronics',      89.99,   45.00,  0.80,   'TechWave Ltd',         'orders@techwave.co.uk',    65,     15,     '2025-05-20',   NULL,           'A-15');
