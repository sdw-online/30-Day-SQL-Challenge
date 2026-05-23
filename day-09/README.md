# Day 9 - String & Numeric Functions

[Watch the video](https://www.youtube.com/watch?v=h6J7AajBD6w) | [← Day 8: NULL Handling](../day-08/) | [Day 10: Date Functions & CAST →](../day-10/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- TRIM, LTRIM, RTRIM - removing unwanted whitespace from messy data
- UPPER and LOWER - standardising text casing across inconsistent records
- INITCAP - converting names and titles to proper case
- SUBSTRING, LEFT, RIGHT - extracting specific parts of a string
- CONCAT and the || operator - combining values from multiple columns
- ROUND, CEIL, FLOOR - controlling decimal precision in calculations

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-8
- Comfortable with SELECT, WHERE, GROUP BY, NULL handling

## Dataset

Today uses two tables:

**Teaching table:** Raw customer data - 25 records from a UK e-commerce company with intentional data quality issues including mixed casing, leading/trailing spaces, and inconsistent formats.

**Exercise table:** Raw road repair data - 25 records from 4 council districts with the same types of messiness.

Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand setup SQL (CREATE TABLE only - 25 rows, run setup.sql for full data)</summary>

```sql
-- ============================================
-- DAY 9 SETUP: Messy customer data for cleaning
-- ============================================

DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(100)    NOT NULL,
    last_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    phone           VARCHAR(30),
    city            VARCHAR(80)     NOT NULL,
    country         VARCHAR(80)     NOT NULL,
    signup_date     DATE            NOT NULL,
    total_spent     NUMERIC(12, 2)  NOT NULL,
    discount_pct    NUMERIC(5, 2),
    product_code    VARCHAR(30),
    notes           VARCHAR(300)
);
-- 25 rows inserted - see setup.sql for full INSERT
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM raw_customers;
-- Expected: 25 rows

SELECT COUNT(*) FROM raw_road_repairs;
-- Expected: 25 rows
```

## Exercises

You are a data analyst supporting a city council infrastructure team. The data manager has flagged that the road repair records imported from four district offices are inconsistent and cannot be used for reporting until cleaned.

Using the `raw_road_repairs` table, complete the tasks below.

### Task 1: Audit Spacing Issues

Write a query to identify records where `road_name` or `district` have leading or trailing spaces. Compare `LENGTH(road_name)` against `LENGTH(TRIM(road_name))` to surface any rows where extra whitespace is present.

### Task 2: Clean Text with TRIM and INITCAP

Write a query that returns a cleaned version of the data. Use TRIM to remove extra whitespace from `road_name`, `district`, and `repair_type`. Use INITCAP to standardise the casing on `road_name` and UPPER for `district`. Show the repair_ref alongside the cleaned columns.

### Task 3: Calculate Cost Variance with ROUND

For each repair, calculate the cost variance between `actual_cost` and `estimated_cost`. Use ROUND to display the variance to 2 decimal places. Add a second column showing the variance as a percentage of estimated cost, also rounded to 2 decimal places. Show repair_ref, road_name (trimmed), and both variance columns.

### Task 4: Extract Location Codes with SUBSTRING

The `repair_ref` column contains structured codes in the format `RD-XXX-Y-NNNN`. Extract the city code (characters 4-6, e.g. `LON`, `BRI`, `MAN`, `EDI`) using SUBSTRING. Show repair_ref, the extracted city code as `city_code`, and the trimmed road_name.

## Key Concepts Covered
- **TRIM / LTRIM / RTRIM:** Remove leading and trailing whitespace - essential first step in any data cleaning pipeline
- **UPPER / LOWER / INITCAP:** Standardise text casing so comparisons and grouping work correctly
- **SUBSTRING / LEFT / RIGHT:** Extract specific parts of a string by position or character count
- **CONCAT / ||:** Combine multiple columns into a single formatted output
- **ROUND / CEIL / FLOOR:** Control decimal precision - ROUND for display, CEIL/FLOOR for business rules like pricing

---

[← Day 8: NULL Handling](../day-08/) | [Day 10: Date Functions & CAST →](../day-10/)
