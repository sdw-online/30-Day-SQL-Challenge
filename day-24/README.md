# Day 24 - SCD Types & MERGE

[Watch the video](COMING_SOON) | [← Day 23: Window Functions Part 2](../day-23/) | [Day 25: Views & Materialised Views →](../day-25/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- The four SCD (Slowly Changing Dimension) types and when to use each one
- How to implement SCD Type 2 with effective dates, end dates, and a current flag
- How to use MERGE for insert-or-update operations in a single statement
- How to use INSERT ... ON CONFLICT for PostgreSQL-native upserts

## Prerequisites
- Complete Days 1-23
- Complete Day 20 (star schema / dimensional modelling) - today builds directly on that foundation
- PostgreSQL version **15 or later** for MERGE statement support (run `SELECT version();` to check)

## Dataset

You are an analytics engineer at **Nexus Freight**, a UK-based logistics company. The data team loads customer data from the operational CRM into a data warehouse nightly. Your job is to build a dimension table that preserves historical changes - so the reporting team can answer questions like "What was this customer's tier when they placed that order six months ago?"

This setup creates three tables and requires running a Python script to populate them with realistic data.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS stg_customers_updated;
DROP TABLE IF EXISTS dim_customer_scd;
DROP TABLE IF EXISTS stg_customers;

-- STAGING TABLE: Today's CRM Extract
CREATE TABLE stg_customers (
    customer_id     VARCHAR(20)    PRIMARY KEY,
    customer_name   VARCHAR(100)   NOT NULL,
    email           VARCHAR(150)   NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    tier            VARCHAR(20)    NOT NULL,
    signup_date     DATE           NOT NULL
);

-- DIMENSION TABLE: SCD Type 2 Target
CREATE TABLE dim_customer_scd (
    customer_key    SERIAL PRIMARY KEY,
    customer_id     VARCHAR(20)    NOT NULL,
    customer_name   VARCHAR(100)   NOT NULL,
    email           VARCHAR(150)   NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    tier            VARCHAR(20)    NOT NULL,
    signup_date     DATE           NOT NULL,
    effective_from  DATE           NOT NULL,
    effective_to    DATE           NOT NULL DEFAULT '9999-12-31',
    is_current      BOOLEAN        NOT NULL DEFAULT TRUE
);

-- STAGING TABLE: Tomorrow's CRM Extract (with changes)
CREATE TABLE stg_customers_updated (
    customer_id     VARCHAR(20)    PRIMARY KEY,
    customer_name   VARCHAR(100)   NOT NULL,
    email           VARCHAR(150)   NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    tier            VARCHAR(20)    NOT NULL,
    signup_date     DATE           NOT NULL
);
```

</details>

### Populate with Python

The data for this lesson is generated with a Python script that uses `psycopg2` and `faker`. The script creates:

- **stg_customers** - 200 customer records (today's CRM extract)
- **dim_customer_scd** - 200 records (initial dimension load, all marked as current)
- **stg_customers_updated** - 205 records (tomorrow's extract with 20 tier changes, 10 region changes, and 5 new customers)

1. Install dependencies: `pip install psycopg2-binary faker`
2. Download and run the data generation script from the [setup file in the course repository](https://github.com/sdw-online/claude-ai-agents/blob/main/media-team/projects/courses/30-day-sql-challenge/day-24/24-setup.md)
3. Update the `DB_USER` and `DB_PASSWORD` values in the script to match your PostgreSQL setup
4. Run: `python day_24_seed.py`

### Verify Your Setup

```sql
SELECT 'stg_customers' AS table_name, COUNT(*) AS row_count FROM stg_customers
UNION ALL
SELECT 'dim_customer_scd', COUNT(*) FROM dim_customer_scd
UNION ALL
SELECT 'stg_customers_updated', COUNT(*) FROM stg_customers_updated
ORDER BY table_name;

-- Expected: stg_customers = 200, dim_customer_scd = 200, stg_customers_updated = 205
```

```sql
-- Confirm all dimension records are currently active
SELECT
    COUNT(*) FILTER (WHERE is_current = TRUE)  AS current_records,
    COUNT(*) FILTER (WHERE is_current = FALSE) AS expired_records
FROM dim_customer_scd;
-- Expected: 200 current, 0 expired
```

```sql
-- Confirm changes exist in the updated staging table
SELECT COUNT(*)
FROM stg_customers s
JOIN stg_customers_updated u ON s.customer_id = u.customer_id
WHERE s.tier <> u.tier OR s.region <> u.region;
-- Expected: 30 rows (20 tier changes + 10 region changes)
```

## Exercises

You are a data engineer at NovaTech - an e-commerce company that processes 50,000 orders a day. Your team lead, Marcus, messages you on Monday morning. The company just migrated its data warehouse to PostgreSQL 15 over the weekend. Marcus needs you to verify the SCD logic is working correctly before the executive dashboard goes live at 3pm.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Compare `stg_customers` and `stg_customers_updated` to find all customers whose tier changed between the two extracts. Show the customer ID, old tier, and new tier. How many tier changes are there?

**Q2:** Are there any customers where `is_current = TRUE` appears more than once in `dim_customer_scd`? That would indicate the expiry step in the pipeline failed and is causing duplicate-counted revenue in every report.

### 🟡 Practice

**Q3:** Write a query that detects all changes between `stg_customers_updated` and `dim_customer_scd` (current rows only). Flag each customer as 'NEW', 'CHANGED', or 'UNCHANGED'. How many fall into each category?

**Q4:** Write the full SCD Type 2 pipeline: detect changes between `stg_customers_updated` and `dim_customer_scd`, expire old versions (set `effective_to` and `is_current = FALSE`), and insert new versions. Then validate that every customer in the updated staging table has exactly one current row in the dimension.

**Q5:** Write an INSERT ... ON CONFLICT statement that performs a Type 1 (overwrite) update on the `email` column in `stg_customers` when a conflict occurs on `customer_id`. Explain why ON CONFLICT is simpler than MERGE for this use case.

### 🔴 Challenge

**Q6:** Write a MERGE statement that performs a Type 1 (overwrite) update for the `email` column and a Type 2 (add new row) update for the `tier` column - in the same pipeline run. This is how real data warehouses handle mixed SCD types: some columns are overwritten silently, whilst others trigger a full version history.

**Q7:** After running your SCD Type 2 pipeline, pick a customer who changed tier. Write a historical join that would match each of that customer's orders to the correct dimension version using `WHERE order_date BETWEEN effective_from AND effective_to`. Explain why this join produces the correct tier at the time of each order, not the current tier.

## Key Concepts Covered
- **SCD Type 0** - retain the original value forever (e.g., signup date); never overwrite
- **SCD Type 1** - overwrite with the new value; simple but destroys history permanently
- **SCD Type 2** - add a new row with date ranges (effective_from, effective_to, is_current); preserves full history
- **SCD Type 3** - store current and previous value side by side; only one level of history
- **MERGE statement** - compare source against target and insert, update, or delete in one statement (PostgreSQL 15+)
- **INSERT ... ON CONFLICT** - PostgreSQL-native upsert pattern; simpler but less flexible than MERGE

---

[← Day 23: Window Functions Part 2](../day-23/) | [Day 25: Views & Materialised Views →](../day-25/)
