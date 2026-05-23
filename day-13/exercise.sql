-- Day 13: CTEs (Part 1) - Exercise Script
-- Exercise table: supply_chain_stages (25 rows)

DROP TABLE IF EXISTS supply_chain_stages;

CREATE TABLE supply_chain_stages (
    stage_id       SERIAL PRIMARY KEY,
    product_name   VARCHAR(100) NOT NULL,
    stage_name     VARCHAR(100) NOT NULL,
    stage_order    INTEGER      NOT NULL,
    location       VARCHAR(100) NOT NULL,
    cost           NUMERIC(8,2) NOT NULL,
    duration_days  INTEGER      NOT NULL,
    supplier_name  VARCHAR(100) NOT NULL,
    certification  VARCHAR(50)  NOT NULL
);

INSERT INTO supply_chain_stages
    (product_name, stage_name, stage_order, location, cost, duration_days, supplier_name, certification)
VALUES
    ('Organic Coffee',   'Harvesting',        1, 'Bogota',        1200.00,  14, 'Javier',   'Fair Trade'),
    ('Organic Coffee',   'Washing',           2, 'Bogota',         350.00,   3, 'Elena',    'Organic'),
    ('Organic Coffee',   'Drying',            3, 'Bogota',         280.00,   7, 'Javier',   'Organic'),
    ('Organic Coffee',   'Roasting',          4, 'Rotterdam',      900.00,   2, 'Magnus',   'ISO 9001'),
    ('Organic Coffee',   'Packaging',         5, 'Rotterdam',      420.00,   1, 'Magnus',   'ISO 9001'),
    ('Organic Coffee',   'Distribution',      6, 'London',         680.00,   5, 'Nils',     'BRC'),
    ('Dark Chocolate',   'Harvesting',        1, 'Accra',         1500.00,  21, 'Kiran',    'Fair Trade'),
    ('Dark Chocolate',   'Fermentation',      2, 'Accra',          600.00,   7, 'Kiran',    'Organic'),
    ('Dark Chocolate',   'Drying',            3, 'Accra',          320.00,   5, 'Kiran',    'Organic'),
    ('Dark Chocolate',   'Grinding',          4, 'Brussels',       750.00,   2, 'Camila',   'ISO 9001'),
    ('Dark Chocolate',   'Tempering',         5, 'Brussels',       880.00,   1, 'Camila',   'ISO 9001'),
    ('Dark Chocolate',   'Packaging',         6, 'Brussels',       390.00,   1, 'Lucia',    'BRC'),
    ('Dark Chocolate',   'Distribution',      7, 'Manchester',     720.00,   4, 'Nils',     'BRC'),
    ('Green Tea',        'Harvesting',        1, 'Kyoto',          980.00,  10, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Steaming',          2, 'Kyoto',          450.00,   1, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Rolling',           3, 'Kyoto',          380.00,   2, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Drying',            4, 'Kyoto',          290.00,   3, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Grading',           5, 'Osaka',          520.00,   2, 'Elena',    'ISO 9001'),
    ('Green Tea',        'Packaging',         6, 'Osaka',          340.00,   1, 'Elena',    'ISO 9001'),
    ('Green Tea',        'Distribution',      7, 'Edinburgh',      610.00,   6, 'Lucia',    'BRC'),
    ('Olive Oil',        'Harvesting',        1, 'Seville',       1100.00,  12, 'Javier',   'EU Organic'),
    ('Olive Oil',        'Pressing',          2, 'Seville',        650.00,   1, 'Javier',   'EU Organic'),
    ('Olive Oil',        'Filtering',         3, 'Seville',        420.00,   2, 'Camila',   'ISO 9001'),
    ('Olive Oil',        'Bottling',          4, 'Barcelona',      380.00,   1, 'Camila',   'ISO 9001'),
    ('Olive Oil',        'Distribution',      5, 'Bristol',        590.00,   5, 'Nils',     'BRC');
