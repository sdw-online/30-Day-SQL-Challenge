-- Day 12: Subqueries & Temp Tables - Setup Script
-- Teaching table: grocery_purchases (25 rows)
-- Exercise table: school_results (30 rows)

DROP TABLE IF EXISTS grocery_purchases;

CREATE TABLE grocery_purchases (
    purchase_id   SERIAL PRIMARY KEY,
    item_name     VARCHAR(100) NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    price         NUMERIC(6,2) NOT NULL,
    store_name    VARCHAR(50)  NOT NULL,
    purchase_date DATE         NOT NULL,
    shopper_name  VARCHAR(50)  NOT NULL
);

INSERT INTO grocery_purchases
    (item_name, category, price, store_name, purchase_date, shopper_name)
VALUES
    ('Chicken Breast',     'Protein',    7.80,  'FreshMart',    '2025-04-01', 'Kofi'),
    ('Brown Rice',         'Grains',     2.50,  'GreenGrocer',  '2025-04-01', 'Nyla'),
    ('Broccoli',           'Produce',    1.90,  'FreshMart',    '2025-04-02', 'Dante'),
    ('Greek Yoghurt',      'Dairy',      4.20,  'QuickStop',    '2025-04-02', 'Maren'),
    ('Granola Bars',       'Snacks',     3.60,  'WholeBasket',  '2025-04-02', 'Suki'),
    ('Orange Juice',       'Beverages',  3.10,  'FreshMart',    '2025-04-03', 'Kofi'),
    ('Salmon Fillet',      'Protein',   14.50,  'WholeBasket',  '2025-04-03', 'Nyla'),
    ('Whole Wheat Bread',  'Grains',     3.40,  'GreenGrocer',  '2025-04-03', 'Dante'),
    ('Spinach',            'Produce',    2.10,  'FreshMart',    '2025-04-04', 'Maren'),
    ('Cheddar Cheese',     'Dairy',      5.60,  'QuickStop',    '2025-04-04', 'Suki'),
    ('Trail Mix',          'Snacks',     4.80,  'WholeBasket',  '2025-04-05', 'Kofi'),
    ('Sparkling Water',    'Beverages',  1.20,  'GreenGrocer',  '2025-04-05', 'Nyla'),
    ('Minced Beef',        'Protein',    6.90,  'FreshMart',    '2025-04-05', 'Dante'),
    ('Pasta',              'Grains',     1.80,  'QuickStop',    '2025-04-06', 'Maren'),
    ('Bananas',            'Produce',    1.40,  'GreenGrocer',  '2025-04-06', 'Suki'),
    ('Milk',               'Dairy',      2.30,  'FreshMart',    '2025-04-07', 'Kofi'),
    ('Crisps',             'Snacks',     2.90,  'QuickStop',    '2025-04-07', 'Nyla'),
    ('Herbal Tea',         'Beverages',  3.70,  'WholeBasket',  '2025-04-08', 'Dante'),
    ('Eggs',               'Protein',    4.10,  'GreenGrocer',  '2025-04-08', 'Maren'),
    ('Oats',               'Grains',     2.80,  'FreshMart',    '2025-04-09', 'Suki'),
    ('Tomatoes',           'Produce',    2.60,  'GreenGrocer',  '2025-04-09', 'Kofi'),
    ('Butter',             'Dairy',      3.50,  'QuickStop',    '2025-04-09', 'Nyla'),
    ('Dark Chocolate',     'Snacks',     5.20,  'WholeBasket',  '2025-04-10', 'Dante'),
    ('Apple Juice',        'Beverages',  2.90,  'FreshMart',    '2025-04-10', 'Maren'),
    ('Prawns',             'Protein',   11.40,  'WholeBasket',  '2025-04-10', 'Suki');
