-- Day 09: String & Numeric Functions - Exercise Script
-- Run this in pgAdmin to create today's exercise table

-- Messy product catalogue data for the exercise
DROP TABLE IF EXISTS raw_products;

CREATE TABLE raw_products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(200)    NOT NULL,
    category        VARCHAR(80)     NOT NULL,
    supplier_name   VARCHAR(150)    NOT NULL,
    sku             VARCHAR(50)     NOT NULL,
    unit_price      NUMERIC(10, 2)  NOT NULL,
    cost_price      NUMERIC(10, 2)  NOT NULL,
    weight_grams    NUMERIC(10, 2),
    description     VARCHAR(500),
    warehouse_code  VARCHAR(30)     NOT NULL
);

INSERT INTO raw_products (product_name, category, supplier_name, sku, unit_price, cost_price, weight_grams, description, warehouse_code)
VALUES
    ('  wireless bluetooth HEADPHONES  ',   'ELECTRONICS',      '  TechFlow Solutions  ',       'EL-WBH-2025-001',     79.99,      42.567,     285.50,     'Premium wireless headphones with NOISE CANCELLATION and 30hr battery',     'WH-LON-EAST-01'),
    ('organic GREEN TEA bags',              'Groceries',        'Highland Harvest Ltd',         'GR-OGT-2025-015',     4.99,       2.134,      125.00,     '  100 BAGS of organic green tea from Scottish highlands  ',                'WH-EDI-NORTH-02'),
    ('COTTON bed SHEET set',                '  home & living',  'CozyNest Home  ',              'HM-CBS-2025-042',     54.99,      28.753,     1850.75,    'King size cotton sheet set - 400 THREAD COUNT',                           'WH-MAN-WEST-01'),
    ('running SHOES pro  ',                 'FASHION',          'UrbanStride UK',               'FA-RSP-2025-008',     129.99,     67.891,     680.00,     'Professional running shoes with GEL CUSHIONING technology',               'WH-LON-EAST-01'),
    ('  STAINLESS steel water BOTTLE',      'Home & Living',    '  EcoWare Direct',             'HM-SSW-2025-033',     24.99,      11.456,     450.25,     'Double-walled insulated bottle - keeps drinks HOT 12hrs COLD 24hrs',      'WH-BRI-SOUTH-01'),
    ('vitamin D3 SUPPLEMENTS',              'groceries  ',      'NatureWell Health  ',          'GR-VD3-2025-022',     12.99,      5.678,      200.00,     '365 tablets - one a day VITAMIN D3 supplement  ',                         'WH-EDI-NORTH-02'),
    ('LAPTOP stand ADJUSTABLE',             'Electronics',      'TechFlow Solutions',           'EL-LSA-2025-019',     39.99,      18.234,     1200.50,    '  Ergonomic aluminium laptop stand - ADJUSTABLE HEIGHT  ',                'WH-LON-EAST-01'),
    ('  merino WOOL socks  ',               'fashion',          'Highland Harvest Ltd  ',       'FA-MWS-2025-031',     18.99,      8.912,      95.00,      'Pack of 3 merino wool hiking socks - BREATHABLE and warm',                'WH-MAN-WEST-01'),
    ('ceramic PLANT pot set',               'HOME & LIVING',    'CozyNest Home',                'HM-CPP-2025-055',     32.99,      15.678,     2400.00,    'Set of 3 ceramic plant pots with DRAINAGE HOLES',                        'WH-BRI-SOUTH-01'),
    ('  USB-C charging CABLE  ',            'electronics',      '  TechFlow Solutions',         'EL-UCC-2025-027',     9.99,       3.456,      45.75,      'Fast charging USB-C cable - 2 METRES braided nylon',                     'WH-LON-EAST-01'),
    ('ORGANIC honey JAR',                   'Groceries',        'Highland Harvest Ltd',         'GR-OHJ-2025-009',     8.99,       4.123,      500.00,     'Raw organic Scottish WILDFLOWER honey - 340g jar',                       'WH-EDI-NORTH-02'),
    ('yoga MAT premium  ',                  '  Fashion  ',      'UrbanStride UK  ',             'FA-YMP-2025-044',     44.99,      22.567,     1800.00,    '  Extra thick 6mm YOGA mat with carrying strap  ',                       'WH-MAN-WEST-01'),
    ('smart LED bulb SET',                  'ELECTRONICS',      'TechFlow Solutions',           'EL-SLB-2025-036',     29.99,      14.891,     320.00,     'Pack of 4 WiFi-enabled LED bulbs - 16 MILLION colours',                  'WH-LON-EAST-01'),
    ('  bamboo CHOPPING board',             'home & living',    'EcoWare Direct',               'HM-BCB-2025-061',     19.99,      9.234,      750.50,     'Sustainable bamboo chopping board - ANTIBACTERIAL surface',               'WH-BRI-SOUTH-01'),
    ('PROTEIN powder VANILLA',              'groceries',        '  NatureWell Health',          'GR-PPV-2025-018',     34.99,      16.789,     1000.00,    'Plant-based vanilla protein powder - 30 SERVINGS per tub  ',              'WH-EDI-NORTH-02'),
    ('  CANVAS backpack  ',                 'Fashion',          'UrbanStride UK',               'FA-CBP-2025-052',     64.99,      31.456,     550.00,     'Waxed canvas backpack with LAPTOP COMPARTMENT',                          'WH-MAN-WEST-01'),
    ('portable BLUETOOTH speaker  ',        'Electronics',      'TechFlow Solutions  ',         'EL-PBS-2025-041',     49.99,      24.123,     410.25,     '  Waterproof portable speaker - 20hr BATTERY life  ',                    'WH-LON-EAST-01'),
    ('CHAMOMILE tea INFUSION',              '  Groceries',      'Highland Harvest Ltd',         'GR-CTI-2025-028',     6.99,       2.891,      80.00,      'Caffeine-free chamomile tea - 50 INDIVIDUALLY wrapped bags',             'WH-EDI-NORTH-02'),
    ('  ergonomic DESK chair',              'Home & Living',    'CozyNest Home  ',              'HM-EDC-2025-070',     299.99,     152.345,    15000.00,   'Fully adjustable ergonomic office chair with LUMBAR SUPPORT',            'WH-LON-EAST-01'),
    ('TRAIL running SHORTS',                'fashion  ',        '  UrbanStride UK  ',           'FA-TRS-2025-059',     34.99,      16.234,     180.00,     'Lightweight trail running shorts with MOISTURE WICKING fabric',           'WH-MAN-WEST-01');
