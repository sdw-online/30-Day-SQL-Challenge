# Day 12 - Subqueries & Temp Tables

[Watch the video](COMING_SOON) | [← Day 11: CASE WHEN](../day-11/) | [Day 13: CTEs (Part 1) →](../day-13/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to nest one query inside another to answer multi-step questions
- Three subquery patterns in WHERE: IN, NOT IN, and comparison operators
- EXISTS for NULL-safe presence checks
- Scalar subqueries in SELECT for adding calculated benchmark columns
- Derived tables in FROM for multi-step calculations
- Temporary tables for storing intermediate results you need to reuse

## Prerequisites
- Complete Days 1-11
- Comfortable with SELECT, WHERE, GROUP BY, JOINs, NULL handling, string/date functions, and CASE WHEN

## Dataset

Today uses two datasets: e-commerce order data from a UK online retailer (customers, products, orders, and order items), plus marketing campaign performance data for the exercises.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 12 SETUP: E-commerce order data
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    tier            VARCHAR(20)     NOT NULL DEFAULT 'Standard',
    region          VARCHAR(40)     NOT NULL,
    signup_date     DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: products
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(150)    NOT NULL,
    category        VARCHAR(60)     NOT NULL,
    unit_price      NUMERIC(10, 2)  NOT NULL,
    stock_quantity  INTEGER         NOT NULL DEFAULT 0,
    supplier        VARCHAR(100)    NOT NULL,
    is_discontinued BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 3: orders
CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customers(customer_id),
    order_date      DATE            NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Pending',
    total_amount    NUMERIC(10, 2)  NOT NULL,
    shipping_cost   NUMERIC(8, 2)   NOT NULL DEFAULT 0.00,
    discount_pct    NUMERIC(4, 2)   DEFAULT 0.00
);

-- TABLE 4: order_items
CREATE TABLE order_items (
    item_id         SERIAL PRIMARY KEY,
    order_id        INTEGER         NOT NULL REFERENCES orders(order_id),
    product_id      INTEGER         NOT NULL REFERENCES products(product_id),
    quantity        INTEGER         NOT NULL,
    unit_price      NUMERIC(10, 2)  NOT NULL,
    line_total      NUMERIC(10, 2)  NOT NULL
);

-- 20 customers
INSERT INTO customers
    (first_name, last_name, email, tier, region, signup_date, is_active)
VALUES
    ('Amara',   'Okafor',    'amara.okafor@email.com',       'VIP',      'London',       '2023-06-15', TRUE),
    ('Callum',  'Reid',      'callum.reid@email.com',        'Premium',  'Scotland',     '2023-09-20', TRUE),
    ('Priya',   'Sharma',    'priya.sharma@email.com',       'Standard', 'London',       '2024-01-10', TRUE),
    ('Finn',    'Gallagher', 'finn.gallagher@email.com',     'Premium',  'North West',   '2024-02-28', TRUE),
    ('Isla',    'Campbell',  'isla.campbell@email.com',       'Standard', 'Scotland',     '2024-03-15', TRUE),
    ('Ravi',    'Patel',     'ravi.patel@email.com',         'VIP',      'Midlands',     '2023-04-01', TRUE),
    ('Sienna',  'Brooks',    'sienna.brooks@email.com',      'Standard', 'South East',   '2024-05-22', TRUE),
    ('Idris',   'Mensah',    'idris.mensah@email.com',       'Premium',  'London',       '2023-11-08', TRUE),
    ('Freya',   'Nilsson',   'freya.nilsson@email.com',      'Standard', 'North West',   '2024-07-14', TRUE),
    ('Euan',    'MacLeod',   'euan.macleod@email.com',       'Premium',  'Scotland',     '2024-04-03', TRUE),
    ('Nia',     'Williams',  'nia.williams@email.com',       'Standard', 'Wales',        '2024-08-19', TRUE),
    ('Kwame',   'Asante',    'kwame.asante@email.com',       'VIP',      'London',       '2023-07-25', TRUE),
    ('Mei',     'Zhang',     'mei.zhang@email.com',          'Standard', 'South East',   '2025-01-06', TRUE),
    ('Jamal',   'Hassan',    'jamal.hassan@email.com',       'Premium',  'Midlands',     '2024-06-11', TRUE),
    ('Safiya',  'Abdi',      'safiya.abdi@email.com',        'Standard', 'London',       '2024-09-30', TRUE),
    ('Arjun',   'Nair',      'arjun.nair@email.com',         'VIP',      'South East',   '2023-08-14', TRUE),
    ('Quinn',   'Taylor',    'quinn.taylor@email.com',       'Standard', 'North West',   '2025-02-18', FALSE),
    ('Wei',     'Chen',      'wei.chen@email.com',           'Premium',  'London',       '2024-10-25', TRUE),
    ('Mateo',   'Rivera',    'mateo.rivera@email.com',       'Standard', 'Midlands',     '2025-03-07', TRUE),
    ('Aisha',   'Yusuf',     'aisha.yusuf@email.com',        'Premium',  'Wales',        '2024-11-12', TRUE);

-- 15 products
INSERT INTO products
    (product_name, category, unit_price, stock_quantity, supplier, is_discontinued)
VALUES
    ('Wireless Bluetooth Headphones',  'Electronics',      79.99,   120,  'TechFlow Ltd',       FALSE),
    ('USB-C Charging Hub',             'Electronics',      34.99,   200,  'TechFlow Ltd',       FALSE),
    ('Ergonomic Desk Lamp',            'Home & Kitchen',   45.50,   85,   'BrightHome Co',      FALSE),
    ('Cast Iron Skillet 10in',         'Home & Kitchen',   38.00,   60,   'KitchenCraft UK',    FALSE),
    ('Merino Wool Jumper',             'Clothing',         64.99,   45,   'Highland Threads',   FALSE),
    ('Running Jacket Waterproof',      'Clothing',         89.99,   30,   'PeakWear',           FALSE),
    ('Yoga Mat Premium',               'Sports',           29.99,   150,  'FitGear Direct',     FALSE),
    ('Resistance Bands Set',           'Sports',           18.50,   220,  'FitGear Direct',     FALSE),
    ('Stainless Steel Water Bottle',   'Sports',           22.00,   180,  'EcoFlow UK',         FALSE),
    ('Data Engineering Handbook',      'Books',            42.99,   70,   'TechPress',          FALSE),
    ('SQL Performance Explained',      'Books',            35.00,   55,   'TechPress',          FALSE),
    ('Smart LED Light Strip 5m',       'Electronics',      24.99,   95,   'TechFlow Ltd',       FALSE),
    ('Ceramic Pour-Over Coffee Set',   'Home & Kitchen',   52.00,   40,   'KitchenCraft UK',    FALSE),
    ('Trail Running Shoes',            'Sports',           110.00,  25,   'PeakWear',           FALSE),
    ('Vintage Mechanical Keyboard',    'Electronics',      149.99,  0,    'TechFlow Ltd',       TRUE);

-- 30 orders
INSERT INTO orders
    (customer_id, order_date, status, total_amount, shipping_cost, discount_pct)
VALUES
    (1,  '2024-03-15', 'Completed',  189.98,  4.99,  0.00),
    (1,  '2024-08-22', 'Completed',  314.97,  0.00,  10.00),
    (1,  '2025-01-10', 'Completed',  79.99,   4.99,  0.00),
    (2,  '2024-05-03', 'Completed',  134.98,  4.99,  5.00),
    (2,  '2024-11-18', 'Completed',  245.98,  0.00,  0.00),
    (3,  '2024-06-20', 'Completed',  45.50,   4.99,  0.00),
    (3,  '2025-02-14', 'Shipped',    64.99,   4.99,  0.00),
    (4,  '2024-07-09', 'Completed',  178.49,  0.00,  5.00),
    (4,  '2025-03-01', 'Processing', 110.00,  4.99,  0.00),
    (5,  '2024-08-30', 'Completed',  52.00,   4.99,  0.00),
    (6,  '2024-02-12', 'Completed',  429.96,  0.00,  15.00),
    (6,  '2024-06-25', 'Completed',  149.99,  0.00,  10.00),
    (6,  '2024-10-15', 'Completed',  264.97,  0.00,  10.00),
    (6,  '2025-01-30', 'Completed',  79.99,   0.00,  0.00),
    (7,  '2024-09-12', 'Completed',  29.99,   4.99,  0.00),
    (8,  '2024-04-18', 'Completed',  159.98,  4.99,  0.00),
    (8,  '2024-12-05', 'Cancelled',  89.99,   0.00,  0.00),
    (9,  '2025-01-22', 'Shipped',    38.00,   4.99,  0.00),
    (10, '2024-07-30', 'Completed',  99.98,   4.99,  5.00),
    (11, '2024-10-08', 'Completed',  22.00,   4.99,  0.00),
    (12, '2024-03-25', 'Completed',  384.97,  0.00,  10.00),
    (12, '2024-09-14', 'Completed',  42.99,   4.99,  0.00),
    (13, '2025-02-28', 'Processing', 34.99,   4.99,  0.00),
    (14, '2024-08-05', 'Completed',  113.49,  4.99,  5.00),
    (14, '2025-01-15', 'Refunded',   64.99,   4.99,  0.00),
    (15, '2024-11-20', 'Completed',  45.50,   4.99,  0.00),
    (16, '2024-04-10', 'Completed',  259.98,  0.00,  10.00),
    (16, '2024-10-28', 'Completed',  189.99,  0.00,  5.00),
    (18, '2025-03-10', 'Shipped',    52.00,   4.99,  0.00),
    (20, '2025-02-05', 'Completed',  77.98,   4.99,  0.00);

-- 56 order items
INSERT INTO order_items
    (order_id, product_id, quantity, unit_price, line_total)
VALUES
    (1,  1,  1, 79.99,  79.99),   (1,  14, 1, 110.00, 110.00),
    (2,  5,  2, 64.99,  129.98),  (2,  1,  1, 79.99,  79.99),
    (2,  11, 3, 35.00,  105.00),  (3,  1,  1, 79.99,  79.99),
    (4,  2,  1, 34.99,  34.99),   (4,  7,  1, 29.99,  29.99),
    (4,  5,  1, 64.99,  64.99),   (5,  6,  1, 89.99,  89.99),
    (5,  3,  1, 45.50,  45.50),   (5,  14, 1, 110.00, 110.00),
    (6,  3,  1, 45.50,  45.50),   (7,  5,  1, 64.99,  64.99),
    (8,  6,  1, 89.99,  89.99),   (8,  8,  2, 18.50,  37.00),
    (8,  13, 1, 52.00,  52.00),   (9,  14, 1, 110.00, 110.00),
    (10, 13, 1, 52.00,  52.00),   (11, 1,  2, 79.99,  159.98),
    (11, 10, 1, 42.99,  42.99),   (11, 5,  2, 64.99,  129.98),
    (11, 12, 3, 24.99,  74.97),   (11, 2,  1, 34.99,  34.99),
    (12, 15, 1, 149.99, 149.99),  (13, 1,  1, 79.99,  79.99),
    (13, 3,  1, 45.50,  45.50),   (13, 9,  3, 22.00,  66.00),
    (13, 11, 2, 35.00,  70.00),   (14, 1,  1, 79.99,  79.99),
    (15, 7,  1, 29.99,  29.99),   (16, 2,  2, 34.99,  69.98),
    (16, 6,  1, 89.99,  89.99),   (17, 6,  1, 89.99,  89.99),
    (18, 4,  1, 38.00,  38.00),   (19, 2,  1, 34.99,  34.99),
    (19, 5,  1, 64.99,  64.99),   (20, 9,  1, 22.00,  22.00),
    (21, 10, 3, 42.99,  128.97),  (21, 1,  2, 79.99,  159.98),
    (21, 12, 4, 24.99,  99.96),   (22, 10, 1, 42.99,  42.99),
    (23, 2,  1, 34.99,  34.99),   (24, 3,  1, 45.50,  45.50),
    (24, 8,  2, 18.50,  37.00),   (24, 11, 1, 35.00,  35.00),
    (25, 5,  1, 64.99,  64.99),   (26, 3,  1, 45.50,  45.50),
    (27, 1,  1, 79.99,  79.99),   (27, 14, 1, 110.00, 110.00),
    (27, 10, 1, 42.99,  42.99),   (28, 15, 1, 149.99, 149.99),
    (28, 2,  1, 34.99,  34.99),   (29, 13, 1, 52.00,  52.00),
    (30, 4,  1, 38.00,  38.00),   (30, 8,  1, 18.50,  18.50);

DROP TABLE IF EXISTS campaign_conversions;
DROP TABLE IF EXISTS campaigns;

CREATE TABLE campaigns (
    campaign_id     SERIAL PRIMARY KEY,
    campaign_name   VARCHAR(150)    NOT NULL,
    channel         VARCHAR(40)     NOT NULL,
    launch_date     DATE            NOT NULL,
    end_date        DATE,
    budget          NUMERIC(10, 2)  NOT NULL,
    actual_spend    NUMERIC(10, 2),
    target_leads    INTEGER         NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Active'
);

CREATE TABLE campaign_conversions (
    conversion_id   SERIAL PRIMARY KEY,
    campaign_id     INTEGER         NOT NULL REFERENCES campaigns(campaign_id),
    lead_date       DATE            NOT NULL,
    lead_source     VARCHAR(60)     NOT NULL,
    lead_name       VARCHAR(100)    NOT NULL,
    company_name    VARCHAR(100),
    deal_value      NUMERIC(10, 2),
    converted       BOOLEAN         NOT NULL DEFAULT FALSE,
    conversion_date DATE
);

-- 12 campaigns
INSERT INTO campaigns
    (campaign_name, channel, launch_date, end_date, budget, actual_spend, target_leads, status)
VALUES
    ('Spring Product Launch',         'Email',          '2025-03-01', '2025-03-31', 5000.00,  4800.00,   150,  'Completed'),
    ('Q1 LinkedIn Awareness',         'LinkedIn',       '2025-01-15', '2025-03-15', 8000.00,  7650.00,   200,  'Completed'),
    ('Google Search - Data Tools',    'Google Ads',     '2025-02-01', '2025-04-30', 12000.00, 11200.00,  350,  'Completed'),
    ('Partner Webinar Series',        'Webinar',        '2025-02-15', '2025-05-15', 3000.00,  2900.00,   80,   'Completed'),
    ('Summer SaaS Campaign',          'Google Ads',     '2025-06-01', '2025-08-31', 15000.00, 9500.00,   400,  'Active'),
    ('Developer Blog Sponsorship',    'Content',        '2025-04-01', '2025-06-30', 4000.00,  3200.00,   100,  'Active'),
    ('Q2 LinkedIn Lead Gen',          'LinkedIn',       '2025-04-01', '2025-06-30', 10000.00, 6800.00,   250,  'Active'),
    ('Email Nurture - Enterprise',    'Email',          '2025-03-15', NULL,         6000.00,  4100.00,   120,  'Active'),
    ('Product Hunt Launch',           'Product Hunt',   '2025-05-10', '2025-05-10', 500.00,   500.00,    300,  'Completed'),
    ('YouTube Tutorial Series',       'YouTube',        '2025-04-15', NULL,         7000.00,  3500.00,   180,  'Active'),
    ('Retargeting - Free Trial',      'Google Ads',     '2025-05-01', '2025-07-31', 8000.00,  4200.00,   200,  'Active'),
    ('Referral Programme Q2',         'Referral',       '2025-04-01', '2025-06-30', 2000.00,  1400.00,   60,   'Active');

-- 40 conversions
INSERT INTO campaign_conversions
    (campaign_id, lead_date, lead_source, lead_name, company_name, deal_value, converted, conversion_date)
VALUES
    (1,  '2025-03-05', 'Email Click',      'Leila Osman',      'DataStack Ltd',       2500.00,  TRUE,  '2025-03-20'),
    (1,  '2025-03-08', 'Email Click',      'Sage Mwangi',      'Apex Analytics',      NULL,     FALSE, NULL),
    (1,  '2025-03-12', 'Email Click',      'River Jordan',     'TechBridge UK',       4200.00,  TRUE,  '2025-04-01'),
    (1,  '2025-03-18', 'Email Click',      'Phoenix Oduya',    NULL,                  NULL,     FALSE, NULL),
    (1,  '2025-03-22', 'Email Click',      'Yuki Tanaka',      'CloudFirst',          1800.00,  TRUE,  '2025-04-05'),
    (2,  '2025-01-20', 'LinkedIn Form',    'Arjun Nair',       'Nair Consulting',     8500.00,  TRUE,  '2025-02-15'),
    (2,  '2025-02-03', 'LinkedIn Form',    'Freya Nilsson',    'NordTech AB',         6000.00,  TRUE,  '2025-03-01'),
    (2,  '2025-02-18', 'LinkedIn Form',    'Callum Reid',      'Reid & Partners',     NULL,     FALSE, NULL),
    (2,  '2025-03-05', 'LinkedIn Form',    'Isla Campbell',    'Highland Data Co',    3500.00,  TRUE,  '2025-03-25'),
    (3,  '2025-02-10', 'Google Search',    'Kwame Asante',     'Asante Digital',      5000.00,  TRUE,  '2025-03-05'),
    (3,  '2025-02-22', 'Google Search',    'Priya Sharma',     'Sharma Analytics',    NULL,     FALSE, NULL),
    (3,  '2025-03-05', 'Google Search',    'Wei Chen',         'Chen Enterprises',    12000.00, TRUE,  '2025-03-28'),
    (3,  '2025-03-15', 'Google Search',    'Nia Williams',     NULL,                  NULL,     FALSE, NULL),
    (3,  '2025-03-28', 'Google Search',    'Euan MacLeod',     'MacLeod Solutions',   3200.00,  TRUE,  '2025-04-15'),
    (3,  '2025-04-10', 'Google Search',    'Mateo Rivera',     'Rivera Tech',         7500.00,  TRUE,  '2025-04-30'),
    (4,  '2025-02-20', 'Webinar Signup',   'Jamal Hassan',     'Hassan Group',        4000.00,  TRUE,  '2025-03-10'),
    (4,  '2025-03-10', 'Webinar Signup',   'Safiya Abdi',      'Abdi Consulting',     NULL,     FALSE, NULL),
    (4,  '2025-04-05', 'Webinar Signup',   'Amara Okafor',     'Okafor Data Ltd',     6500.00,  TRUE,  '2025-05-01'),
    (5,  '2025-06-08', 'Google Search',    'Idris Mensah',     'Mensah Tech',         9000.00,  TRUE,  '2025-06-25'),
    (5,  '2025-06-15', 'Google Search',    'Finn Gallagher',   NULL,                  NULL,     FALSE, NULL),
    (5,  '2025-06-22', 'Google Display',   'Ravi Patel',       'Patel Systems',       15000.00, TRUE,  '2025-07-10'),
    (5,  '2025-07-01', 'Google Search',    'Mei Zhang',        'Zhang Analytics',     4500.00,  TRUE,  '2025-07-20'),
    (6,  '2025-04-10', 'Blog CTA',         'Quinn Taylor',     NULL,                  NULL,     FALSE, NULL),
    (6,  '2025-05-02', 'Blog CTA',         'Aisha Yusuf',      'Yusuf Data',          3000.00,  TRUE,  '2025-05-20'),
    (6,  '2025-05-18', 'Blog CTA',         'Sienna Brooks',    'Brooks Marketing',    NULL,     FALSE, NULL),
    (7,  '2025-04-08', 'LinkedIn Form',    'Liam Fletcher',    'Fletcher Engineering', 7000.00,  TRUE,  '2025-04-28'),
    (7,  '2025-04-22', 'LinkedIn Form',    'Yuki Tanaka',      'Tanaka Solutions',    5500.00,  TRUE,  '2025-05-10'),
    (7,  '2025-05-05', 'LinkedIn InMail',  'Phoenix Oduya',    'Oduya Consulting',    NULL,     FALSE, NULL),
    (7,  '2025-05-20', 'LinkedIn Form',    'River Jordan',     NULL,                  NULL,     FALSE, NULL),
    (8,  '2025-03-20', 'Email Click',      'Kwame Asante',     'Asante Digital',      11000.00, TRUE,  '2025-04-15'),
    (8,  '2025-04-05', 'Email Click',      'Arjun Nair',       'Nair Consulting',     8000.00,  TRUE,  '2025-05-01'),
    (8,  '2025-04-18', 'Email Click',      'Euan MacLeod',     NULL,                  NULL,     FALSE, NULL),
    (9,  '2025-05-10', 'Product Hunt',     'Sage Mwangi',      'Mwangi Labs',         2000.00,  TRUE,  '2025-05-25'),
    (9,  '2025-05-10', 'Product Hunt',     'Callum Reid',      NULL,                  NULL,     FALSE, NULL),
    (9,  '2025-05-10', 'Product Hunt',     'Isla Campbell',    'Highland Data Co',    1500.00,  TRUE,  '2025-06-01'),
    (10, '2025-04-20', 'YouTube Link',     'Mateo Rivera',     'Rivera Tech',         3500.00,  TRUE,  '2025-05-08'),
    (10, '2025-05-05', 'YouTube Link',     'Nia Williams',     NULL,                  NULL,     FALSE, NULL),
    (11, '2025-05-10', 'Google Retarget',  'Priya Sharma',     'Sharma Analytics',    6000.00,  TRUE,  '2025-05-30'),
    (11, '2025-05-25', 'Google Retarget',  'Finn Gallagher',   'Gallagher Corp',      4000.00,  TRUE,  '2025-06-15'),
    (12, '2025-04-15', 'Referral',         'Wei Chen',         'Chen Enterprises',    9500.00,  TRUE,  '2025-05-05');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM customers;
-- Expected: 20 rows

SELECT COUNT(*) FROM products;
-- Expected: 15 rows

SELECT COUNT(*) FROM orders;
-- Expected: 30 rows

SELECT COUNT(*) FROM order_items;
-- Expected: 56 rows

SELECT COUNT(*) FROM campaigns;
-- Expected: 12 rows

SELECT COUNT(*) FROM campaign_conversions;
-- Expected: 40 rows
```

## Exercises

You are a marketing analyst at a UK SaaS company. Your VP of Marketing, Kwame, has a quarterly review meeting on Friday and needs reports built from the `campaigns` and `campaign_conversions` tables.

Using the dataset above, answer the questions below.

### 🟢 Warm-Up

**Q1:** Use a subquery with IN to find all campaigns that have at least one converted lead. Show just the campaign name and channel.

**Q2:** Use a scalar subquery in SELECT to show each campaign's total leads alongside the overall average number of leads per campaign. Show campaign name, total leads, and the average.

### 🟡 Practice

**Q3:** Which campaigns are hitting their lead targets and which are falling behind? For each campaign, show the target leads, actual leads generated, the percentage of target achieved, and classify performance as "Target Met", "On Track" (75%+), "Behind" (50%+), or "At Risk" (below 50%).

**Q4:** Build a conversion pipeline report. For each campaign, show total leads, converted leads, total deal value from conversions, and a pipeline health rating ("Strong" for 60%+ conversion rate, "Average" for 40%+, "Needs Attention" for below 40%). Use a temp table so you can reuse the data in the next question.

**Q5:** Using the temp table from Q4, create a channel-level summary. Group by marketing channel and show total leads, total conversions, total revenue, and a budget recommendation ("Scale Up" if revenue is 3x or more of spend, "Maintain" if 1x or more, "Review" if below 1x).

### 🔴 Challenge

**Q6:** Find every customer who has placed at least one order above the overall average order amount, but has never ordered from the "Books" category. Use a combination of subqueries (IN and NOT IN) to solve this in a single query without any JOINs.

**Q7:** Using a derived table, find the top 3 product categories by total revenue (from completed orders only). Then for each of those categories, show the number of unique customers who bought from it. Solve this in a single query using a subquery in FROM.

## Key Concepts Covered
- **Subqueries in WHERE:** IN for list matching, NOT IN for exclusion (watch for NULLs), comparison operators for single-value thresholds, and EXISTS for NULL-safe presence checks
- **Scalar subqueries in SELECT:** Add a calculated benchmark column to every row - must return exactly one value
- **Derived tables in FROM:** Wrap a subquery as a "virtual table" for multi-step calculations - always requires an alias
- **Correlated vs non-correlated:** Non-correlated runs once; correlated runs once per row - watch performance
- **Temp tables:** Calculate once, reuse many times - session-scoped, disappear when you disconnect
- **FILTER (WHERE ...):** PostgreSQL shortcut for applying conditions to individual aggregates

---

[← Day 11: CASE WHEN](../day-11/) | [Day 13: CTEs (Part 1) →](../day-13/)
