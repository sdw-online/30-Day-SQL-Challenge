# Day 3 - ORDER BY, LIMIT & LIKE

[Watch the video](COMING_SOON) | [← Day 2: SELECT & WHERE](../day-02/) | [Day 4: Aggregate Functions & GROUP BY →](../day-04/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to sort results with ORDER BY (ascending and descending)
- How to limit rows returned with LIMIT and paginate with OFFSET
- How to find unique values with DISTINCT
- How to search for text patterns with LIKE, ILIKE, and wildcards
- How to filter against value lists with IN and ranges with BETWEEN

## Prerequisites
- Complete Day 2 (comfortable with SELECT, WHERE, and comparison operators)

## Dataset

Run this SQL in pgAdmin to create today's table.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop table if it already exists (safe to re-run)
DROP TABLE IF EXISTS online_orders;

-- Create the online_orders table
CREATE TABLE online_orders (
    order_id        SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100)   NOT NULL,
    email           VARCHAR(150)   NOT NULL,
    product_name    VARCHAR(100)   NOT NULL,
    category        VARCHAR(50)    NOT NULL,
    order_amount    NUMERIC(10, 2) NOT NULL,
    order_date      DATE           NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    is_member       BOOLEAN        NOT NULL DEFAULT FALSE
);

-- Insert 30 orders
INSERT INTO online_orders (customer_name, email, product_name, category, order_amount, order_date, region, is_member)
VALUES
    ('Amara Osei',      'amara.osei@gmail.com',        'Wireless Headphones',     'Electronics',    89.99,  '2025-01-05', 'London',          TRUE),
    ('Callum Fraser',   'callum.fraser@outlook.com',   'Running Shoes',           'Sportswear',    124.50,  '2025-01-08', 'Scotland',        FALSE),
    ('Priya Sharma',    'priya.sharma@gmail.com',       'Yoga Mat',               'Sportswear',     34.99,  '2025-01-10', 'London',          TRUE),
    ('Finn McCarthy',   'finn.mccarthy@yahoo.co.uk',   'Coffee Machine',          'Kitchen',       219.00,  '2025-01-12', 'Wales',           FALSE),
    ('Isla Nguyen',     'isla.nguyen@hotmail.com',      'Desk Lamp',              'Home Office',    47.50,  '2025-01-14', 'North West',      TRUE),
    ('Ravi Kapoor',     'ravi.kapoor@gmail.com',        'Bluetooth Speaker',      'Electronics',    65.00,  '2025-01-15', 'West Midlands',   FALSE),
    ('Sienna Clarke',   'sienna.clarke@shopstream.com', 'Standing Desk',          'Home Office',   349.99,  '2025-01-18', 'London',          TRUE),
    ('Euan Campbell',   'euan.campbell@gmail.com',      'Trail Boots',            'Sportswear',    159.00,  '2025-01-20', 'Scotland',        TRUE),
    ('Nia Reeves',      'nia.reeves@outlook.com',       'Air Fryer',              'Kitchen',       129.99,  '2025-01-22', 'Wales',           FALSE),
    ('Mateo Silva',     'mateo.silva@gmail.com',        'Laptop Stand',           'Home Office',    59.99,  '2025-01-25', 'South East',      TRUE),
    ('Freya Anderson',  'freya.anderson@yahoo.co.uk',   'Protein Powder',         'Sportswear',     42.00,  '2025-01-28', 'North East',      FALSE),
    ('Arjun Patel',     'arjun.patel@shopstream.com',   'Monitor 27 inch',        'Electronics',   329.00,  '2025-02-01', 'London',          TRUE),
    ('Yuki Tanaka',     'yuki.tanaka@gmail.com',        'Blender Pro',            'Kitchen',        89.00,  '2025-02-03', 'East Midlands',   FALSE),
    ('Safiya Hassan',   'safiya.hassan@outlook.com',    'Wireless Mouse',         'Electronics',    29.99,  '2025-02-05', 'North West',      TRUE),
    ('Quinn Byrne',     'quinn.byrne@hotmail.com',      'Resistance Bands',       'Sportswear',     18.50,  '2025-02-07', 'Wales',           FALSE),
    ('Wei Zhang',       'wei.zhang@gmail.com',          'Mechanical Keyboard',    'Electronics',   149.00,  '2025-02-10', 'London',          TRUE),
    ('Idris Okafor',    'idris.okafor@yahoo.co.uk',    'Slow Cooker',            'Kitchen',        74.99,  '2025-02-12', 'West Midlands',   FALSE),
    ('Leila Hussain',   'leila.hussain@shopstream.com', 'Ergonomic Chair',        'Home Office',   499.00,  '2025-02-14', 'South East',      TRUE),
    ('Sage Kowalski',   'sage.kowalski@gmail.com',      'Dumbbells Set',          'Sportswear',     95.00,  '2025-02-16', 'Scotland',        TRUE),
    ('Kwame Mensah',    'kwame.mensah@outlook.com',     'Webcam HD',              'Electronics',    79.99,  '2025-02-18', 'North East',      FALSE),
    ('Mei Lin',         'mei.lin@gmail.com',            'Toaster Oven',           'Kitchen',        64.50,  '2025-02-20', 'East Midlands',   TRUE),
    ('Jordan Ellis',    'jordan.ellis@hotmail.com',     'Laptop Backpack',        'Home Office',    55.00,  '2025-02-22', 'London',          FALSE),
    ('Zara Ibrahim',    'zara.ibrahim@gmail.com',       'Smart Watch',            'Electronics',   199.99,  '2025-02-25', 'North West',      TRUE),
    ('River Chen',      'river.chen@shopstream.com',    'Kettlebell 16kg',        'Sportswear',     45.00,  '2025-02-28', 'Wales',           FALSE),
    ('Phoenix Taylor',  'phoenix.taylor@yahoo.co.uk',   'Electric Kettle',        'Kitchen',        39.99,  '2025-03-02', 'South East',      TRUE),
    ('Aisha Mohammed',  'aisha.mohammed@gmail.com',     'USB-C Hub',              'Electronics',    44.99,  '2025-03-05', 'West Midlands',   FALSE),
    ('Lucas Fernandez', 'lucas.fernandez@outlook.com',  'Foam Roller',            'Sportswear',     24.99,  '2025-03-08', 'Scotland',        TRUE),
    ('Nina Volkov',     'nina.volkov@hotmail.com',      'Knife Set',              'Kitchen',       189.00,  '2025-03-10', 'London',          FALSE),
    ('Jamal Williams',  'jamal.williams@gmail.com',     'Monitor Arm',            'Home Office',    69.99,  '2025-03-12', 'North East',      TRUE),
    ('Freya Mitchell',  'freya.mitchell@shopstream.com','Fitness Tracker',         'Electronics',   149.99,  '2025-03-15', 'East Midlands',   FALSE);
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM online_orders;
-- Expected: 30 rows
```

## Exercises

You're a sales analyst at ShopStream, a UK-based e-commerce company. The Head of Sales, Marcus, has sent you a message. He needs a quick analysis for tomorrow's regional review meeting. The board wants to understand Q1 2025 order patterns, and he's got questions he needs answered by end of day.

Using the `online_orders` table above, answer these questions:

### 🟢 Warm-Up

**Q1:** What are all the unique product categories ShopStream sells? List them in alphabetical order.

**Q2:** What are the top 10 highest-value orders? Show the customer name, product, amount, and region, sorted from highest to lowest.

### 🟡 Practice

**Q3:** Find all orders from London, North West, and West Midlands where the order amount is between $40 and $150. Sort by region, then by amount (highest first).

**Q4:** Which customers placed orders using a `@shopstream.com` email address? Show their names, emails, products, and amounts, sorted by amount (highest first).

**Q5:** Find all Sportswear orders from regions outside Scotland. Sort by amount (highest first).

### 🔴 Challenge

**Q6:** Find Gmail customers in London, Scotland, or Wales with order amounts between $30 and $300. Sort by region, then by amount (highest first), and show only the top 10.

**Q7:** Marcus also wants to know the second page of results for orders sorted by date (most recent first) - specifically rows 11 through 20. Write a query that returns this exact "page 2" of results using OFFSET and LIMIT.

## Key Concepts Covered
- **ORDER BY:** Sorts results - ASC (low to high, A to Z, oldest first) is the default; DESC reverses it
- **Multi-column sorting:** Sort by one column first, then break ties with a second column
- **LIMIT and OFFSET:** LIMIT controls how many rows come back; OFFSET skips rows for pagination
- **DISTINCT:** Removes duplicate values - works on single columns or unique combinations of multiple columns
- **LIKE and ILIKE:** Pattern matching with `%` (any characters) and `_` (exactly one character); ILIKE ignores case (PostgreSQL only)
- **IN and BETWEEN:** IN matches against a list of values; BETWEEN filters within an inclusive range (works on numbers, dates, and text)

---

[← Day 2: SELECT & WHERE](../day-02/) | [Day 4: Aggregate Functions & GROUP BY →](../day-04/)
