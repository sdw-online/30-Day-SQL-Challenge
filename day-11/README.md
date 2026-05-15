# Day 11 - CASE WHEN

[Watch the video](https://youtu.be/eZ5iTTsKGkI) | [← Day 10: Date Functions & CAST](../day-10/) | [Day 12: Subqueries & Temp Tables →](../day-12/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to use CASE WHEN to add conditional logic inside your SQL queries
- The difference between simple CASE (exact matches) and searched CASE (ranges and conditions)
- Why evaluation order matters - tightest condition first, broadest last
- How to put CASE WHEN inside COUNT and SUM for pivot-style reports
- Nested CASE expressions and when to stop nesting

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-10
- Comfortable with SELECT, WHERE, GROUP BY, JOINs, NULL handling, string/numeric functions, date functions, and CAST

## Dataset

Today uses two datasets: customer order data from a UK online electronics retailer, and support ticket data for a SaaS platform.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 11 SETUP: Online electronics retailer
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS customer_orders;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id         SERIAL PRIMARY KEY,
    full_name           VARCHAR(100)    NOT NULL,
    email               VARCHAR(150)    NOT NULL,
    city                VARCHAR(80)     NOT NULL,
    country             VARCHAR(60)     NOT NULL DEFAULT 'United Kingdom',
    membership_tier     VARCHAR(30),
    signup_date         DATE            NOT NULL,
    last_login_date     DATE,
    total_lifetime_spend NUMERIC(10, 2) NOT NULL DEFAULT 0,
    referral_source     VARCHAR(60)
);

-- TABLE 2: customer_orders
CREATE TABLE customer_orders (
    order_id            SERIAL PRIMARY KEY,
    customer_id         INTEGER         NOT NULL REFERENCES customers(customer_id),
    order_date          DATE            NOT NULL,
    product_category    VARCHAR(60)     NOT NULL,
    product_name        VARCHAR(150)    NOT NULL,
    quantity            INTEGER         NOT NULL,
    unit_price          NUMERIC(8, 2)   NOT NULL,
    order_total         NUMERIC(10, 2)  NOT NULL,
    discount_pct        NUMERIC(4, 2),
    order_status        VARCHAR(30)     NOT NULL,
    shipping_method     VARCHAR(40),
    delivery_date       DATE,
    return_date         DATE
);

INSERT INTO customers
    (full_name, email, city, country, membership_tier, signup_date,
     last_login_date, total_lifetime_spend, referral_source)
VALUES
    ('Amara Okafor',     'amara.okafor@gmail.com',       'London',       'United Kingdom', 'Gold',     '2023-06-15', '2025-05-10', 4250.00,  'Google Ads'),
    ('Callum Reid',      'callum.reid@outlook.com',      'Edinburgh',    'United Kingdom', 'Platinum', '2022-11-01', '2025-05-12', 12800.00, 'Referral'),
    ('Priya Sharma',     'priya.sharma@yahoo.co.uk',     'Manchester',   'United Kingdom', 'Silver',   '2024-03-20', '2025-05-08', 1850.00,  'Instagram'),
    ('Finn Gallagher',   'finn.gallagher@gmail.com',     'Dublin',       'Ireland',        'Gold',     '2023-09-10', '2025-04-22', 3600.00,  'Google Ads'),
    ('Isla Campbell',    'isla.campbell@hotmail.com',     'Glasgow',      'United Kingdom', 'Bronze',   '2024-08-05', '2025-05-11', 420.00,   'TikTok'),
    ('Ravi Patel',       'ravi.patel@proton.me',         'Birmingham',   'United Kingdom', 'Platinum', '2022-03-18', '2025-05-13', 15200.00, 'Referral'),
    ('Sienna Brooks',    'sienna.brooks@gmail.com',      'Bristol',      'United Kingdom', 'Silver',   '2024-01-12', '2025-03-15', 2100.00,  'Facebook'),
    ('Idris Mensah',     'idris.mensah@outlook.com',     'London',       'United Kingdom', 'Gold',     '2023-07-22', '2025-05-09', 5100.00,  'Google Ads'),
    ('Freya Nilsson',    'freya.nilsson@gmail.com',      'Stockholm',    'Sweden',         'Silver',   '2024-04-01', '2025-05-06', 1600.00,  'Instagram'),
    ('Euan MacLeod',     'euan.macleod@yahoo.co.uk',     'Edinburgh',    'United Kingdom', 'Bronze',   '2024-09-18', '2025-04-10', 350.00,   'TikTok'),
    ('Nia Williams',     'nia.williams@gmail.com',        'Cardiff',      'United Kingdom', NULL,       '2025-04-28', '2025-05-02', 75.00,    'Google Ads'),
    ('Kwame Asante',     'kwame.asante@outlook.com',     'London',       'United Kingdom', 'Gold',     '2023-11-05', '2025-05-12', 4800.00,  'Referral'),
    ('Mei Zhang',        'mei.zhang@proton.me',          'London',       'United Kingdom', NULL,       '2025-05-01', NULL,         0.00,     'TikTok'),
    ('Jamal Hassan',     'jamal.hassan@gmail.com',       'Leeds',        'United Kingdom', 'Silver',   '2024-02-14', '2025-05-07', 1950.00,  'Facebook'),
    ('Safiya Abdi',      'safiya.abdi@outlook.com',      'Manchester',   'United Kingdom', 'Platinum', '2022-08-30', '2025-05-13', 11500.00, 'Referral'),
    ('Arjun Nair',       'arjun.nair@yahoo.co.uk',       'Birmingham',   'United Kingdom', 'Bronze',   '2024-07-10', '2025-02-20', 580.00,   'Google Ads'),
    ('Quinn Taylor',     'quinn.taylor@gmail.com',        'Brighton',     'United Kingdom', NULL,       '2025-04-15', '2025-05-01', 120.00,   'Instagram'),
    ('Wei Chen',         'wei.chen@outlook.com',          'London',       'United Kingdom', 'Gold',     '2023-05-08', '2025-05-11', 6200.00,  'Google Ads'),
    ('Mateo Rivera',     'mateo.rivera@gmail.com',        'Barcelona',    'Spain',          'Silver',   '2024-05-22', '2025-04-30', 1400.00,  'Instagram'),
    ('River Jordan',     'river.jordan@proton.me',        'Bristol',      'United Kingdom', 'Bronze',   '2024-10-01', '2025-05-05', 290.00,   'TikTok');

INSERT INTO customer_orders
    (customer_id, order_date, product_category, product_name, quantity, unit_price,
     order_total, discount_pct, order_status, shipping_method, delivery_date, return_date)
VALUES
    (1,  '2025-01-15', 'Laptops',      'MacBook Air M3',           1, 1099.00, 1099.00, NULL,  'Delivered',  'Express',    '2025-01-18', NULL),
    (1,  '2025-03-20', 'Audio',        'Sony WH-1000XM5',         1, 299.00,  299.00,  10.00, 'Delivered',  'Standard',   '2025-03-26', NULL),
    (1,  '2025-04-10', 'Accessories',  'USB-C Hub 10-in-1',       2, 45.00,   90.00,   NULL,  'Delivered',  'Standard',   '2025-04-15', NULL),
    (2,  '2024-11-25', 'Laptops',      'Dell XPS 15',             1, 1499.00, 1499.00, 5.00,  'Delivered',  'Next Day',   '2024-11-26', NULL),
    (2,  '2025-02-14', 'Phones',       'iPhone 15 Pro Max',       1, 1199.00, 1199.00, NULL,  'Delivered',  'Express',    '2025-02-17', NULL),
    (2,  '2025-04-30', 'Gaming',       'PlayStation 5 Slim',      1, 449.00,  449.00,  NULL,  'Shipped',    'Express',    NULL,          NULL),
    (3,  '2025-01-08', 'Phones',       'Samsung Galaxy S24',      1, 799.00,  799.00,  NULL,  'Delivered',  'Standard',   '2025-01-14', NULL),
    (3,  '2025-03-05', 'Audio',        'AirPods Pro 2',           1, 229.00,  229.00,  NULL,  'Delivered',  'Standard',   '2025-03-10', NULL),
    (4,  '2024-12-10', 'Laptops',      'MacBook Pro 16 M3',       1, 2499.00, 2499.00, NULL,  'Delivered',  'Next Day',   '2024-12-11', NULL),
    (4,  '2025-02-28', 'Accessories',  'Magic Keyboard',          1, 129.00,  129.00,  NULL,  'Returned',   'Standard',   '2025-03-05', '2025-03-12'),
    (5,  '2025-03-15', 'Audio',        'JBL Flip 6',              1, 119.00,  119.00,  15.00, 'Delivered',  'Standard',   '2025-03-20', NULL),
    (5,  '2025-04-22', 'Accessories',  'Phone Case Bundle',       3, 25.00,   75.00,   NULL,  'Delivered',  'Standard',   '2025-04-28', NULL),
    (6,  '2024-10-05', 'Laptops',      'ThinkPad X1 Carbon',      1, 1899.00, 1899.00, NULL,  'Delivered',  'Next Day',   '2024-10-06', NULL),
    (6,  '2025-01-20', 'Tablets',      'iPad Pro 12.9',           1, 1099.00, 1099.00, NULL,  'Delivered',  'Express',    '2025-01-23', NULL),
    (6,  '2025-03-18', 'Gaming',       'Nintendo Switch OLED',    1, 309.00,  309.00,  NULL,  'Delivered',  'Standard',   '2025-03-24', NULL),
    (6,  '2025-05-01', 'Phones',       'Google Pixel 8 Pro',      1, 999.00,  999.00,  10.00, 'Processing', NULL,          NULL,          NULL),
    (7,  '2025-02-01', 'Phones',       'iPhone 15',               1, 799.00,  799.00,  NULL,  'Delivered',  'Express',    '2025-02-04', NULL),
    (7,  '2025-04-15', 'Audio',        'Bose QC Ultra',           1, 349.00,  349.00,  NULL,  'Cancelled',  NULL,          NULL,          NULL),
    (8,  '2024-11-10', 'Laptops',      'MacBook Air M3',          1, 1099.00, 1099.00, NULL,  'Delivered',  'Express',    '2024-11-13', NULL),
    (8,  '2025-01-30', 'Tablets',      'iPad Air',                1, 599.00,  599.00,  5.00,  'Delivered',  'Standard',   '2025-02-04', NULL),
    (8,  '2025-04-05', 'Accessories',  'Apple Pencil 2',          1, 129.00,  129.00,  NULL,  'Delivered',  'Standard',   '2025-04-10', NULL),
    (9,  '2025-02-18', 'Audio',        'Sony WH-1000XM5',         1, 299.00,  299.00,  NULL,  'Delivered',  'Standard',   '2025-02-24', NULL),
    (9,  '2025-04-20', 'Accessories',  'Wireless Charger Pad',    2, 35.00,   70.00,   NULL,  'Shipped',    'Standard',   NULL,          NULL),
    (10, '2025-01-25', 'Gaming',       'Xbox Series X',           1, 449.00,  449.00,  NULL,  'Returned',   'Express',    '2025-01-28', '2025-02-05'),
    (10, '2025-04-08', 'Audio',        'JBL Flip 6',              1, 119.00,  119.00,  NULL,  'Delivered',  'Standard',   '2025-04-13', NULL),
    (11, '2025-05-02', 'Accessories',  'USB-C Cable 3-Pack',      1, 15.00,   15.00,   NULL,  'Processing', NULL,          NULL,          NULL),
    (12, '2024-12-20', 'Laptops',      'Dell XPS 15',             1, 1499.00, 1499.00, 10.00, 'Delivered',  'Next Day',   '2024-12-21', NULL),
    (12, '2025-03-10', 'Phones',       'Samsung Galaxy S24 Ultra', 1, 1299.00, 1299.00, NULL, 'Delivered',  'Express',    '2025-03-13', NULL),
    (14, '2025-01-05', 'Audio',        'AirPods Pro 2',           1, 229.00,  229.00,  NULL,  'Delivered',  'Standard',   '2025-01-10', NULL),
    (14, '2025-03-25', 'Tablets',      'iPad Mini',               1, 499.00,  499.00,  NULL,  'Delivered',  'Express',    '2025-03-28', NULL),
    (15, '2024-09-15', 'Laptops',      'MacBook Pro 14 M3',       1, 1999.00, 1999.00, NULL,  'Delivered',  'Next Day',   '2024-09-16', NULL),
    (15, '2025-02-10', 'Phones',       'iPhone 15 Pro',           1, 999.00,  999.00,  5.00,  'Delivered',  'Express',    '2025-02-13', NULL),
    (15, '2025-04-25', 'Gaming',       'Steam Deck OLED',         1, 549.00,  549.00,  NULL,  'Shipped',    'Express',    NULL,          NULL),
    (16, '2025-03-01', 'Accessories',  'Laptop Stand',            1, 65.00,   65.00,   NULL,  'Delivered',  'Standard',   '2025-03-06', NULL),
    (17, '2025-04-20', 'Audio',        'AirPods 4',               1, 179.00,  179.00,  NULL,  'Delivered',  'Standard',   '2025-04-25', NULL),
    (18, '2025-01-12', 'Laptops',      'ThinkPad X1 Carbon',      1, 1899.00, 1899.00, NULL,  'Delivered',  'Next Day',   '2025-01-13', NULL),
    (18, '2025-03-22', 'Gaming',       'PlayStation 5 Slim',      1, 449.00,  449.00,  10.00, 'Delivered',  'Express',    '2025-03-25', NULL),
    (19, '2025-02-05', 'Phones',       'Google Pixel 8',          1, 699.00,  699.00,  NULL,  'Delivered',  'Standard',   '2025-02-11', NULL),
    (19, '2025-04-18', 'Tablets',      'Samsung Galaxy Tab S9',   1, 749.00,  749.00,  NULL,  'Cancelled',  NULL,          NULL,          NULL),
    (20, '2025-03-30', 'Accessories',  'Wireless Mouse',          1, 49.00,   49.00,   NULL,  'Delivered',  'Standard',   '2025-04-04', NULL);

DROP TABLE IF EXISTS support_tickets;

CREATE TABLE support_tickets (
    ticket_id           SERIAL PRIMARY KEY,
    customer_name       VARCHAR(100)    NOT NULL,
    company_name        VARCHAR(100)    NOT NULL,
    plan_type           VARCHAR(30)     NOT NULL,
    ticket_category     VARCHAR(60)     NOT NULL,
    priority            VARCHAR(20)     NOT NULL,
    created_date        DATE            NOT NULL,
    first_response_date DATE,
    resolved_date       DATE,
    assigned_agent      VARCHAR(100)    NOT NULL,
    satisfaction_score  INTEGER,
    monthly_spend       NUMERIC(10, 2)  NOT NULL,
    ticket_status       VARCHAR(30)     NOT NULL
);

INSERT INTO support_tickets
    (customer_name, company_name, plan_type, ticket_category, priority,
     created_date, first_response_date, resolved_date, assigned_agent,
     satisfaction_score, monthly_spend, ticket_status)
VALUES
    ('Amara Okafor',    'DataFlow Ltd',      'Enterprise',    'Performance',      'Critical', '2025-04-01', '2025-04-01', '2025-04-02', 'Liam Fletcher',  5, 2500.00, 'Resolved'),
    ('Callum Reid',     'Insight Analytics',  'Professional',  'Bug',              'High',     '2025-04-03', '2025-04-03', '2025-04-05', 'Yuki Tanaka',    4, 800.00,  'Resolved'),
    ('Priya Sharma',    'MetricHub',          'Professional',  'Feature Request',  'Medium',   '2025-04-05', '2025-04-06', '2025-04-12', 'Liam Fletcher',  3, 800.00,  'Resolved'),
    ('Finn Gallagher',  'CloudScale',         'Enterprise',    'Bug',              'Critical', '2025-04-05', '2025-04-05', '2025-04-06', 'Sage Mwangi',    5, 3200.00, 'Resolved'),
    ('Isla Campbell',   'QuickReport',        'Starter',       'Onboarding',       'Medium',   '2025-04-07', '2025-04-08', '2025-04-10', 'Phoenix Oduya',  4, 150.00,  'Resolved'),
    ('Ravi Patel',      'DataFlow Ltd',      'Enterprise',    'Performance',      'High',     '2025-04-08', '2025-04-08', '2025-04-10', 'Yuki Tanaka',    4, 2500.00, 'Resolved'),
    ('Sienna Brooks',   'GrowthMetrics',      'Professional',  'Billing',          'Low',      '2025-04-09', '2025-04-10', '2025-04-11', 'Phoenix Oduya',  3, 800.00,  'Resolved'),
    ('Idris Mensah',    'CloudScale',         'Enterprise',    'Feature Request',  'Medium',   '2025-04-10', '2025-04-11', '2025-04-18', 'Liam Fletcher',  3, 3200.00, 'Resolved'),
    ('Freya Nilsson',   'NordicData',         'Professional',  'Bug',              'High',     '2025-04-11', '2025-04-11', '2025-04-13', 'Sage Mwangi',    4, 800.00,  'Resolved'),
    ('Euan MacLeod',    'QuickReport',        'Starter',       'Performance',      'Medium',   '2025-04-12', '2025-04-13', '2025-04-16', 'Yuki Tanaka',    2, 150.00,  'Resolved'),
    ('Nia Williams',    'PixelPulse',         'Free',          'Onboarding',       'Low',      '2025-04-14', '2025-04-16', '2025-04-20', 'Phoenix Oduya',  3, 0.00,    'Resolved'),
    ('Kwame Asante',    'DataFlow Ltd',      'Enterprise',    'Bug',              'Critical', '2025-04-15', '2025-04-15', '2025-04-16', 'Sage Mwangi',    5, 2500.00, 'Resolved'),
    ('Mei Zhang',       'StartupLab',         'Free',          'Onboarding',       'Low',      '2025-04-16', '2025-04-18', NULL,         'Phoenix Oduya',  NULL, 0.00, 'Open'),
    ('Jamal Hassan',    'Insight Analytics',  'Professional',  'Performance',      'High',     '2025-04-17', '2025-04-17', '2025-04-19', 'Liam Fletcher',  4, 800.00,  'Resolved'),
    ('Safiya Abdi',     'DataFlow Ltd',      'Enterprise',    'Billing',          'Medium',   '2025-04-18', '2025-04-19', '2025-04-21', 'Yuki Tanaka',    3, 2500.00, 'Resolved'),
    ('Arjun Nair',      'TechBridge',         'Starter',       'Bug',              'High',     '2025-04-19', '2025-04-19', '2025-04-22', 'Sage Mwangi',    2, 150.00,  'Resolved'),
    ('Quinn Taylor',    'PixelPulse',         'Free',          'Feature Request',  'Low',      '2025-04-20', '2025-04-22', NULL,         'Phoenix Oduya',  NULL, 0.00, 'Open'),
    ('Wei Chen',        'CloudScale',         'Enterprise',    'Performance',      'Critical', '2025-04-21', '2025-04-21', '2025-04-22', 'Yuki Tanaka',    5, 3200.00, 'Resolved'),
    ('Mateo Rivera',    'GrowthMetrics',      'Professional',  'Onboarding',       'Medium',   '2025-04-22', '2025-04-23', '2025-04-25', 'Phoenix Oduya',  4, 800.00,  'Resolved'),
    ('River Jordan',    'QuickReport',        'Starter',       'Billing',          'Low',      '2025-04-23', '2025-04-25', '2025-04-28', 'Liam Fletcher',  3, 150.00,  'Resolved'),
    ('Aisha Yusuf',     'NordicData',         'Professional',  'Bug',              'High',     '2025-04-24', '2025-04-24', '2025-04-26', 'Sage Mwangi',    4, 800.00,  'Resolved'),
    ('Sage Mwangi',     'StartupLab',         'Free',          'Performance',      'Medium',   '2025-04-25', '2025-04-27', NULL,         'Yuki Tanaka',    NULL, 0.00, 'Open'),
    ('Yuki Tanaka',     'MetricHub',          'Professional',  'Feature Request',  'Medium',   '2025-04-26', '2025-04-27', NULL,         'Liam Fletcher',  NULL, 0.00, 'Open'),
    ('Phoenix Oduya',   'TechBridge',         'Starter',       'Performance',      'High',     '2025-04-27', '2025-04-27', '2025-04-29', 'Sage Mwangi',    3, 150.00,  'Resolved'),
    ('Liam Fletcher',   'Insight Analytics',  'Professional',  'Billing',          'Low',      '2025-04-28', '2025-04-29', '2025-05-01', 'Yuki Tanaka',    4, 800.00,  'Resolved'),
    ('Isla Campbell',   'QuickReport',        'Starter',       'Bug',              'Medium',   '2025-04-29', '2025-04-30', NULL,         'Sage Mwangi',    NULL, 150.00, 'Open'),
    ('Ravi Patel',      'DataFlow Ltd',      'Enterprise',    'Feature Request',  'Medium',   '2025-04-30', '2025-05-01', NULL,         'Liam Fletcher',  NULL, 2500.00, 'Open'),
    ('Callum Reid',     'Insight Analytics',  'Professional',  'Performance',      'High',     '2025-05-01', '2025-05-01', '2025-05-03', 'Yuki Tanaka',    4, 800.00,  'Resolved'),
    ('Finn Gallagher',  'CloudScale',         'Enterprise',    'Billing',          'Low',      '2025-05-02', '2025-05-03', NULL,         'Phoenix Oduya',  NULL, 3200.00, 'Open'),
    ('Amara Okafor',    'DataFlow Ltd',      'Enterprise',    'Bug',              'Critical', '2025-05-03', NULL,         NULL,         'Sage Mwangi',    NULL, 2500.00, 'Open');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM customers;
-- Expected: 20 rows

SELECT COUNT(*) FROM customer_orders;
-- Expected: 40 rows

SELECT COUNT(*) FROM support_tickets;
-- Expected: 30 rows
```

## Exercises

You are a data analyst at a UK-based SaaS company that sells a business intelligence platform. The VP of Customer Success, Kwame, has a quarterly business review on Wednesday, and he needs reports from the support ticket data.

Using the `support_tickets` table, answer the questions below.

### 🟢 Warm-Up

**Q1:** Write a query that adds a `tier_label` column to each ticket using simple CASE. Map the plan types as follows: Enterprise → "Tier 1", Professional → "Tier 2", Starter → "Tier 3", Free → "Tier 4". Show the customer name, plan type, and your new label.

**Q2:** Using searched CASE, classify each ticket's monthly spend into three categories: "High Spend" ($2,000+), "Medium Spend" ($500+), and "Low Spend" (below $500). Show the customer name, monthly spend, and spend category.

### 🟡 Practice

**Q3:** Build an SLA compliance report by plan type. For each plan, show how many tickets were resolved within the SLA window versus how many breached it. The SLA windows are: Enterprise = 24 hours, Professional = 48 hours, Starter = 72 hours, Free = best effort (no SLA). Include the breach rate as a percentage.

**Q4:** Create an agent performance scorecard. For each support agent, show their total tickets, number resolved, average resolution time in days, average satisfaction score, and a performance rating. Rate agents as "Excellent" if their average satisfaction is 4.0 or above, "Good" for 3.0 to 3.9, and "Needs Improvement" for below 3.0.

**Q5:** Build a per-plan pivot report showing, for each plan type, the total number of Bug tickets, Performance tickets, and Feature Request tickets. Use CASE WHEN inside COUNT to produce one column per category.

### 🔴 Challenge

**Q6:** Build a revenue risk assessment. Classify each ticket by combining the customer's monthly spend with the ticket priority. A high-spending Enterprise customer with a critical bug is a completely different risk level than a free-plan user with a low-priority feature request. Show the total tickets, open tickets, and monthly revenue at risk for each risk category.

**Q7:** Write a single query that combines all three dimensions - SLA compliance, agent performance, and revenue risk - into one comprehensive ticket-level report. For each ticket, show the SLA status, the agent's overall performance rating, and the revenue risk category. This requires multiple CASE WHEN expressions working together in the same query.

## Key Concepts Covered
- **Simple CASE:** Compares one column against exact values - like a lookup table for mapping codes to labels
- **Searched CASE:** Evaluates any condition you like - ranges, thresholds, comparisons across multiple columns
- **Evaluation order:** Conditions check top to bottom, first true wins - always put the tightest condition first
- **Conditional aggregation:** CASE inside COUNT (omit ELSE) and SUM (include ELSE 0) for pivot-style reports
- **Nested CASE:** One level is fine, two is the maximum - beyond that, restructure with a CTE
- **ELSE clause:** Always include it - your safety net for unexpected or NULL values

---

[← Day 10: Date Functions & CAST](../day-10/) | [Day 12: Subqueries & Temp Tables →](../day-12/)
