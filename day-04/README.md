# Day 4 - Aggregate Functions & GROUP BY

[Watch the video](COMING_SOON) | [← Day 3: ORDER BY, LIMIT & LIKE](../day-03/) | [Day 5: INSERT, UPDATE & DELETE →](../day-05/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to summarise data with the five core aggregate functions: COUNT, SUM, AVG, MIN, MAX
- How to count unique values with COUNT(DISTINCT)
- How to split data into categories with GROUP BY
- How to filter groups after aggregation with HAVING
- How SQL execution order works (FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT)

## Prerequisites
- Complete Day 3 (comfortable with ORDER BY, LIMIT, DISTINCT, LIKE, IN, and BETWEEN)

## Dataset

Day 4 uses a Python-generated dataset for more realistic data variety. You have two options:

### Option A: SQL-Only Setup (Recommended)

Run this SQL in pgAdmin to create and populate the table with 50 rows.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
DROP TABLE IF EXISTS sales_transactions;

CREATE TABLE sales_transactions (
    transaction_id  SERIAL PRIMARY KEY,
    sales_rep       VARCHAR(100)   NOT NULL,
    department      VARCHAR(50)    NOT NULL,
    client_name     VARCHAR(100)   NOT NULL,
    product_tier    VARCHAR(20)    NOT NULL,
    deal_amount     NUMERIC(10, 2) NOT NULL,
    transaction_date DATE          NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    is_renewal      BOOLEAN        NOT NULL DEFAULT FALSE
);

INSERT INTO sales_transactions (sales_rep, department, client_name, product_tier, deal_amount, transaction_date, region, is_renewal)
VALUES
    ('Amara Osei',      'Enterprise',    'Vertex Solutions',       'Enterprise',    52340.00, '2025-01-07', 'London',         FALSE),
    ('Amara Osei',      'Enterprise',    'Quantum Analytics',      'Business',      18750.50, '2025-01-14', 'London',         TRUE),
    ('Amara Osei',      'Enterprise',    'Atlas Digital',          'Enterprise',    67200.00, '2025-02-03', 'South East',     FALSE),
    ('Amara Osei',      'Enterprise',    'Pinnacle Tech',          'Business',      12800.00, '2025-03-18', 'London',         TRUE),
    ('Amara Osei',      'Enterprise',    'Orion Systems',          'Professional',   7450.00, '2025-04-22', 'South East',     FALSE),
    ('Ravi Kapoor',     'Mid-Market',    'Birch & Partners',       'Professional',   5200.00, '2025-01-10', 'North West',     FALSE),
    ('Ravi Kapoor',     'Mid-Market',    'Clearview Data',         'Business',      11340.75, '2025-01-28', 'Scotland',       TRUE),
    ('Ravi Kapoor',     'Mid-Market',    'Forge Analytics',        'Professional',   3890.00, '2025-02-15', 'North West',     FALSE),
    ('Ravi Kapoor',     'Mid-Market',    'Summit Labs',            'Starter',        1250.00, '2025-03-05', 'Scotland',       FALSE),
    ('Ravi Kapoor',     'Mid-Market',    'Nimbus Cloud',           'Business',      15600.00, '2025-04-12', 'North West',     TRUE),
    ('Sienna Clarke',   'SMB',           'Little Oak Studio',      'Starter',         890.00, '2025-01-15', 'Wales',          FALSE),
    ('Sienna Clarke',   'SMB',           'Fern & Ivy Co',         'Starter',        1450.00, '2025-02-01', 'Wales',          FALSE),
    ('Sienna Clarke',   'SMB',           'Coastal Creative',       'Professional',   4200.00, '2025-02-20', 'South East',     TRUE),
    ('Sienna Clarke',   'SMB',           'Pixel & Grain',         'Starter',        2100.00, '2025-03-14', 'West Midlands',  FALSE),
    ('Sienna Clarke',   'SMB',           'River Digital',          'Professional',   6780.00, '2025-04-30', 'Wales',          TRUE),
    ('Finn McCarthy',   'Partnerships',  'TechBridge UK',          'Business',      22000.00, '2025-01-20', 'East Midlands',  FALSE),
    ('Finn McCarthy',   'Partnerships',  'Innovate Alliance',      'Enterprise',    45800.00, '2025-02-10', 'London',         FALSE),
    ('Finn McCarthy',   'Partnerships',  'DataFlow Partners',      'Business',      19500.00, '2025-03-01', 'North East',     TRUE),
    ('Finn McCarthy',   'Partnerships',  'Catalyst Group',         'Enterprise',    58900.00, '2025-04-08', 'London',         FALSE),
    ('Finn McCarthy',   'Partnerships',  'NexGen Solutions',       'Professional',   7100.00, '2025-05-15', 'East Midlands',  TRUE),
    ('Yuki Tanaka',     'Enterprise',    'Helix Corp',             'Enterprise',    41200.00, '2025-01-25', 'Scotland',       FALSE),
    ('Yuki Tanaka',     'Enterprise',    'Meridian Global',        'Business',      24500.00, '2025-02-18', 'London',         TRUE),
    ('Yuki Tanaka',     'Enterprise',    'Apex Industries',        'Enterprise',    63000.00, '2025-03-10', 'South East',     FALSE),
    ('Yuki Tanaka',     'Enterprise',    'Crown Analytics',        'Professional',   5800.00, '2025-04-20', 'Scotland',       FALSE),
    ('Yuki Tanaka',     'Enterprise',    'Skyline Digital',        'Business',      16300.00, '2025-05-28', 'London',         TRUE),
    ('Kwame Mensah',    'Mid-Market',    'Bolt Media',             'Professional',   4100.00, '2025-01-30', 'West Midlands',  FALSE),
    ('Kwame Mensah',    'Mid-Market',    'Prism Analytics',        'Business',       9800.00, '2025-02-22', 'North East',     FALSE),
    ('Kwame Mensah',    'Mid-Market',    'Echo Ventures',          'Starter',        1800.00, '2025-03-15', 'West Midlands',  TRUE),
    ('Kwame Mensah',    'Mid-Market',    'Crest Solutions',        'Professional',   6200.00, '2025-04-25', 'North East',     FALSE),
    ('Kwame Mensah',    'Mid-Market',    'Horizon Labs',           'Business',      13400.00, '2025-05-30', 'West Midlands',  TRUE),
    ('Isla Nguyen',     'SMB',           'Amber & Co',             'Starter',        1100.00, '2025-01-12', 'East Midlands',  FALSE),
    ('Isla Nguyen',     'SMB',           'Jade Digital',           'Professional',   3500.00, '2025-02-05', 'North West',     FALSE),
    ('Isla Nguyen',     'SMB',           'Willow Creative',        'Starter',         750.00, '2025-03-20', 'East Midlands',  TRUE),
    ('Isla Nguyen',     'SMB',           'Maple Analytics',        'Professional',   5900.00, '2025-04-15', 'North West',     FALSE),
    ('Isla Nguyen',     'SMB',           'Cedar Tech',             'Business',       8500.00, '2025-05-22', 'East Midlands',  TRUE),
    ('Mateo Silva',     'Partnerships',  'LinkBridge Co',          'Business',      20100.00, '2025-01-18', 'London',         FALSE),
    ('Mateo Silva',     'Partnerships',  'Unity Partners',         'Enterprise',    35600.00, '2025-02-25', 'South East',     TRUE),
    ('Mateo Silva',     'Partnerships',  'Synergy Group',          'Professional',   6400.00, '2025-03-28', 'London',         FALSE),
    ('Mateo Silva',     'Partnerships',  'Pathway Digital',        'Business',      17800.00, '2025-04-18', 'South East',     FALSE),
    ('Mateo Silva',     'Partnerships',  'Alliance Tech',          'Enterprise',    48200.00, '2025-05-10', 'London',         TRUE),
    ('Leila Hussain',   'Enterprise',    'Zenith Corp',            'Enterprise',    55400.00, '2025-02-08', 'North West',     FALSE),
    ('Leila Hussain',   'Enterprise',    'Vanguard Analytics',     'Business',      21700.00, '2025-03-12', 'London',         TRUE),
    ('Leila Hussain',   'Enterprise',    'Frontier Systems',       'Enterprise',    70100.00, '2025-04-02', 'North West',     FALSE),
    ('Leila Hussain',   'Enterprise',    'Titan Digital',          'Professional',   4600.00, '2025-05-05', 'London',         FALSE),
    ('Leila Hussain',   'Enterprise',    'Summit Analytics',       'Business',      19200.00, '2025-06-18', 'North West',     TRUE),
    ('Euan Campbell',   'SMB',           'Glen Tech',              'Starter',        1600.00, '2025-01-22', 'Scotland',       FALSE),
    ('Euan Campbell',   'SMB',           'Thistle Digital',        'Professional',   3200.00, '2025-02-14', 'Scotland',       TRUE),
    ('Euan Campbell',   'SMB',           'Loch Analytics',         'Starter',        2400.00, '2025-03-25', 'Scotland',       FALSE),
    ('Euan Campbell',   'SMB',           'Highland Solutions',     'Business',      10500.00, '2025-04-28', 'Scotland',       FALSE),
    ('Euan Campbell',   'SMB',           'Cairn Media',            'Professional',   5100.00, '2025-06-02', 'Scotland',       TRUE);
```

</details>

### Option B: Python-Generated Dataset (80 rows)

If you want more data to work with, see the setup file in the course repository. It uses a Python script with `psycopg2` and `faker` to generate 80 realistic transactions. The SQL-only option above is sufficient for all exercises.

### Verify Your Setup

```sql
SELECT COUNT(*) FROM sales_transactions;
-- Expected: 50 rows (SQL option) or 80 rows (Python option)
```

## Exercises

You're a sales operations analyst at CloudMetrics - a B2B SaaS company. The VP of Sales, Marcus, is preparing for the H1 board meeting and he needs answers from the sales data. His board presentation is tomorrow, and the CEO wants to see exactly where the pipeline stands.

Using the `sales_transactions` table above, answer these questions:

### 🟢 Warm-Up

**Q1:** Give Marcus the headline numbers - total deals, total revenue, average deal size, smallest deal, and biggest deal. All in one query.

**Q2:** How many unique clients did CloudMetrics sell to? And how many sales reps are actively making sales?

### 🟡 Practice

**Q3:** Break down revenue by region. Show the number of deals, total revenue, and average deal size for each region, sorted by revenue (highest first).

**Q4:** Which sales reps brought in more than $80,000 in total revenue? Marcus needs names for the bonus shortlist. Show the rep name, number of deals closed, and total revenue.

**Q5:** For new business only (exclude renewals), show monthly revenue. Only include months where new business revenue exceeded $50,000. Show the month number, month name, number of deals, and total revenue.

### 🔴 Challenge

**Q6:** Write a query that shows the average deal size per product tier, but only for tiers where the average deal size is above $10,000. Sort by average deal size, highest first. Which tier has the largest average deal, and by how much does it exceed the next tier?

**Q7:** Marcus wants to see each department's renewal rate - the percentage of deals that are renewals. Show the department name, total deals, renewal count, and the renewal percentage rounded to one decimal place. Sort by renewal percentage, highest first.

## Key Concepts Covered
- **Aggregate functions:** COUNT (how many), SUM (total), AVG (average), MIN (smallest), MAX (largest) - they collapse many rows into a single summary value
- **COUNT(DISTINCT):** Counts unique values only, ignoring duplicates - essential for knowing how many different clients, reps, or categories you have
- **GROUP BY:** Splits rows into groups and runs aggregates per group - turns one total into a total per department, region, or month
- **HAVING:** Filters groups after aggregation - use it when your filter condition involves an aggregate function (WHERE cannot do this)
- **SQL execution order:** FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT - this explains why aliases work in ORDER BY but not in WHERE
- **ROUND():** Wraps AVG to trim long decimal strings down to a readable number of decimal places

---

[← Day 3: ORDER BY, LIMIT & LIKE](../day-03/) | [Day 5: INSERT, UPDATE & DELETE →](../day-05/)
