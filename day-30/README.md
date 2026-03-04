# Day 30 - Capstone Project: FinTech Lending Analytics Platform

[Watch the video](COMING_SOON) | [← Day 29: PostgreSQL Pro Tips & Shortcuts](../day-29/) | Challenge complete!

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to combine everything from the past 29 days into a single production-grade analytics platform
- Schema design with star schema thinking, data pipelines with CTEs and MERGE, business logic with UDFs
- Borrower segmentation with window functions, performance tuning with EXPLAIN ANALYSE and indexes
- Self-documenting infrastructure with materialised views and column comments

## Prerequisites
- Complete Days 1-29 - this capstone uses concepts from every single day
- PostgreSQL 15 or later recommended (`SELECT version();` to check)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS borrower_status_history;
DROP TABLE IF EXISTS credit_events;
DROP TABLE IF EXISTS repayments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS risk_scores;
DROP TABLE IF EXISTS applicants;

-- TABLE 1: applicants (dimension table)
CREATE TABLE applicants (
    applicant_id        SERIAL PRIMARY KEY,
    first_name          VARCHAR(60)     NOT NULL,
    last_name           VARCHAR(60)     NOT NULL,
    email               VARCHAR(200)    NOT NULL,
    date_of_birth       DATE            NOT NULL,
    annual_income       NUMERIC(12,2)   NOT NULL CHECK (annual_income >= 0),
    employment_status   VARCHAR(30)     NOT NULL CHECK (employment_status IN ('Employed', 'Self-Employed', 'Unemployed', 'Retired', 'Student')),
    employer_name       VARCHAR(120),
    years_at_employer   INTEGER         CHECK (years_at_employer >= 0),
    region              VARCHAR(60)     NOT NULL,
    application_date    DATE            NOT NULL,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: risk_scores (dimension table)
CREATE TABLE risk_scores (
    risk_score_id       SERIAL PRIMARY KEY,
    applicant_id        INTEGER         NOT NULL REFERENCES applicants(applicant_id),
    credit_score        INTEGER         NOT NULL CHECK (credit_score BETWEEN 300 AND 850),
    debt_to_income      NUMERIC(5,2)    NOT NULL CHECK (debt_to_income BETWEEN 0 AND 100),
    risk_tier           VARCHAR(20)     NOT NULL CHECK (risk_tier IN ('Prime', 'Near-Prime', 'Subprime', 'Deep Subprime')),
    score_date          DATE            NOT NULL,
    scoring_model       VARCHAR(40)     NOT NULL DEFAULT 'Meridian v3.1'
);

-- TABLE 3: loans (fact table)
CREATE TABLE loans (
    loan_id             SERIAL PRIMARY KEY,
    applicant_id        INTEGER         NOT NULL REFERENCES applicants(applicant_id),
    loan_type           VARCHAR(30)     NOT NULL CHECK (loan_type IN ('Personal', 'Auto', 'Business Credit Line')),
    principal_amount    NUMERIC(12,2)   NOT NULL CHECK (principal_amount > 0),
    interest_rate       NUMERIC(5,2)    NOT NULL CHECK (interest_rate BETWEEN 0 AND 40),
    term_months         INTEGER         NOT NULL CHECK (term_months > 0),
    origination_date    DATE            NOT NULL,
    loan_status         VARCHAR(20)     NOT NULL CHECK (loan_status IN ('Active', 'Paid Off', 'Defaulted', 'In Collections', 'Written Off')),
    monthly_payment     NUMERIC(10,2)   NOT NULL CHECK (monthly_payment > 0)
);

-- TABLE 4: repayments (fact table)
CREATE TABLE repayments (
    repayment_id        SERIAL PRIMARY KEY,
    loan_id             INTEGER         NOT NULL REFERENCES loans(loan_id),
    payment_date        DATE            NOT NULL,
    due_date            DATE            NOT NULL,
    amount_due          NUMERIC(10,2)   NOT NULL CHECK (amount_due >= 0),
    amount_paid         NUMERIC(10,2)   NOT NULL CHECK (amount_paid >= 0),
    payment_status      VARCHAR(20)     NOT NULL CHECK (payment_status IN ('On Time', 'Late', 'Missed', 'Partial', 'Overpayment')),
    days_late           INTEGER         NOT NULL DEFAULT 0 CHECK (days_late >= 0),
    late_fee            NUMERIC(8,2)    NOT NULL DEFAULT 0 CHECK (late_fee >= 0)
);

-- TABLE 5: credit_events (fact table)
CREATE TABLE credit_events (
    event_id            SERIAL PRIMARY KEY,
    applicant_id        INTEGER         NOT NULL REFERENCES applicants(applicant_id),
    event_type          VARCHAR(30)     NOT NULL CHECK (event_type IN ('Hard Inquiry', 'Default', 'Account Opening', 'Limit Change', 'Bankruptcy', 'Payment Plan')),
    event_date          DATE            NOT NULL,
    description         TEXT,
    reported_by         VARCHAR(60)     NOT NULL
);

-- TABLE 6: borrower_status_history (SCD Type 2 table)
CREATE TABLE borrower_status_history (
    history_id          SERIAL PRIMARY KEY,
    applicant_id        INTEGER         NOT NULL REFERENCES applicants(applicant_id),
    status              VARCHAR(30)     NOT NULL CHECK (status IN ('New Applicant', 'Approved', 'Active Borrower', 'Delinquent', 'In Collections', 'Recovered', 'Written Off', 'Closed')),
    effective_from      DATE            NOT NULL,
    effective_to        DATE,
    is_current          BOOLEAN         NOT NULL DEFAULT TRUE
);
```

</details>

**Important:** This day requires a Python script to generate all the data (800 applicants, 800 risk scores, 1,200 loans, 8,000 repayments, 1,500 credit events, ~2,000 status history records). See the video or the setup guide for the full `day_30_seed.py` script. The large dataset is essential - this is a capstone project with six tables and 14,300+ rows.

### Verify Your Setup

```sql
SELECT COUNT(*) FROM applicants;
-- Expected: 800 rows

SELECT COUNT(*) FROM risk_scores;
-- Expected: 800 rows

SELECT COUNT(*) FROM loans;
-- Expected: 1,200 rows

SELECT COUNT(*) FROM repayments;
-- Expected: 8,000 rows

SELECT COUNT(*) FROM credit_events;
-- Expected: 1,500 rows

SELECT COUNT(*) FROM borrower_status_history;
-- Expected: ~2,000 rows
```

## Exercises

You are a senior analytics engineer at Meridian Credit, a UK-based digital lending company that provides personal loans, auto loans, and small business credit lines. The company has grown from 200 borrowers to over 5,000 active accounts in two years, and the data infrastructure has not kept pace.

The Head of Credit Risk, Freya Okonkwo, has called an urgent planning session. She has three priorities:

1. **Default prevention** - which borrower segments are at highest risk so the team can intervene earlier?
2. **Portfolio visibility** - a real-time executive dashboard showing total outstanding loans, default rates by loan type, collection efficiency, and repayment trends
3. **Scalable infrastructure** - self-documenting, performant, and free of tribal knowledge

Your task: build the entire lending analytics platform across six phases.

---

### 🟢 Phase 1: Schema Exploration (Day 26 - information_schema)

**Step 1:** Query `information_schema.columns` to list every table and its column count. Then map all foreign key relationships using the three-way metadata JOIN from Day 26. Which table is the central dimension?

**Step 2:** Use the anti-join pattern (LEFT JOIN + WHERE IS NULL) from Day 15 to check for orphaned records - loans without matching applicants, repayments without matching loans. Confirm your data integrity before building analytics on top.

---

### 🟢 Phase 2: Data Pipeline (Days 12-13, 24 - CTEs, Temp Tables, MERGE)

**Step 3:** Build a multi-step CTE pipeline that joins loans to applicants and risk scores, then aggregates repayment statistics (total payments, on-time count, missed count) per loan. This is your loan summary dataset.

**Step 4:** Create a temp table called `staging_loan_updates` that identifies active loans with 3+ missed payments (should be flagged as 'Defaulted') or 1+ missed and 2+ late payments (should be flagged as 'In Collections'). Use FILTER from Day 29 inside the subquery.

---

### 🟡 Phase 3: Business Logic - UDFs (Day 27)

**Step 5:** Apply the staged updates using MERGE from Day 24 - update loan_status only where the new status differs from the current one.

**Step 6:** Create a function called `classify_risk` that takes a credit_score INTEGER and a debt_to_income NUMERIC, and returns a TABLE with risk_tier, risk_label, and max_approved_amount. Use the thresholds: credit score >= 720 and DTI < 30 = Prime ($50,000 limit), >= 620 and DTI < 45 = Near-Prime ($25,000), everything else = Subprime ($10,000).

**Step 7:** Create a function called `loan_health_score` that takes a loan_id, reads its repayment history, and returns a score from 0 to 100. Start at 100, deduct 5 per late payment, deduct 15 per missed payment. Mark it STABLE.

---

### 🟡 Phase 4: Analytics - Window Functions (Days 22-23)

**Step 8:** Use NTILE(4) to divide all borrowers into credit risk quartiles based on their credit score. Which quartile has the highest average debt-to-income ratio?

**Step 9:** Use LAG to compare each repayment's days_late to the previous payment for the same loan. Classify each payment as 'Improving', 'Deteriorating', 'Stable', or 'First Payment'.

**Step 10:** Calculate each region's total loan exposure as a percentage of the entire portfolio using SUM() OVER () with no PARTITION BY. Which region has the highest concentration?

---

### 🔴 Phase 5: Performance Tuning (Days 28-29)

**Step 11:** Run EXPLAIN ANALYSE on a query that filters loans by origination_date and groups by loan_type. Create an appropriate index on `origination_date` and show the before-and-after plans.

**Step 12:** Create a partial index on `repayments` covering only late and missed payments (the rows the collections team queries most). Prove it works with EXPLAIN ANALYSE.

**Step 13:** Add indexes on every foreign key column that does not already have one (loans.applicant_id, repayments.loan_id, credit_events.applicant_id, borrower_status_history.applicant_id).

---

### 🔴 Phase 6: Dashboard Layers & Documentation (Days 25-26)

**Step 14:** Create a materialised view called `mv_portfolio_health` that shows loan_type, loan_status, loan count, total principal, and default rate percentage. Then refresh it with `REFRESH MATERIALIZED VIEW mv_portfolio_health;`

**Step 15:** Add COMMENT ON statements to at least five tables and five non-obvious columns. Then query pg_catalog to confirm they are stored correctly.

---

### 🔴 Bonus Challenge

Create a comprehensive borrower risk dashboard query that combines all six phases: join applicants to risk scores and loans using CTEs, apply your `classify_risk` function, calculate repayment health with your `loan_health_score` function, rank borrowers using window functions, and pull from your materialised view. The final output should show each borrower's name, risk tier, loan details, health score, payment trend, and regional concentration - all in one query.

## Key Concepts Covered
- **Star schema design:** Fact tables (loans, repayments) surrounded by dimension tables (applicants, risk_scores) - the foundation for analytical queries
- **Data pipeline pattern:** Stage changes in temp tables, validate them, then apply with MERGE - the professional approach in regulated industries
- **UDFs for business logic:** One function, one source of truth for risk classification and health scoring across all queries
- **Window functions for segmentation:** NTILE for quartiles, LAG for trend detection, SUM() OVER () for portfolio-level percentages
- **Strategic indexing:** Targeted B-tree and partial indexes on the columns that matter most, proven with EXPLAIN ANALYSE
- **Self-documenting infrastructure:** Materialised views for dashboard performance, COMMENT ON for schema documentation that travels with the database

---

[← Day 29: PostgreSQL Pro Tips & Shortcuts](../day-29/) | Challenge complete!
