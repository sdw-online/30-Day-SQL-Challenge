# Day 26 - Information Schema & Metadata

[Watch the video](COMING_SOON) | [← Day 25: Views & Materialised Views](../day-25/) | [Day 27: CREATE FUNCTION (UDFs) →](../day-27/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to query your database about itself using information_schema and pg_catalog
- How to list all tables, inspect columns, and map foreign key relationships with SQL
- How to use pg_catalog to find indexes, table owners, and column comments
- How to auto-generate a complete data dictionary from database metadata

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Day 25
- PostgreSQL 15 or later recommended (`SELECT version();` to check)

## Dataset

Today is different from every other day in the challenge. You are not creating a small table - you are building a realistic multi-table schema so there is guaranteed metadata to query.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS shipment_items;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS warehouses;

-- TABLE 1: warehouses
CREATE TABLE warehouses (
    warehouse_id    SERIAL PRIMARY KEY,
    warehouse_name  VARCHAR(100)    NOT NULL UNIQUE,
    city            VARCHAR(60)     NOT NULL,
    region          VARCHAR(60)     NOT NULL,
    capacity_units  INTEGER         NOT NULL CHECK (capacity_units > 0),
    opened_date     DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE warehouses IS 'Physical warehouse locations across the UK for Arcadia Logistics';
COMMENT ON COLUMN warehouses.capacity_units IS 'Maximum number of storage units available at this facility';
COMMENT ON COLUMN warehouses.is_active IS 'Whether the warehouse is currently operational';

-- TABLE 2: product_categories
CREATE TABLE product_categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(60)     NOT NULL UNIQUE,
    is_hazardous    BOOLEAN         NOT NULL DEFAULT FALSE
);

COMMENT ON TABLE product_categories IS 'Classification categories for products stored and shipped';

-- TABLE 3: products
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(120)    NOT NULL,
    sku             VARCHAR(20)     NOT NULL UNIQUE,
    category_id     INTEGER         NOT NULL REFERENCES product_categories(category_id),
    weight_kg       NUMERIC(8, 2)  NOT NULL CHECK (weight_kg > 0),
    unit_price      NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    stock_level     INTEGER         NOT NULL DEFAULT 0 CHECK (stock_level >= 0),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE products IS 'Products available for warehousing and shipment';
COMMENT ON COLUMN products.sku IS 'Stock Keeping Unit -- unique product identifier for inventory tracking';
COMMENT ON COLUMN products.weight_kg IS 'Product weight in kilograms, used for shipping cost calculation';

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);

-- TABLE 4: shipments
CREATE TABLE shipments (
    shipment_id         SERIAL PRIMARY KEY,
    warehouse_id        INTEGER         NOT NULL REFERENCES warehouses(warehouse_id),
    shipment_date       DATE            NOT NULL,
    delivery_date       DATE,
    carrier             VARCHAR(60)     NOT NULL,
    status              VARCHAR(20)     NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'in_transit', 'delivered', 'returned')),
    shipping_cost       NUMERIC(10, 2) NOT NULL CHECK (shipping_cost >= 0),
    destination_city    VARCHAR(60)     NOT NULL,
    tracking_reference  VARCHAR(40)     UNIQUE
);

COMMENT ON TABLE shipments IS 'Outbound shipments dispatched from warehouses to customers';
COMMENT ON COLUMN shipments.status IS 'Current shipment status: pending, in_transit, delivered, or returned';
COMMENT ON COLUMN shipments.tracking_reference IS 'Unique carrier tracking reference number';

CREATE INDEX idx_shipments_warehouse_date ON shipments(warehouse_id, shipment_date);
CREATE INDEX idx_shipments_status ON shipments(status);

-- TABLE 5: shipment_items
CREATE TABLE shipment_items (
    item_id         SERIAL PRIMARY KEY,
    shipment_id     INTEGER         NOT NULL REFERENCES shipments(shipment_id),
    product_id      INTEGER         NOT NULL REFERENCES products(product_id),
    quantity        INTEGER         NOT NULL CHECK (quantity > 0),
    line_total      NUMERIC(10, 2) NOT NULL CHECK (line_total >= 0)
);

COMMENT ON TABLE shipment_items IS 'Individual product line items within each shipment';
COMMENT ON COLUMN shipment_items.line_total IS 'Calculated total for this line: quantity * unit_price at time of shipment';

CREATE INDEX idx_shipment_items_shipment ON shipment_items(shipment_id);
CREATE INDEX idx_shipment_items_product ON shipment_items(product_id);

-- INSERT: Warehouse locations
INSERT INTO warehouses (warehouse_name, city, region, capacity_units, opened_date, is_active) VALUES
    ('Arcadia South',       'Southampton',  'South East',       12000, '2019-03-15', TRUE),
    ('Arcadia Midlands',    'Birmingham',   'West Midlands',    18000, '2020-01-10', TRUE),
    ('Arcadia North',       'Leeds',        'Yorkshire',        15000, '2020-09-01', TRUE),
    ('Arcadia Scotland',    'Glasgow',      'Scotland',          8000, '2021-06-20', TRUE),
    ('Arcadia Wales',       'Cardiff',      'Wales',             6000, '2022-04-15', TRUE),
    ('Arcadia East',        'Norwich',      'East Anglia',       9000, '2024-02-01', FALSE);

-- INSERT: Product categories
INSERT INTO product_categories (category_name, is_hazardous) VALUES
    ('Electronics',         FALSE),
    ('Pharmaceuticals',     TRUE),
    ('Food & Beverage',     FALSE),
    ('Industrial Equipment',FALSE),
    ('Chemicals',           TRUE),
    ('Textiles',            FALSE),
    ('Automotive Parts',    FALSE),
    ('Office Supplies',     FALSE);

-- INSERT: Products across categories
INSERT INTO products (product_name, sku, category_id, weight_kg, unit_price, stock_level, is_active) VALUES
    ('Wireless Bluetooth Speaker',      'ELEC-001', 1, 0.45,  29.99, 850,  TRUE),
    ('USB-C Charging Hub',              'ELEC-002', 1, 0.22,  19.99, 1200, TRUE),
    ('Noise-Cancelling Headphones',     'ELEC-003', 1, 0.31,  79.99, 420,  TRUE),
    ('Portable Power Bank 20000mAh',    'ELEC-004', 1, 0.38,  34.99, 680,  TRUE),
    ('Paracetamol 500mg (100 pack)',    'PHAR-001', 2, 0.15,  4.99,  3200, TRUE),
    ('Ibuprofen 200mg (48 pack)',       'PHAR-002', 2, 0.08,  3.49,  2800, TRUE),
    ('Antiseptic Cream 50ml',           'PHAR-003', 2, 0.12,  6.99,  1500, TRUE),
    ('Vitamin D3 1000IU (90 caps)',     'PHAR-004', 2, 0.10,  8.49,  1800, TRUE),
    ('Organic Earl Grey Tea (80 bags)', 'FOOD-001', 3, 0.25,  5.99,  4000, TRUE),
    ('Granola Bars Mixed Pack (24)',     'FOOD-002', 3, 0.72,  12.49, 2200, TRUE),
    ('Cold Brew Coffee Concentrate 1L', 'FOOD-003', 3, 1.05,  8.99,  900,  TRUE),
    ('Dried Mango Slices 500g',         'FOOD-004', 3, 0.52,  7.49,  1100, TRUE),
    ('Steel Shelving Unit 5-Tier',      'INDL-001', 4, 22.50, 89.99, 150,  TRUE),
    ('Heavy-Duty Pallet Jack',          'INDL-002', 4, 35.00, 249.99, 45,  TRUE),
    ('Industrial LED Floodlight 200W',  'INDL-003', 4, 3.80,  54.99, 320,  TRUE),
    ('Safety Harness Kit',              'INDL-004', 4, 1.90,  42.99, 280,  TRUE),
    ('Isopropyl Alcohol 99% 5L',        'CHEM-001', 5, 5.10,  18.99, 600,  TRUE),
    ('Acetone Technical Grade 2.5L',    'CHEM-002', 5, 2.55,  14.99, 450,  FALSE),
    ('Citric Acid Powder 1kg',          'CHEM-003', 5, 1.02,  9.99,  800,  TRUE),
    ('Hydrogen Peroxide 3% 1L',         'CHEM-004', 5, 1.05,  7.99,  950,  TRUE),
    ('Cotton T-Shirt Blank (White)',    'TEXT-001', 6, 0.18,  3.99,  5000, TRUE),
    ('Polyester Fleece Jacket',         'TEXT-002', 6, 0.42,  24.99, 750,  TRUE),
    ('Hi-Vis Workwear Vest',            'TEXT-003', 6, 0.15,  8.99,  2000, TRUE),
    ('Merino Wool Beanie',              'TEXT-004', 6, 0.08,  12.99, 1300, TRUE),
    ('Brake Pad Set (Front)',           'AUTO-001', 7, 2.80,  34.99, 400,  TRUE),
    ('Engine Oil 5W-30 5L',             'AUTO-002', 7, 4.60,  29.99, 550,  TRUE),
    ('Windscreen Wiper Blades (Pair)',  'AUTO-003', 7, 0.45,  14.99, 900,  TRUE),
    ('Car Battery 12V 60Ah',           'AUTO-004', 7, 15.00, 79.99, 200,  TRUE),
    ('A4 Copy Paper Ream (500 sheets)', 'OFFC-001', 8, 2.50,  4.99,  6000, TRUE),
    ('Ballpoint Pens Box (50)',         'OFFC-002', 8, 0.60,  9.99,  3500, TRUE);

-- INSERT: Sample shipments (SQL-only alternative -- use this if you prefer not to run the Python script)
INSERT INTO shipments (warehouse_id, shipment_date, delivery_date, carrier, status, shipping_cost, destination_city, tracking_reference) VALUES
    (1, '2024-03-10', '2024-03-14', 'Royal Mail',  'delivered',  12.50, 'London',       'ARC-202403-0001'),
    (1, '2024-04-22', '2024-04-26', 'DPD',         'delivered',  18.75, 'Bristol',      'ARC-202404-0002'),
    (2, '2024-05-15', NULL,         'DHL',         'in_transit', 22.00, 'Manchester',   'ARC-202405-0003'),
    (2, '2024-06-01', '2024-06-05', 'Hermes',      'delivered',   8.99, 'Liverpool',    'ARC-202406-0004'),
    (3, '2024-07-20', '2024-07-28', 'FedEx',       'returned',   31.50, 'Edinburgh',    'ARC-202407-0005'),
    (3, '2024-08-11', '2024-08-15', 'UPS',         'delivered',  15.00, 'Newcastle',    'ARC-202408-0006'),
    (4, '2024-09-03', NULL,         'Royal Mail',  'pending',     9.50, 'Glasgow',      'ARC-202409-0007'),
    (4, '2024-10-18', '2024-10-22', 'DPD',         'delivered',  20.00, 'Aberdeen',     'ARC-202410-0008'),
    (5, '2024-11-05', '2024-11-09', 'DHL',         'delivered',  14.25, 'Cardiff',      'ARC-202411-0009'),
    (5, '2024-12-20', '2024-12-27', 'Hermes',      'returned',   11.00, 'Swansea',      'ARC-202412-0010'),
    (1, '2025-01-15', '2025-01-19', 'FedEx',       'delivered',  25.00, 'Brighton',     'ARC-202501-0011'),
    (2, '2025-02-08', '2025-02-12', 'UPS',         'delivered',  17.50, 'Sheffield',    'ARC-202502-0012'),
    (3, '2025-03-22', NULL,         'Royal Mail',  'in_transit', 10.00, 'York',         'ARC-202503-0013'),
    (1, '2025-04-10', '2025-04-14', 'DPD',         'delivered',  19.99, 'Oxford',       'ARC-202504-0014'),
    (2, '2025-05-01', NULL,         'DHL',         'pending',    28.00, 'Cambridge',    'ARC-202505-0015');

-- INSERT: Shipment line items
INSERT INTO shipment_items (shipment_id, product_id, quantity, line_total) VALUES
    (1, 1,  5, 149.95),
    (1, 9,  10, 59.90),
    (2, 13, 2, 179.98),
    (2, 5,  20, 99.80),
    (3, 21, 50, 199.50),
    (3, 22, 10, 249.90),
    (4, 17, 8, 151.92),
    (4, 29, 100, 499.00),
    (5, 25, 6, 209.94),
    (5, 26, 4, 119.96),
    (6, 2,  15, 299.85),
    (6, 3,  3, 239.97),
    (7, 10, 12, 149.88),
    (7, 11, 8, 71.92),
    (8, 14, 1, 249.99),
    (8, 15, 5, 274.95),
    (9, 6,  30, 104.70),
    (9, 7,  20, 139.80),
    (10, 23, 25, 224.75),
    (10, 24, 15, 194.85),
    (11, 1,  8, 239.92),
    (11, 4,  6, 209.94),
    (12, 18, 10, 149.90),
    (12, 19, 15, 149.85),
    (13, 27, 12, 179.88),
    (13, 28, 3, 239.97),
    (14, 30, 50, 499.50),
    (14, 8,  25, 212.25),
    (15, 12, 20, 149.80),
    (15, 16, 8, 343.92);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM warehouses;
-- Expected: 6 rows

SELECT COUNT(*) FROM product_categories;
-- Expected: 8 rows

SELECT COUNT(*) FROM products;
-- Expected: 30 rows

SELECT COUNT(*) FROM shipments;
-- Expected: 15 rows

SELECT COUNT(*) FROM shipment_items;
-- Expected: 30 rows
```

## Exercises

You are an analytics engineer at Arcadia Logistics, a UK-based supply chain analytics company. You have just inherited a PostgreSQL database with dozens of tables, views, and constraints built by a team that left sparse documentation. The Head of Data, Marcus, sends you a message on Tuesday morning:

> "I need a complete data dictionary by Friday. The new analysts joining on Monday shouldn't have to ask a single question about table structure."

The previous team left no documentation. No wiki pages, no README files, nothing. Your job is to write SQL queries that build the data dictionary automatically - straight from the database's own metadata.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Write a query using `information_schema.tables` to list all user-created tables in the `public` schema. Show the table name and the `table_type` for each. How many tables do you see?

**Q2:** Query `information_schema.columns` to count the number of columns in each table in the `public` schema. Which table has the most columns?

### 🟡 Practice

**Q3:** Query `information_schema.columns` to inspect every column in the `products` table. For each column, show the column name, data type, maximum character length (where applicable), whether it allows NULLs, and its default value. Order the results by the original column position.

**Q4:** Write a three-way JOIN across `information_schema.table_constraints`, `key_column_usage`, and `constraint_column_usage` to produce a complete foreign key relationship map - showing which child column in which table points to which parent column in which parent table.

**Q5:** Using `pg_catalog.pg_indexes`, list every index in the `public` schema. For each, show the table name, index name, and the full CREATE INDEX definition. How many indexes exist, and which ones were created automatically by PostgreSQL?

### 🔴 Challenge

**Q6:** Query `pg_catalog.pg_class`, `pg_description`, and `pg_namespace` to retrieve all table-level and column-level comments in the `public` schema. Which tables have comments, and what do they say? Which columns have comments?

**Q7:** Combine all six metadata sources (table inventory, column details, constraints, foreign keys, indexes, and comments) into a single comprehensive query that produces one row per column across all tables - with the data type, nullable flag, primary key status, foreign key references, and any table or column comments. This is the complete auto-generated data dictionary Marcus asked for.

## Key Concepts Covered
- **information_schema:** The SQL-standard metadata views that work across PostgreSQL, MySQL, SQL Server, and Snowflake - your portable metadata toolkit
- **pg_catalog:** PostgreSQL's native system catalogue with extra detail like indexes, table owners, and comments that information_schema cannot show
- **Foreign key relationship mapping:** A three-way JOIN across metadata views that produces a complete entity-relationship map in text form
- **Auto-generated data dictionaries:** One query that produces a complete, always-current reference - far more reliable than manually maintained documentation
- **Table and column comments:** Human-readable descriptions stored inside the database itself using COMMENT ON, so documentation can never drift out of sync

---

[← Day 25: Views & Materialised Views](../day-25/) | [Day 27: CREATE FUNCTION (UDFs) →](../day-27/)
