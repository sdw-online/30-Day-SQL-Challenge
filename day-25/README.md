# Day 25 - Views & Materialised Views

[Watch the video](COMING_SOON) | [← Day 24: SCD Types & MERGE](../day-24/) | [Day 26: Information Schema & Metadata →](../day-26/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to save queries permanently as views so your entire team can reuse them without writing JOINs
- The difference between regular views (always fresh) and materialised views (pre-computed, instant reads)
- How to refresh materialised views - including CONCURRENTLY to avoid blocking readers
- When to use CTEs, views, materialised views, and tables

## Prerequisites
- Complete Days 1-24
- Complete Day 20 (star schema / dimensional modelling) - materialised views often sit on top of star schemas
- PostgreSQL version **15 or later** recommended (run `SELECT version();` to check)

## Dataset

You are an analytics engineer at **Meridian Health**, a UK-based healthtech company that manages private clinic networks. The data team has a star schema in the warehouse and stakeholders across clinical operations, finance, and marketing need consistent, pre-built reporting layers.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS treatment_categories;

-- TABLE 1: treatment_categories
CREATE TABLE treatment_categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(60)     NOT NULL,
    is_specialist   BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 2: clinics
CREATE TABLE clinics (
    clinic_id       SERIAL PRIMARY KEY,
    clinic_name     VARCHAR(100)    NOT NULL,
    city            VARCHAR(60)     NOT NULL,
    region          VARCHAR(60)     NOT NULL,
    opened_date     DATE            NOT NULL
);

-- TABLE 3: providers
CREATE TABLE providers (
    provider_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    role            VARCHAR(60)     NOT NULL,
    specialisation  VARCHAR(80),
    clinic_id       INTEGER         NOT NULL REFERENCES clinics(clinic_id),
    hire_date       DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 4: patients
CREATE TABLE patients (
    patient_id          SERIAL PRIMARY KEY,
    first_name          VARCHAR(60)     NOT NULL,
    last_name           VARCHAR(60)     NOT NULL,
    date_of_birth       DATE            NOT NULL,
    registration_date   DATE            NOT NULL,
    plan_type           VARCHAR(30)     NOT NULL,
    primary_clinic_id   INTEGER         NOT NULL REFERENCES clinics(clinic_id),
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 5: appointments
CREATE TABLE appointments (
    appointment_id      SERIAL PRIMARY KEY,
    patient_id          INTEGER         NOT NULL REFERENCES patients(patient_id),
    provider_id         INTEGER         NOT NULL REFERENCES providers(provider_id),
    category_id         INTEGER         NOT NULL REFERENCES treatment_categories(category_id),
    appointment_date    DATE            NOT NULL,
    appointment_time    TIME            NOT NULL,
    duration_minutes    INTEGER         NOT NULL,
    status              VARCHAR(20)     NOT NULL DEFAULT 'completed',
    revenue             NUMERIC(10, 2)  NOT NULL DEFAULT 0.00,
    notes               TEXT
);

-- INSERT: Treatment categories
INSERT INTO treatment_categories (category_name, is_specialist) VALUES
    ('General Consultation',    FALSE),
    ('Physiotherapy',           TRUE),
    ('Dermatology',             TRUE),
    ('Mental Health',           TRUE),
    ('Diagnostics',             FALSE),
    ('Preventive Care',         FALSE);

-- INSERT: UK clinic locations
INSERT INTO clinics (clinic_name, city, region, opened_date) VALUES
    ('Meridian City',           'London',       'South East',   '2019-03-15'),
    ('Meridian Riverside',      'Manchester',   'North West',   '2020-06-01'),
    ('Meridian Harbourside',    'Bristol',      'South West',   '2021-01-20'),
    ('Meridian Park',           'Edinburgh',    'Scotland',     '2021-09-10'),
    ('Meridian Central',        'Birmingham',   'West Midlands','2022-02-28'),
    ('Meridian Quay',           'Cardiff',      'Wales',        '2022-08-15'),
    ('Meridian North',          'Leeds',        'Yorkshire',    '2023-04-01'),
    ('Meridian East',           'Cambridge',    'East',         '2024-01-10');

-- INSERT: Healthcare providers across clinics
INSERT INTO providers (first_name, last_name, role, specialisation, clinic_id, hire_date, is_active) VALUES
    ('Amara',   'Okafor',       'Consultant',       'Dermatology',          1, '2019-04-01', TRUE),
    ('Ravi',    'Sharma',       'Consultant',       'General Practice',     1, '2019-04-01', TRUE),
    ('Isla',    'Campbell',     'Physiotherapist',  'Musculoskeletal',      1, '2020-01-15', TRUE),
    ('Finn',    'Gallagher',    'Consultant',       'Mental Health',        2, '2020-07-01', TRUE),
    ('Priya',   'Nair',         'Nurse Practitioner', NULL,                 2, '2020-07-15', TRUE),
    ('Kwame',   'Asante',       'Consultant',       'General Practice',     2, '2021-03-01', TRUE),
    ('Sienna',  'Brooks',       'Physiotherapist',  'Sports Rehabilitation',3, '2021-02-01', TRUE),
    ('Mateo',   'Rivera',       'Consultant',       'Diagnostics',          3, '2021-03-15', TRUE),
    ('Freya',   'Nilsson',      'Consultant',       'Mental Health',        4, '2021-10-01', TRUE),
    ('Idris',   'Mensah',       'Nurse Practitioner', NULL,                 4, '2022-01-10', TRUE),
    ('Leila',   'Osman',        'Consultant',       'Dermatology',          5, '2022-03-15', TRUE),
    ('Callum',  'Reid',         'Consultant',       'General Practice',     5, '2022-04-01', TRUE),
    ('Nia',     'Williams',     'Physiotherapist',  'Paediatric',           6, '2022-09-01', TRUE),
    ('Euan',    'MacLeod',      'Consultant',       'Diagnostics',          6, '2023-01-15', TRUE),
    ('Safiya',  'Abdi',         'Consultant',       'Preventive Care',      7, '2023-05-01', TRUE),
    ('Wei',     'Chen',         'Nurse Practitioner', NULL,                 7, '2023-06-01', TRUE),
    ('Arjun',   'Kapoor',       'Consultant',       'Mental Health',        7, '2024-01-15', TRUE),
    ('Quinn',   'Taylor',       'Consultant',       'General Practice',     8, '2024-02-01', TRUE),
    ('Mei',     'Zhang',        'Physiotherapist',  'Musculoskeletal',      8, '2024-03-01', TRUE),
    ('Jamal',   'Hassan',       'Consultant',       'Diagnostics',          8, '2024-04-01', FALSE);
```

</details>

### Populate Patients and Appointments with Python

The `patients` (150 rows) and `appointments` (800 rows) tables are generated with a Python script that uses `psycopg2` and `faker`.

1. Install dependencies: `pip install psycopg2-binary faker`
2. Download and run the data generation script from the [setup file in the course repository](https://github.com/sdw-online/claude-ai-agents/blob/main/media-team/projects/courses/30-day-sql-challenge/day-25/25-setup.md)
3. Update the `DB_USER` and `DB_PASSWORD` values in the script to match your PostgreSQL setup

### Verify Your Setup

```sql
SELECT COUNT(*) FROM treatment_categories;
-- Expected: 6 rows

SELECT COUNT(*) FROM clinics;
-- Expected: 8 rows

SELECT COUNT(*) FROM providers;
-- Expected: 20 rows

SELECT COUNT(*) FROM patients;
-- Expected: 150 rows

SELECT COUNT(*) FROM appointments;
-- Expected: 800 rows
```

## Exercises

You are an analytics engineer at Meridian Health. Priya, the VP of Finance, has asked you to build a financial reporting layer before the end of the day. The quarterly board meeting is tomorrow morning at 9am, and if the numbers are not ready, she is presenting from a spreadsheet she manually updated three weeks ago.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Create a view called `vw_active_providers` that shows only active providers with their full name, role, specialisation, and clinic name. Query it to list all active providers at the London clinic (Meridian City).

**Q2:** Query the `appointments` table to count how many completed appointments there are in total. Then create a view called `vw_completed_appointments` that shows only completed appointments with patient name, provider name, clinic name, and revenue. Query the view to get total revenue per clinic.

### 🟡 Practice

**Q3:** Create a materialised view called `mv_clinic_monthly_financials` that pre-computes monthly revenue, appointment counts, and cancellation rates per clinic. Add a unique index on (clinic_id, report_month) so it can be refreshed concurrently. Then query it to show the monthly breakdown.

**Q4:** Refresh the materialised view using CONCURRENTLY, so that Priya's team can keep querying the dashboard without being blocked. Verify the refresh completed successfully by querying the view again.

**Q5:** Create an updatable view called `vw_provider_directory` on the `providers` table (single table, no JOINs). Then use it to mark a provider as inactive (is_active = FALSE). Verify the change propagated to the underlying `providers` table.

### 🔴 Challenge

**Q6:** Build a two-layer reporting stack: a materialised view (`mv_provider_utilisation`) that pre-computes provider-level metrics (total appointments, total revenue, completion rate), and a regular view (`vw_provider_rankings`) on top of it that adds RANK by revenue - both company-wide and within each region. Explain why the rankings layer should be a regular view rather than another materialised view.

**Q7:** Priya asks: "If I use CREATE OR REPLACE VIEW to add a new column to `vw_completed_appointments`, will the finance team lose their permissions on the view?" Write the CREATE OR REPLACE statement that adds `appointment_date` as a new column, and explain the difference between CREATE OR REPLACE and DROP + CREATE in terms of permission handling.

## Key Concepts Covered
- **Views save queries by name** - CREATE VIEW stores the query definition so the whole team shares one source of truth; every read returns fresh results
- **Materialised views trade freshness for speed** - they store results on disk for instant reads, but need manual refreshing
- **CONCURRENTLY avoids blocking** - with a unique index, you can refresh a materialised view without locking out readers
- **Updatable vs read-only views** - single-table views with no aggregation support INSERT/UPDATE/DELETE; multi-table or aggregated views are read-only
- **CREATE OR REPLACE** - updates a view definition in place whilst preserving permissions; DROP + CREATE loses them
- **Decision framework** - CTEs for single-query steps, views for fast reusable queries, materialised views for slow expensive queries, tables for source data

---

[← Day 24: SCD Types & MERGE](../day-24/) | [Day 26: Information Schema & Metadata →](../day-26/)
