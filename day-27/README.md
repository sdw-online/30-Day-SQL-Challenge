# Day 27 - CREATE FUNCTION (UDFs)

[Watch the video](COMING_SOON) | [← Day 26: Information Schema & Metadata](../day-26/) | [Day 28: EXPLAIN & Indexing →](../day-28/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to create reusable user-defined functions (UDFs) in PostgreSQL using PL/pgSQL
- The difference between scalar functions (one value) and set-returning functions (multiple rows)
- How to use parameters, default values, and the DECLARE block for local variables
- How volatility labels (IMMUTABLE, STABLE, VOLATILE) affect performance and correctness
- How to manage functions with DROP, CREATE OR REPLACE, and overloading

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Day 26
- PostgreSQL 15 or later recommended (`SELECT version();` to check)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS policy_types;

-- TABLE 1: policy_types
CREATE TABLE policy_types (
    type_id         SERIAL PRIMARY KEY,
    type_name       VARCHAR(40)     NOT NULL,
    base_rate       NUMERIC(5,2)    NOT NULL,
    risk_multiplier NUMERIC(4,2)    NOT NULL DEFAULT 1.00
);

-- TABLE 2: agents
CREATE TABLE agents (
    agent_id        SERIAL PRIMARY KEY,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    office_city     VARCHAR(60)     NOT NULL,
    hire_date       DATE            NOT NULL,
    commission_rate NUMERIC(4,3)    NOT NULL DEFAULT 0.050
);

-- TABLE 3: customers
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    date_of_birth   DATE            NOT NULL,
    risk_score      INTEGER         NOT NULL CHECK (risk_score BETWEEN 1 AND 100),
    region          VARCHAR(60)     NOT NULL,
    signup_date     DATE            NOT NULL
);

-- TABLE 4: policies
CREATE TABLE policies (
    policy_id       SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customers(customer_id),
    agent_id        INTEGER         NOT NULL REFERENCES agents(agent_id),
    type_id         INTEGER         NOT NULL REFERENCES policy_types(type_id),
    annual_premium  NUMERIC(10,2)   NOT NULL,
    coverage_amount NUMERIC(12,2)   NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 5: claims
CREATE TABLE claims (
    claim_id        SERIAL PRIMARY KEY,
    policy_id       INTEGER         NOT NULL REFERENCES policies(policy_id),
    claim_amount    NUMERIC(10,2)   NOT NULL,
    claim_date      DATE            NOT NULL,
    status          VARCHAR(20)     NOT NULL CHECK (status IN ('Filed', 'Under Review', 'Approved', 'Denied', 'Settled')),
    settlement_amount NUMERIC(10,2)
);

-- INSERT: Policy types
INSERT INTO policy_types (type_name, base_rate, risk_multiplier) VALUES
    ('Motor',    45.00, 1.20),
    ('Home',     30.00, 1.10),
    ('Life',     55.00, 1.50),
    ('Travel',   15.00, 1.05),
    ('Pet',      20.00, 1.08),
    ('Business', 80.00, 1.35);
```

</details>

**Important:** This day requires a Python script to generate the customers, agents, policies, and claims data. See the video or the setup guide for the full `day_27_seed.py` script. Alternatively, you can populate the tables manually with your own sample data - the exercises work with any reasonable dataset.

### Verify Your Setup

```sql
SELECT COUNT(*) FROM policy_types;
-- Expected: 6 rows

SELECT COUNT(*) FROM agents;
-- Expected: 15 rows

SELECT COUNT(*) FROM customers;
-- Expected: 120 rows

SELECT COUNT(*) FROM policies;
-- Expected: 250 rows

SELECT COUNT(*) FROM claims;
-- Expected: 180 rows
```

## Exercises

You are an analytics engineer at Pinnacle Insurance, a UK-based insurance company. The head of data, Ravi, has come to you with three problems.

First - different analysts classify risk scores differently. Some use five tiers, some use three. Some put the boundary at 60, others at 70. Ten analysts, ten slightly different definitions, and nobody notices until two reports contradict each other in a board meeting.

Second - the claims team, the underwriting team, and the finance team all define "major claim" differently. Some say $10K is major, others say $50K.

Third - the sales ops team calculates agent performance manually in Excel every month. The spreadsheet is always slightly different each time.

Ravi's directive is clear: "Build me a function library. I want every team using the same definitions. No more spreadsheet arguments."

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Create a simple function called `premium_per_day` that takes a NUMERIC `annual_premium` and returns the daily premium amount (annual premium divided by 365, rounded to 2 decimal places). Use `LANGUAGE sql` since it is a single expression. Test it with `SELECT premium_per_day(5000);`

**Q2:** Create a function called `classify_customer_risk` that takes an INTEGER risk score and returns a TEXT label. Use these tiers: 1-20 = 'Low Risk', 21-40 = 'Moderate Risk', 41-60 = 'Standard Risk', 61-80 = 'Elevated Risk', 81-100 = 'High Risk'. Handle NULL inputs by returning 'Unscored'. Test it by running `SELECT classify_customer_risk(risk_score) AS risk_tier, COUNT(*) FROM customers GROUP BY 1 ORDER BY 2 DESC;`

### 🟡 Practice

**Q3:** Create a function called `classify_claim_severity` that takes a NUMERIC claim amount and returns a TEXT severity label. Use these thresholds: under $2,000 = 'Minor', under $10,000 = 'Moderate', under $30,000 = 'Significant', under $75,000 = 'Major', $75,000+ = 'Catastrophic'. Handle NULL or negative amounts by returning 'Invalid'. Test it across all 180 claims.

**Q4:** Create a set-returning function called `get_claims_by_status` that accepts a status TEXT parameter and returns all matching claims (claim_id, policy_id, claim_amount, claim_date, settlement_amount) ordered by claim_amount descending. Call it with `SELECT * FROM get_claims_by_status('Approved');`

**Q5:** What volatility label should each of your functions use - IMMUTABLE, STABLE, or VOLATILE? Explain why for each one. Then add the correct label to your risk classification function and re-create it using CREATE OR REPLACE.

### 🔴 Challenge

**Q6:** Create a function called `calculate_agent_score` that takes an agent_id INTEGER, reads from the policies and claims tables, and returns a NUMERIC performance score from 0 to 100. Weight premium revenue at 40%, policy volume at 30%, and loss ratio at 30%. Use it to rank all 15 agents by performance.

**Q7:** Write a single query that combines all three of your classification functions - `classify_customer_risk`, `classify_claim_severity`, and `calculate_agent_score` - joining claims to policies, customers, and agents. The result should show the claim_id, customer name, risk tier, claim amount, severity label, agent name, and agent performance score. Order by claim amount descending and limit to 20 rows.

## Key Concepts Covered
- **CREATE FUNCTION:** Saves reusable logic inside the database - define once with parameters, a return type, and a body wrapped in $$ markers
- **Scalar vs set-returning functions:** Scalar returns one value (use in SELECT/WHERE), set-returning returns rows (use in FROM like a table)
- **Volatility labels:** IMMUTABLE for pure calculations, STABLE for table reads, VOLATILE for everything else - never lie to the planner
- **PL/pgSQL structure:** DECLARE for variables, BEGIN/END for logic, $$ dollar-quoting for the function body
- **Business logic encapsulation:** One function, one source of truth - consistent results across every team and dashboard

---

[← Day 26: Information Schema & Metadata](../day-26/) | [Day 28: EXPLAIN & Indexing →](../day-28/)
