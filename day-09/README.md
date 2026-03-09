# Day 9 - String & Numeric Functions

[Watch the video](COMING_SOON) | [← Day 8: NULL Handling](../day-08/) | [Day 10: Date Functions & CAST →](../day-10/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- UPPER, LOWER, and INITCAP - standardising text casing
- TRIM - removing invisible leading and trailing spaces
- SUBSTRING, LEFT, RIGHT - extracting parts of a string
- REPLACE and CONCAT - swapping and joining text
- ROUND, CEILING, FLOOR, ABS, MOD - controlling how numbers appear
- Nesting functions together to build real data transformations

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-8
- pgAdmin open and connected to your `sql_challenge` database
- Comfortable with SELECT, WHERE, GROUP BY, NULL handling

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop table if it already exists (safe to re-run)
DROP TABLE IF EXISTS raw_customers;

-- Deliberately messy customer data from a UK e-commerce company
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

-- 25 customers with intentional data quality issues:
-- leading/trailing spaces, inconsistent casing, mixed email formats,
-- product codes needing substring extraction, unformatted numbers
INSERT INTO raw_customers (first_name, last_name, email, phone, city, country, signup_date, total_spent, discount_pct, product_code, notes)
VALUES
    ('  amara',     'OKAFOR',       'Amara.Okafor@GMAIL.COM',       '+44 7700 900123',  '  london  ',       'united kingdom',   '2025-01-15',   1249.99,    12.50,  'UK-ELEC-2025-0441',    'VIP customer - handle with care'),
    ('CALLUM',      '  reid',       'CALLUM.REID@OUTLOOK.COM',      '07700 900456',     'EDINBURGH',        'UNITED KINGDOM',   '2025-02-03',   87.45,      NULL,   'UK-HOME-2025-0112',    'first time buyer'),
    ('priya',       'Sharma',       'priya.sharma@Yahoo.co.uk',     '+447700900789',    'London',           'United Kingdom',   '2025-01-22',   3450.00,    7.75,   'UK-FASH-2025-0287',    '  RETURNS FREQUENTLY  '),
    ('  FINN  ',    'gallagher',    'finn.gallagher@gmail.com',     '0161 496 0000',    'manchester  ',     'united kingdom',   '2024-11-10',   562.30,     15.00,  'UK-ELEC-2025-0398',    'Loyal customer since 2024'),
    ('Isla',        'CAMPBELL',     'isla.campbell@Hotmail.COM',     '+44 131 496 0001', '  Edinburgh',      'United Kingdom',   '2025-03-01',   2105.75,    10.00,  'UK-HOME-2025-0445',    NULL),
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
```

</details>

Now create the exercise table.

<details>
<summary>Click to expand exercise dataset SQL</summary>

```sql
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
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM raw_customers;
-- Expected: 25

SELECT COUNT(*) FROM raw_products;
-- Expected: 20
```

## Exercises

You are a data analyst at a UK retail company. The product team has uploaded 20 products into the `raw_products` table from a supplier feed. The Head of Product, **Freya**, messages you on Thursday morning:

> "The supplier data is a mess again - random capitalisation, spaces everywhere, cost prices with too many decimals. We need this cleaned up before the 2pm catalogue refresh. Can you also tell me the profit margins?"

Freya needs clean product data and accurate margins before the website refresh goes live. Using the `raw_products` table, answer these questions:

### 🟢 Warm-Up

**Q1:** Preview the first 5 rows of `raw_products` to see the mess. Then count how many rows have spacing issues in `product_name`, `category`, and `supplier_name` (where the value differs from its TRIMmed version).

**Q2:** Write a query that shows `product_id`, a clean product name (TRIM + INITCAP), and a clean category (TRIM + INITCAP) for the first 10 products.

### 🟡 Practice

**Q3:** Calculate profit margins. For each product, show the clean product name, unit price, cost price rounded to 2 decimal places, profit per unit (unit_price - cost_price rounded to 2 dp), and profit margin percentage using the formula `(unit_price - cost_price) / unit_price * 100` rounded to 2 decimal places. Sort by margin percentage descending.

**Q4:** Extract warehouse location. The warehouse codes follow a pattern: `WH-CITY-DIRECTION-NUMBER`. Use SUBSTRING to extract the 3-character city code (starting at position 4) and RIGHT to extract the 2-character warehouse number. Show the clean product name, full warehouse code, city code, and warehouse number for the first 10 products.

**Q5:** Build the final clean catalogue. Write a single query that produces the complete cleaned catalogue: clean product name, clean category, clean supplier name, unit price, cost price rounded to 2 dp, profit per unit, margin percentage rounded to 1 dp, and extracted warehouse city code. Sort by category then product name.

### 🔴 Challenge

**Q6:** Write a query that groups the clean products by their extracted warehouse city code and calculates the total number of products, the average margin percentage (rounded to 1 dp), and the highest-margin product name for each warehouse city.

**Q7:** Freya wants a "data quality scorecard" for the supplier feed. Write a single query that shows, for each supplier (cleaned name), the total number of products, how many product names had spacing issues, how many categories had spacing issues, and an overall "cleanliness percentage" - the proportion of text fields (product_name + category + supplier_name) across all their products that had no spacing issues. Round the percentage to 1 decimal place. Sort by cleanliness percentage ascending so the worst offenders appear first.

## Key Concepts Covered
- **TRIM, UPPER, LOWER, INITCAP**: Clean text by removing spaces and standardising casing - always clean first, format second
- **SUBSTRING, LEFT, RIGHT**: Extract parts of structured codes like product IDs, SKUs, and warehouse codes
- **REPLACE**: Find and swap text within a string (case-sensitive)
- **CONCAT vs ||**: Both join strings, but CONCAT is NULL-safe while the pipe operator follows standard NULL behaviour
- **ROUND, CEILING, FLOOR**: Control decimal places - different business rules need different rounding approaches
- **Nesting functions**: The inside-out rule - innermost function runs first, and you can combine string and numeric functions in the same query

---

[← Day 8: NULL Handling](../day-08/) | [Day 10: Date Functions & CAST →](../day-10/)
