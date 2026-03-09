# Day 29 - PostgreSQL Pro Tips & Shortcuts

[Watch the video](COMING_SOON) | [← Day 28: EXPLAIN & Indexing](../day-28/) | [Day 30: Capstone Project →](../day-30/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- 10 PostgreSQL shortcuts that replace verbose multi-step workarounds with cleaner, faster alternatives
- DISTINCT ON for first-row-per-group problems without window functions
- FILTER for conditional aggregation without CASE WHEN
- RETURNING, generate_series(), LATERAL joins, string_agg(), TABLESAMPLE, dollar-quoting, EXCLUDED, and partial indexes

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Day 28
- PostgreSQL 15 or later recommended (`SELECT version();` to check)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS daily_metrics;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS feature_events;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS subscription_plans;

-- TABLE 1: subscription_plans
CREATE TABLE subscription_plans (
    plan_id             SERIAL PRIMARY KEY,
    plan_name           VARCHAR(40)     NOT NULL UNIQUE,
    monthly_price       NUMERIC(8,2)    NOT NULL,
    max_users           INTEGER         NOT NULL,
    has_api_access      BOOLEAN         NOT NULL DEFAULT FALSE,
    has_priority_support BOOLEAN        NOT NULL DEFAULT FALSE
);

-- TABLE 2: customers
CREATE TABLE customers (
    customer_id         SERIAL PRIMARY KEY,
    company_name        VARCHAR(120)    NOT NULL,
    contact_name        VARCHAR(80)     NOT NULL,
    contact_email       VARCHAR(120)    NOT NULL UNIQUE,
    plan_id             INTEGER         NOT NULL REFERENCES subscription_plans(plan_id),
    signup_date         DATE            NOT NULL,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    churned_date        DATE,
    region              VARCHAR(40)     NOT NULL
);

-- TABLE 3: feature_events
CREATE TABLE feature_events (
    event_id            SERIAL PRIMARY KEY,
    customer_id         INTEGER         NOT NULL REFERENCES customers(customer_id),
    feature_name        VARCHAR(60)     NOT NULL,
    event_timestamp     TIMESTAMP       NOT NULL,
    duration_seconds    INTEGER         NOT NULL CHECK (duration_seconds >= 0)
);

-- TABLE 4: support_tickets
CREATE TABLE support_tickets (
    ticket_id           SERIAL PRIMARY KEY,
    customer_id         INTEGER         NOT NULL REFERENCES customers(customer_id),
    subject             VARCHAR(200)    NOT NULL,
    priority            VARCHAR(20)     NOT NULL CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
    status              VARCHAR(20)     NOT NULL CHECK (status IN ('Open', 'In Progress', 'Resolved', 'Closed')),
    created_at          TIMESTAMP       NOT NULL,
    resolved_at         TIMESTAMP,
    resolution_hours    NUMERIC(8,2)
);

-- TABLE 5: invoices
CREATE TABLE invoices (
    invoice_id          SERIAL PRIMARY KEY,
    customer_id         INTEGER         NOT NULL REFERENCES customers(customer_id),
    invoice_date        DATE            NOT NULL,
    amount              NUMERIC(10,2)   NOT NULL,
    payment_status      VARCHAR(20)     NOT NULL CHECK (payment_status IN ('Paid', 'Pending', 'Overdue', 'Failed')),
    paid_date           DATE
);

-- TABLE 6: daily_metrics (intentionally has gaps for generate_series exercises)
CREATE TABLE daily_metrics (
    metric_date         DATE            PRIMARY KEY,
    daily_active_users  INTEGER         NOT NULL,
    daily_revenue       NUMERIC(10,2)   NOT NULL,
    new_signups         INTEGER         NOT NULL,
    tickets_opened      INTEGER         NOT NULL
);

-- INSERT: Subscription plans
INSERT INTO subscription_plans (plan_name, monthly_price, max_users, has_api_access, has_priority_support) VALUES
    ('Free',          0.00,    2,   FALSE, FALSE),
    ('Starter',       29.00,   5,   FALSE, FALSE),
    ('Professional',  79.00,   20,  TRUE,  FALSE),
    ('Business',      199.00,  50,  TRUE,  TRUE),
    ('Enterprise',    499.00,  999, TRUE,  TRUE);
```

</details>

**Important:** This day requires a Python script to generate the customers, feature events, support tickets, invoices, and daily metrics data. See the video or the setup guide for the full `day_29_seed.py` script. The daily_metrics table intentionally has ~35 missing dates for the generate_series() gap-filling exercises.

### Verify Your Setup

```sql
SELECT COUNT(*) FROM subscription_plans;
-- Expected: 5 rows

SELECT COUNT(*) FROM customers;
-- Expected: 200 rows

SELECT COUNT(*) FROM feature_events;
-- Expected: 3,000 rows

SELECT COUNT(*) FROM support_tickets;
-- Expected: 600 rows

SELECT COUNT(*) FROM invoices;
-- Expected: 800 rows

SELECT COUNT(*) FROM daily_metrics;
-- Expected: ~330 rows (365 minus ~35 intentional gaps)
```

## Exercises

You are a senior analytics engineer at Helios Analytics, a UK-based SaaS platform. The quarterly business review is in two days. Your head of data, Callum, sends you a message on Monday morning with seven queries the leadership team needs - and each one uses a different PostgreSQL shortcut.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1 (DISTINCT ON):** For each active customer, find their very first feature event - the earliest `event_timestamp`. Use `DISTINCT ON` instead of a window function. Your result should have one row per customer showing customer_id, company_name, feature_name, and event_timestamp.

**Q2 (FILTER):** Produce a ticket breakdown by priority showing total tickets, the count of open tickets, the count of resolved/closed tickets, and the average resolution hours for resolved/closed tickets. Use `FILTER (WHERE ...)` instead of CASE WHEN.

### 🟡 Practice

**Q3 (generate_series):** Create a gap-filled daily revenue report for the full year (2024-07-01 to 2025-06-30). Every date must appear - days with no data should show 0 for revenue and be flagged as 'MISSING'. Use `generate_series()` with a LEFT JOIN.

**Q4 (LATERAL):** For the top 20 customers by total event count, find each customer's three longest feature sessions (by duration_seconds). Use a CTE for the top 20 and `CROSS JOIN LATERAL` for the top 3 sessions per customer.

**Q5 (string_agg):** For each region, show the customer count and a comma-separated list of all distinct features used (alphabetically sorted). Use `string_agg(DISTINCT ..., ', ' ORDER BY ...)`.

### 🔴 Challenge

**Q6 (EXCLUDED + RETURNING):** Write an upsert statement that inserts a row into `daily_metrics` for 2025-03-15 with values of your choice. If the date already exists, update all columns using `EXCLUDED`. Add a `RETURNING` clause to see the final state of the row. Run it twice and explain how the output differs each time.

**Q7 (Partial index + EXPLAIN ANALYSE):** Create a partial index on `support_tickets` that only covers open and in-progress tickets. Then write a query that filters to those statuses and prove with EXPLAIN ANALYSE that PostgreSQL uses your partial index instead of scanning the full table. Compare the index size to what a full index would be.

## Key Concepts Covered
- **DISTINCT ON:** Replaces ROW_NUMBER subqueries for first-row-per-group problems - cleaner and often faster
- **FILTER clause:** Attaches a WHERE condition to an individual aggregate, replacing verbose CASE WHEN blocks
- **generate_series():** Creates complete date or number sequences for gap-filling - replaces recursive CTEs
- **LATERAL joins:** Runs a correlated subquery per row, like a for-each loop - ideal for top-N-per-group problems
- **RETURNING and EXCLUDED:** Get affected rows back from INSERT/UPDATE/DELETE in one round trip; EXCLUDED references the attempted insert values during upserts
- **Partial indexes:** Index only the rows you actually query - smaller, faster, and cheaper to maintain

---

[← Day 28: EXPLAIN & Indexing](../day-28/) | [Day 30: Capstone Project →](../day-30/)
