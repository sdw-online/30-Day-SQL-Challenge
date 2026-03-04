# Day 8 - NULL Handling

[Watch the video](COMING_SOON) | [← Day 7: Project - Freight & Logistics Performance Report](../day-07/) | [Day 9: String & Numeric Functions →](../day-09/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What NULL actually means in SQL and why it causes silent bugs
- Three-valued logic - how TRUE, FALSE, and UNKNOWN work
- IS NULL and IS NOT NULL - the only correct way to check for missing values
- COALESCE - replacing NULLs with fallback values in reports and calculations
- NULLIF - preventing division-by-zero errors and cleaning placeholder values
- How NULL behaves in aggregate functions and sorting

## Prerequisites
- Complete Days 1-7 (Week 1 fundamentals + project)
- pgAdmin open and connected to your `sql_challenge` database

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
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
```

</details>

Now create the exercise table.

<details>
<summary>Click to expand exercise dataset SQL</summary>

```sql
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
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM customers;
-- Expected: 20

SELECT COUNT(*) FROM customer_orders;
-- Expected: 30

SELECT COUNT(*) FROM product_catalogue;
-- Expected: 25
```

## Exercises

You are a data analyst at a UK-based e-commerce company. Your head of operations, **Kwame**, sends you a message on Monday morning. He needs three reports by 2pm for a supply chain meeting.

The finance team cannot calculate profit margins because some products have missing cost prices. The warehouse team says some products have no assigned location. And the procurement team wants to contact suppliers about low-stock products, but some have no supplier information at all.

Using the `product_catalogue` table, answer these questions:

### 🟢 Warm-Up

**Q1:** How many products have missing values in each key column? Write a query that counts the NULLs in `cost_price`, `supplier_name`, and `warehouse_location` using the `COUNT(*) - COUNT(column)` pattern.

**Q2:** Find all products that have no supplier name. Show the product name, category, and stock quantity. How many products are missing supplier data?

### 🟡 Practice

**Q3:** Build a profit margin report for the finance team. For each active (non-discontinued) product, show the product name, category, unit price, cost price, and profit margin as a percentage. Use CASE WHEN to display 'Unknown' for products with no cost price instead of a misleading number. Sort so that products with missing cost data appear at the top.

**Q4:** Find all active products that have no warehouse location assigned. Show the product name, category, stock quantity, and the total stock value (unit_price * stock_quantity). Sort by unit price descending so the warehouse team can prioritise the most expensive items.

**Q5:** Build a supplier contact report for the procurement team. For each active product, show the product name, stock quantity, supplier name (using COALESCE to display 'Unknown supplier' if NULL), supplier email (using COALESCE to display 'No email on file' if NULL), and a contact status column using CASE WHEN that categorises each product as 'Contactable', 'Name only', or 'No supplier data'. Sort by stock quantity ascending so the most urgent items appear first.

### 🔴 Challenge

**Q6:** Write a query that calculates the correct paid amount for each order, handling NULL discount percentages properly. Show `total_amount * (1 - COALESCE(discount_pct, 0) / 100)` as `paid_amount` and compare it against the naive calculation without COALESCE to demonstrate how NULLs silently break arithmetic.

**Q7:** Kwame wants a single query that shows, for each city, the total number of customers, how many are missing an email, how many are missing a phone number, and how many are missing both. Use `COUNT(*)`, `COUNT(*) - COUNT(column)`, and a CASE WHEN with IS NULL to count the "missing both" group. Sort by the "missing both" count descending so the cities with the worst data gaps appear first.

## Key Concepts Covered
- **NULL means unknown**: It is not zero, not an empty string - it is the complete absence of a value
- **IS NULL / IS NOT NULL**: The only correct way to check for missing values - never use `= NULL` or `<> NULL`
- **COALESCE**: Returns the first non-NULL value from a list - essential for calculations, reports, and fallback displays
- **NULLIF**: Returns NULL when two values are equal - primarily used to prevent division-by-zero errors
- **COUNT(*) vs COUNT(column)**: COUNT(*) counts all rows; COUNT(column) counts only non-NULL values - getting the wrong one silently distorts your reporting
- **AVG ignores NULLs**: Use COALESCE(column, 0) if you want NULLs treated as zero in averages

---

[← Day 7: Project - Freight & Logistics Performance Report](../day-07/) | [Day 9: String & Numeric Functions →](../day-09/)
