# Day 13 - CTEs (Part 1)

[Watch the video](https://youtu.be/IijQJAfqcJc) | [← Day 12: Subqueries & Temp Tables](../day-12/) | [Day 14: Project: IoT Sensor Data Pipeline →](../day-14/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What Common Table Expressions (CTEs) are and how the WITH keyword works
- How to define multiple CTEs in a single query, separated by commas
- How to chain CTEs into multi-step pipelines where each step feeds the next
- When to use a CTE versus a subquery versus a temp table
- Naming conventions that make your CTEs self-documenting

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-12
- Comfortable with SELECT, WHERE, GROUP BY, JOINs, NULL handling, string/date functions, CASE WHEN, subqueries, and temp tables

## Dataset

Today uses e-commerce order data from a UK online retailer with customers, orders, products, and order line items.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 13 SETUP: E-commerce order data
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    region          VARCHAR(50)     NOT NULL,
    signup_date     DATE            NOT NULL,
    is_premium      BOOLEAN         NOT NULL DEFAULT FALSE,
    referral_source VARCHAR(50)
);

-- TABLE 2: products
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(150)    NOT NULL,
    category        VARCHAR(60)     NOT NULL,
    unit_price      NUMERIC(8, 2)  NOT NULL,
    cost_price      NUMERIC(8, 2)  NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 3: orders
CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customers(customer_id),
    order_date      DATE            NOT NULL,
    status          VARCHAR(30)     NOT NULL,
    shipping_cost   NUMERIC(6, 2)  NOT NULL DEFAULT 0.00,
    discount_pct    NUMERIC(4, 2)  DEFAULT 0.00
);

-- TABLE 4: order_items
CREATE TABLE order_items (
    item_id         SERIAL PRIMARY KEY,
    order_id        INTEGER         NOT NULL REFERENCES orders(order_id),
    product_id      INTEGER         NOT NULL REFERENCES products(product_id),
    quantity        INTEGER         NOT NULL,
    unit_price      NUMERIC(8, 2)  NOT NULL
);

-- 20 customers
INSERT INTO customers
    (full_name, email, region, signup_date, is_premium, referral_source)
VALUES
    ('Amara Okafor',     'amara.okafor@email.com',     'London',         '2023-03-10', TRUE,  'Google'),
    ('Callum Reid',      'callum.reid@email.com',      'Scotland',       '2023-06-22', FALSE, 'Instagram'),
    ('Priya Sharma',     'priya.sharma@email.com',      'South East',     '2023-09-01', TRUE,  'Referral'),
    ('Finn Gallagher',   'finn.gallagher@email.com',    'North West',     '2023-11-15', FALSE, NULL),
    ('Isla Campbell',    'isla.campbell@email.com',      'Scotland',       '2024-01-08', TRUE,  'Google'),
    ('Ravi Patel',       'ravi.patel@email.com',         'London',         '2024-02-14', FALSE, 'TikTok'),
    ('Sienna Brooks',    'sienna.brooks@email.com',      'South West',     '2024-03-20', FALSE, 'Referral'),
    ('Idris Mensah',     'idris.mensah@email.com',       'West Midlands',  '2024-05-05', TRUE,  'Google'),
    ('Freya Nilsson',    'freya.nilsson@email.com',      'London',         '2024-06-30', FALSE, NULL),
    ('Euan MacLeod',     'euan.macleod@email.com',       'Scotland',       '2024-07-18', TRUE,  'Instagram'),
    ('Nia Williams',     'nia.williams@email.com',       'Wales',          '2024-08-25', FALSE, 'Referral'),
    ('Kwame Asante',     'kwame.asante@email.com',       'London',         '2024-09-10', FALSE, 'Google'),
    ('Mei Zhang',        'mei.zhang@email.com',           'South East',     '2024-10-02', TRUE,  NULL),
    ('Jamal Hassan',     'jamal.hassan@email.com',        'North West',     '2024-11-17', FALSE, 'TikTok'),
    ('Safiya Abdi',      'safiya.abdi@email.com',         'West Midlands',  '2025-01-05', TRUE,  'Referral'),
    ('Arjun Nair',       'arjun.nair@email.com',          'London',         '2025-01-20', FALSE, 'Google'),
    ('Quinn Taylor',     'quinn.taylor@email.com',        'South West',     '2025-02-10', FALSE, 'Instagram'),
    ('Wei Chen',         'wei.chen@email.com',             'South East',     '2025-03-01', TRUE,  'Google'),
    ('Mateo Rivera',     'mateo.rivera@email.com',         'Wales',          '2025-03-15', FALSE, NULL),
    ('Sage Mwangi',      'sage.mwangi@email.com',          'Scotland',       '2025-04-01', TRUE,  'Referral');

-- 15 products
INSERT INTO products
    (product_name, category, unit_price, cost_price, is_active)
VALUES
    ('Wireless Bluetooth Headphones',  'Electronics',   79.99,  35.00, TRUE),
    ('USB-C Charging Hub',             'Electronics',   34.99,  12.50, TRUE),
    ('Mechanical Keyboard',            'Electronics',  119.99,  52.00, TRUE),
    ('Portable Monitor 15.6"',         'Electronics',  229.99, 105.00, TRUE),
    ('Smart LED Desk Lamp',            'Home & Garden', 44.99,  18.00, TRUE),
    ('Indoor Herb Garden Kit',         'Home & Garden', 29.99,  11.00, TRUE),
    ('Ergonomic Seat Cushion',         'Home & Garden', 39.99,  15.00, TRUE),
    ('Insulated Water Bottle 750ml',   'Sports',        24.99,   8.50, TRUE),
    ('Resistance Band Set',            'Sports',        19.99,   6.00, TRUE),
    ('Yoga Mat Premium 6mm',           'Sports',        34.99,  13.00, TRUE),
    ('Running Belt with Phone Holder', 'Sports',        17.99,   5.50, TRUE),
    ('SQL Performance Explained',      'Books',         32.99,  14.00, TRUE),
    ('Designing Data-Intensive Apps',  'Books',         39.99,  17.00, TRUE),
    ('The Data Warehouse Toolkit',     'Books',         44.99,  19.00, TRUE),
    ('Streaming Systems',              'Books',         37.99,  16.00, FALSE);

-- 40 orders
INSERT INTO orders
    (customer_id, order_date, status, shipping_cost, discount_pct)
VALUES
    (1,  '2024-01-15', 'delivered',  4.99,  0.00),
    (1,  '2024-04-22', 'delivered',  0.00, 10.00),
    (2,  '2024-02-03', 'delivered',  4.99,  0.00),
    (3,  '2024-02-18', 'delivered',  0.00,  5.00),
    (3,  '2024-06-10', 'delivered',  0.00, 10.00),
    (3,  '2024-09-05', 'delivered',  0.00, 15.00),
    (4,  '2024-03-12', 'delivered',  4.99,  0.00),
    (5,  '2024-03-25', 'delivered',  0.00,  0.00),
    (5,  '2024-07-14', 'delivered',  0.00,  5.00),
    (6,  '2024-04-01', 'delivered',  4.99,  0.00),
    (6,  '2024-08-19', 'returned',   4.99,  0.00),
    (7,  '2024-05-02', 'delivered',  4.99,  0.00),
    (8,  '2024-05-15', 'delivered',  0.00, 10.00),
    (8,  '2024-10-30', 'delivered',  0.00,  5.00),
    (9,  '2024-07-08', 'delivered',  4.99,  0.00),
    (10, '2024-08-01', 'delivered',  0.00,  0.00),
    (10, '2024-12-20', 'delivered',  0.00, 10.00),
    (11, '2024-09-14', 'delivered',  4.99,  0.00),
    (11, '2025-01-10', 'delivered',  4.99,  5.00),
    (12, '2024-10-05', 'delivered',  4.99,  0.00),
    (12, '2025-02-14', 'cancelled',  0.00,  0.00),
    (13, '2024-10-22', 'delivered',  0.00, 10.00),
    (13, '2025-01-30', 'delivered',  0.00,  5.00),
    (14, '2024-11-08', 'delivered',  4.99,  0.00),
    (14, '2025-03-05', 'delivered',  4.99,  0.00),
    (15, '2025-01-12', 'delivered',  0.00, 15.00),
    (15, '2025-03-18', 'shipped',    0.00, 10.00),
    (16, '2025-01-25', 'delivered',  4.99,  0.00),
    (16, '2025-04-02', 'processing', 4.99,  0.00),
    (17, '2025-02-08', 'delivered',  4.99,  5.00),
    (17, '2025-04-10', 'shipped',    4.99,  0.00),
    (18, '2025-02-20', 'delivered',  0.00, 10.00),
    (18, '2025-04-15', 'processing', 0.00,  5.00),
    (19, '2025-03-01', 'delivered',  4.99,  0.00),
    (19, '2025-04-18', 'shipped',    4.99,  0.00),
    (20, '2025-03-20', 'delivered',  0.00,  5.00),
    (20, '2025-04-20', 'processing', 0.00,  0.00),
    (1,  '2025-04-05', 'delivered',  0.00, 20.00),
    (3,  '2025-04-08', 'shipped',    0.00, 10.00),
    (5,  '2025-04-12', 'processing', 0.00,  5.00);

-- 75 order items
INSERT INTO order_items
    (order_id, product_id, quantity, unit_price)
VALUES
    (1,  1,  1,  79.99), (1,  5,  1,  44.99),
    (2,  3,  1, 119.99),
    (3,  8,  2,  24.99), (3,  9,  1,  19.99),
    (4,  12, 1,  32.99), (4,  13, 1,  39.99), (4,  14, 1,  44.99),
    (5,  4,  1, 229.99),
    (6,  1,  1,  79.99), (6,  2,  2,  34.99),
    (7,  10, 2,  34.99),
    (8,  3,  1, 119.99), (8,  5,  2,  44.99),
    (9,  7,  1,  39.99),
    (10, 1,  1,  79.99), (10, 11, 1,  17.99),
    (11, 4,  1, 229.99),
    (12, 6,  3,  29.99),
    (13, 2,  1,  34.99), (13, 8,  2,  24.99),
    (14, 12, 1,  32.99), (14, 10, 1,  34.99), (14, 11, 2,  17.99),
    (15, 3,  1, 119.99),
    (16, 13, 1,  39.99), (16, 14, 1,  44.99),
    (17, 4,  1, 229.99),
    (18, 1,  1,  79.99), (18, 9,  2,  19.99),
    (19, 5,  1,  44.99),
    (20, 8,  3,  24.99), (20, 10, 1,  34.99),
    (21, 3,  1, 119.99),
    (22, 1,  1,  79.99), (22, 2,  1,  34.99), (22, 5,  1,  44.99),
    (23, 12, 2,  32.99), (23, 13, 1,  39.99),
    (24, 6,  2,  29.99),
    (25, 9,  1,  19.99), (25, 11, 1,  17.99),
    (26, 3,  1, 119.99), (26, 7,  1,  39.99),
    (27, 4,  1, 229.99),
    (28, 1,  1,  79.99), (28, 8,  1,  24.99),
    (29, 10, 1,  34.99),
    (30, 12, 1,  32.99), (30, 14, 1,  44.99),
    (31, 2,  2,  34.99),
    (32, 3,  1, 119.99), (32, 5,  1,  44.99), (32, 8,  1,  24.99),
    (33, 13, 1,  39.99),
    (34, 6,  2,  29.99),
    (35, 9,  1,  19.99), (35, 11, 2,  17.99),
    (36, 1,  1,  79.99), (36, 7,  1,  39.99),
    (37, 14, 1,  44.99),
    (38, 2,  1,  34.99), (38, 9,  1,  19.99),
    (39, 4,  1, 229.99),
    (40, 12, 1,  32.99), (40, 6,  1,  29.99);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM customers;
-- Expected: 20 rows

SELECT COUNT(*) FROM products;
-- Expected: 15 rows

SELECT COUNT(*) FROM orders;
-- Expected: 40 rows

SELECT COUNT(*) FROM order_items;
-- Expected: 75 rows
```

## Exercises

You are a data analyst at a UK online retailer. The Head of Commercial, James, has a board meeting at 3pm and needs a full customer revenue pipeline.

Using the dataset above, answer the questions below.

### 🟢 Warm-Up

**Q1:** Write a single CTE called `delivered_orders` that calculates the line total (quantity * unit_price) for each delivered order. In the main query, show the top 5 orders by line total, including the order ID and order date.

**Q2:** Write a CTE that counts the number of delivered orders per customer. In the main query, join it to the customers table and show each customer's name, region, and order count. Sort by order count descending.

### 🟡 Practice

**Q3:** Build a two-CTE query. The first CTE calculates each customer's total revenue (from delivered orders only, after discounts). The second CTE classifies customers into spend tiers: "Gold" for $300+, "Silver" for $150+, and "Bronze" for everyone else. The main query should show each customer's name, region, total revenue, spend tier, and number of delivered orders.

**Q4:** Write a CTE that calculates each product's total quantity sold across all delivered orders. Then in the main query, show each product alongside its category average using a CROSS JOIN to a subquery. Add a column showing whether the product is "Above Average", "Average", or "Below Average" compared to other products in its category.

### 🔴 Challenge

**Q5:** Build a four-step CTE pipeline for James's board report. Step 1: calculate order-level totals (with discounts and shipping). Step 2: aggregate per customer (lifetime value, average order value, first and last order dates). Step 3: find each customer's top product category by spend. Step 4: calculate regional benchmarks (average lifetime value per region). The final query should join everything together and show each customer compared to their regional average, with a status flag of "Top Performer" (25%+ above average), "On Track" (within 25% of average), or "Needs Attention" (25%+ below average).

**Q6:** Using a single CTE that calculates each customer's total spend from delivered orders, write a main query that references the CTE twice - once to get individual customer totals and once (via a CROSS JOIN) to calculate the overall average. Show each customer's name, total spend, the overall average, and the difference between the two.

## Key Concepts Covered
- **WITH keyword:** Defines named temporary result sets at the top of a query, referenced like tables below
- **Multiple CTEs:** Separated by commas, not by repeating WITH - you only write WITH once
- **CTE chaining:** Later CTEs can reference earlier ones, creating a top-to-bottom pipeline
- **CTE vs subquery vs temp table:** CTEs for multi-step logic in one query, subqueries for simple one-off filters, temp tables for reuse across multiple queries
- **Naming conventions:** Use descriptive names like `orders_delivered` and `revenue_by_quarter` - never `temp`, `sub`, or `cte1`
- **Performance:** In modern PostgreSQL (12+), non-recursive CTEs referenced once are inlined automatically

---

[← Day 12: Subqueries & Temp Tables](../day-12/) | [Day 14: Project: IoT Sensor Data Pipeline →](../day-14/)
