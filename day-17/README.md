# Day 17 - UNION & UNION ALL

[Watch the video](COMING_SOON) | [← Day 16: JOINs Part 2](../day-16/) | [Day 18: Normalisation & Denormalisation →](../day-18/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How UNION stacks rows from multiple queries and removes duplicates
- How UNION ALL stacks rows and keeps everything - and why it should be your default
- The strict column rules that both queries must follow
- How to use source tagging, INTERSECT, and EXCEPT for real-world data merging

## Prerequisites
- Complete Days 1-16
- Comfortable with JOINs (Days 15-16) and CTEs (Day 13)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS event_log_mobile;
DROP TABLE IF EXISTS event_log_web;
DROP TABLE IF EXISTS orders_new_platform;
DROP TABLE IF EXISTS orders_legacy;
DROP TABLE IF EXISTS customers_eu;
DROP TABLE IF EXISTS customers_uk;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(100)    NOT NULL,
    category        VARCHAR(60)     NOT NULL,
    unit_price      NUMERIC(10, 2)  NOT NULL
);

CREATE TABLE customers_uk (
    customer_id     INTEGER         PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    city            VARCHAR(80)     NOT NULL,
    signup_date     DATE            NOT NULL
);

CREATE TABLE customers_eu (
    customer_id     INTEGER         PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    city            VARCHAR(80)     NOT NULL,
    signup_date     DATE            NOT NULL
);

CREATE TABLE orders_legacy (
    order_id        INTEGER         PRIMARY KEY,
    customer_id     INTEGER         NOT NULL,
    product_id      INTEGER         NOT NULL REFERENCES products(product_id),
    quantity        INTEGER         NOT NULL,
    order_total     NUMERIC(10, 2)  NOT NULL,
    order_date      DATE            NOT NULL,
    source_system   VARCHAR(40)     NOT NULL DEFAULT 'legacy'
);

CREATE TABLE orders_new_platform (
    order_id        INTEGER         PRIMARY KEY,
    customer_id     INTEGER         NOT NULL,
    product_id      INTEGER         NOT NULL REFERENCES products(product_id),
    quantity        INTEGER         NOT NULL,
    order_total     NUMERIC(10, 2)  NOT NULL,
    order_date      DATE            NOT NULL,
    source_system   VARCHAR(40)     NOT NULL DEFAULT 'new_platform'
);

CREATE TABLE event_log_web (
    event_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL,
    event_type      VARCHAR(60)     NOT NULL,
    event_timestamp TIMESTAMP       NOT NULL,
    page_url        VARCHAR(200)
);

CREATE TABLE event_log_mobile (
    event_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL,
    event_type      VARCHAR(60)     NOT NULL,
    event_timestamp TIMESTAMP       NOT NULL,
    screen_name     VARCHAR(200)
);

INSERT INTO products (product_name, category, unit_price)
VALUES
    ('Wireless Headphones',     'Electronics',   79.99),
    ('USB-C Hub',               'Electronics',   34.99),
    ('Ergonomic Keyboard',      'Electronics',   124.99),
    ('Standing Desk Mat',       'Office',        49.99),
    ('Notebook Set (3-pack)',   'Stationery',    12.99),
    ('Desk Lamp LED',           'Office',        39.99),
    ('Webcam HD 1080p',         'Electronics',   64.99),
    ('Cable Management Kit',    'Office',        19.99);

INSERT INTO customers_uk (customer_id, full_name, email, city, signup_date)
VALUES
    (1001, 'Isla Forsyth',      'isla.forsyth@email.co.uk',     'Edinburgh',    '2024-03-15'),
    (1002, 'Kwame Asante',      'kwame.asante@email.co.uk',     'London',       '2024-05-22'),
    (1003, 'Sienna Hargreaves', 'sienna.h@email.co.uk',         'Manchester',   '2024-06-10'),
    (1004, 'Ravi Chandran',     'ravi.c@email.co.uk',           'Bristol',      '2024-07-01'),
    (1005, 'Ffion Davies',      'ffion.d@email.co.uk',          'Cardiff',      '2024-08-18'),
    (1006, 'Oran Kelly',        'oran.kelly@email.co.uk',       'Belfast',      '2024-09-05'),
    (1007, 'Amara Okafor',      'amara.o@email.co.uk',          'London',       '2024-10-12'),
    (1008, 'Euan Campbell',     'euan.c@email.co.uk',           'Glasgow',      '2024-11-20'),
    (1009, 'Priya Sharma',      'priya.s@email.co.uk',          'Birmingham',   '2025-01-08'),
    (1010, 'Callum Reid',       'callum.r@email.co.uk',         'Edinburgh',    '2025-02-14');

INSERT INTO customers_eu (customer_id, full_name, email, city, signup_date)
VALUES
    (1002, 'Kwame Asante',      'kwame.asante@email.co.uk',     'London',       '2024-05-22'),
    (1007, 'Amara Okafor',      'amara.o@email.co.uk',          'London',       '2024-10-12'),
    (2001, 'Lena Eriksson',     'lena.e@email.se',              'Stockholm',    '2024-04-01'),
    (2002, 'Mateo Rossi',       'mateo.r@email.it',             'Milan',        '2024-06-15'),
    (2003, 'Sofie Janssen',     'sofie.j@email.nl',             'Amsterdam',    '2024-07-20'),
    (2004, 'Nils Andersen',     'nils.a@email.dk',              'Copenhagen',   '2024-08-30'),
    (2005, 'Aisha Mbeki',       'aisha.m@email.de',             'Berlin',       '2024-11-10'),
    (2006, 'Lukas Weber',       'lukas.w@email.de',             'Munich',       '2025-01-05'),
    (2007, 'Elise Dupont',      'elise.d@email.fr',             'Paris',        '2025-02-01'),
    (2008, 'Yuki Nakamura',     'yuki.n@email.de',              'Berlin',       '2025-03-12');

INSERT INTO orders_legacy (order_id, customer_id, product_id, quantity, order_total, order_date, source_system)
VALUES
    (5001, 1001, 1, 1,  79.99, '2024-09-10', 'legacy'),
    (5002, 1001, 5, 2,  25.98, '2024-09-15', 'legacy'),
    (5003, 1002, 3, 1, 124.99, '2024-10-01', 'legacy'),
    (5004, 1003, 2, 1,  34.99, '2024-10-05', 'legacy'),
    (5005, 1003, 6, 1,  39.99, '2024-10-05', 'legacy'),
    (5006, 1004, 7, 1,  64.99, '2024-10-20', 'legacy'),
    (5007, 1005, 4, 2,  99.98, '2024-11-01', 'legacy'),
    (5008, 1006, 1, 1,  79.99, '2024-11-15', 'legacy'),
    (5009, 1007, 8, 3,  59.97, '2024-11-20', 'legacy'),
    (5010, 1008, 3, 1, 124.99, '2024-12-01', 'legacy'),
    (5011, 1002, 7, 1,  64.99, '2024-12-10', 'legacy'),
    (5012, 1009, 1, 2, 159.98, '2025-01-15', 'legacy'),
    (5013, 1010, 2, 1,  34.99, '2025-02-20', 'legacy'),
    (5014, 1001, 4, 1,  49.99, '2025-03-01', 'legacy'),
    (5015, 2001, 6, 1,  39.99, '2025-03-05', 'legacy');

INSERT INTO orders_new_platform (order_id, customer_id, product_id, quantity, order_total, order_date, source_system)
VALUES
    (6001, 2001, 1, 1,  79.99, '2025-01-10', 'new_platform'),
    (6002, 2002, 3, 1, 124.99, '2025-01-12', 'new_platform'),
    (6003, 1002, 3, 1, 124.99, '2024-10-01', 'new_platform'),
    (6004, 2003, 5, 3,  38.97, '2025-01-20', 'new_platform'),
    (6005, 2004, 7, 1,  64.99, '2025-02-01', 'new_platform'),
    (6006, 1001, 2, 2,  69.98, '2025-02-10', 'new_platform'),
    (6007, 2005, 4, 1,  49.99, '2025-02-15', 'new_platform'),
    (6008, 1003, 8, 1,  19.99, '2025-02-20', 'new_platform'),
    (6009, 2006, 1, 1,  79.99, '2025-03-01', 'new_platform'),
    (6010, 1009, 1, 2, 159.98, '2025-01-15', 'new_platform'),
    (6011, 2007, 6, 2,  79.98, '2025-03-10', 'new_platform'),
    (6012, 1007, 3, 1, 124.99, '2025-03-15', 'new_platform'),
    (6013, 2008, 2, 1,  34.99, '2025-03-20', 'new_platform'),
    (6014, 1005, 7, 1,  64.99, '2025-04-01', 'new_platform'),
    (6015, 2002, 8, 2,  39.98, '2025-04-05', 'new_platform');

INSERT INTO event_log_web (customer_id, event_type, event_timestamp, page_url)
VALUES
    (1001, 'page_view',       '2025-03-01 09:15:00', '/products/wireless-headphones'),
    (1001, 'add_to_cart',     '2025-03-01 09:18:00', '/cart'),
    (1001, 'purchase',        '2025-03-01 09:25:00', '/checkout/confirmation'),
    (1002, 'page_view',       '2025-03-01 10:00:00', '/products/ergonomic-keyboard'),
    (1002, 'page_view',       '2025-03-01 10:05:00', '/products/usb-c-hub'),
    (1003, 'login',           '2025-03-02 08:30:00', '/account/login'),
    (1003, 'page_view',       '2025-03-02 08:32:00', '/products'),
    (2001, 'page_view',       '2025-03-02 11:00:00', '/products/desk-lamp'),
    (2001, 'add_to_cart',     '2025-03-02 11:05:00', '/cart'),
    (1007, 'login',           '2025-03-03 14:00:00', '/account/login'),
    (1007, 'page_view',       '2025-03-03 14:02:00', '/products/ergonomic-keyboard'),
    (1007, 'purchase',        '2025-03-03 14:15:00', '/checkout/confirmation');

INSERT INTO event_log_mobile (customer_id, event_type, event_timestamp, screen_name)
VALUES
    (1001, 'app_open',        '2025-03-01 09:10:00', 'home_screen'),
    (1001, 'page_view',       '2025-03-01 09:15:00', 'product_detail'),
    (1002, 'app_open',        '2025-03-01 09:55:00', 'home_screen'),
    (1002, 'page_view',       '2025-03-01 10:00:00', 'product_detail'),
    (1004, 'login',           '2025-03-02 12:00:00', 'login_screen'),
    (1004, 'page_view',       '2025-03-02 12:05:00', 'product_list'),
    (1004, 'add_to_cart',     '2025-03-02 12:10:00', 'cart_screen'),
    (2003, 'app_open',        '2025-03-03 09:00:00', 'home_screen'),
    (2003, 'page_view',       '2025-03-03 09:05:00', 'product_detail'),
    (1007, 'login',           '2025-03-03 14:00:00', 'login_screen');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM products;
-- Expected: 8 rows

SELECT COUNT(*) FROM customers_uk;
-- Expected: 10 rows

SELECT COUNT(*) FROM customers_eu;
-- Expected: 10 rows

SELECT COUNT(*) FROM orders_legacy;
-- Expected: 15 rows

SELECT COUNT(*) FROM orders_new_platform;
-- Expected: 15 rows

SELECT COUNT(*) FROM event_log_web;
-- Expected: 12 rows

SELECT COUNT(*) FROM event_log_mobile;
-- Expected: 10 rows
```

## Exercises

You are a data engineer at a UK-based media company that recently acquired a European competitor. The Head of Data, Priya, sends you a message on Monday morning. She has got a board meeting on Friday and she needs accurate numbers. Double-counted revenue in a board report would be a serious problem.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Combine all customers from `customers_uk` and `customers_eu` using UNION. How many rows do you get? Now do the same with UNION ALL. How many rows do you get this time, and why is the number different?

**Q2:** Use INTERSECT to find customers who exist in both the UK and EU tables. How many customers appear in both systems?

### 🟡 Practice

**Q3:** Build a deduplicated customer master list. Combine all customers from both regional tables into a single list where each customer appears only once. Include a column showing which region they came from (UK or EU). How many unique customers are there after deduplication?

**Q4:** Combine all orders from both systems into a unified order history using UNION ALL. Then find and flag any cutover duplicates - orders that appear in both systems with the same customer, product, total, and date. How many duplicate pairs exist, and what is their combined value?

**Q5:** Build a unified cross-platform event log combining web and mobile activity. Alias the platform-specific columns (`page_url` and `screen_name`) to a single column name. Include a source column showing whether each event came from web or mobile. How many total events are there?

### 🔴 Challenge

**Q6:** Using EXCEPT, find all UK-only customers who do not appear in the EU table. Then find all EU-only customers who do not appear in the UK table. How many customers are exclusive to each region?

**Q7:** Wrap a UNION ALL of both order tables inside a CTE, then join to the `products` table and aggregate by `source_system`. Show total orders, total revenue, and average order value per system. Which system has the higher average order value?

## Key Concepts Covered
- **UNION:** Stacks rows from multiple queries and removes exact duplicates - use when you need a clean, deduplicated list
- **UNION ALL:** Stacks rows and keeps everything - faster than UNION and should be your default for transaction data
- **Source tagging:** Adding a hardcoded string column (e.g. 'UK', 'legacy') to each query so you can trace every row back to its origin
- **INTERSECT:** Returns only rows that appear in both result sets - the overlap between two queries
- **EXCEPT:** Returns rows from the first query that do not appear in the second - useful for finding records unique to one source
- **Column rules:** Both sides of a UNION must have the same number of columns with compatible data types; column names come from the first query

---

[← Day 16: JOINs Part 2](../day-16/) | [Day 18: Normalisation & Denormalisation →](../day-18/)
