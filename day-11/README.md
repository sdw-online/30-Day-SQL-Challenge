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
- Simple CASE - matching a single column against fixed values to produce labels
- Searched CASE WHEN - evaluating flexible conditions with full boolean expressions
- CASE WHEN in SELECT - adding classification columns to any query
- CASE WHEN in aggregates - counting or summing only rows that match a condition
- Nested CASE - building multi-level decision logic
- How ELSE and NULL interact when no condition is matched

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-10
- Comfortable with SELECT, WHERE, GROUP BY, NULL handling, string/numeric functions, date functions, and CAST

## Dataset

Today uses two tables:

**Teaching table:** Meal plan data - 45 rows with fitness goals, calorie targets, and dietary preferences.

**Exercise table:** Insurance claims data - 387 rows for a claims triage classification exercise.

Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand setup SQL (CREATE TABLE only - run setup.sql for full data)</summary>

```sql
DROP TABLE IF EXISTS meal_plans;

CREATE TABLE meal_plans (
    plan_id         SERIAL PRIMARY KEY,
    person_name     VARCHAR(50),
    fitness_goal    VARCHAR(20),
    age             INTEGER,
    weight_kg       NUMERIC(4,1),
    daily_calories  INTEGER,
    preferred_diet  VARCHAR(20),
    activity_level  VARCHAR(20)
);
-- 45 rows inserted - see setup.sql for full INSERT
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM meal_plans;
-- Expected: 45 rows

SELECT COUNT(*) FROM insurance_claims;
-- Expected: 387 rows
```

## Exercises

You are a data analyst at an insurance company. The operations manager, **Ingrid**, needs a triage report to help the claims team prioritise their workload.

Using the `insurance_claims` table, complete the tasks below.

### Task 1: Classify by Priority

Add a priority classification to each claim. Use CASE WHEN to label each claim as:
- 'High' if claim_amount >= 10000
- 'Medium' if claim_amount >= 2500
- 'Low' for everything else

Show claim_id, claimant_name, incident_type, claim_amount, and the priority label.

### Task 2: Label Incident Types

The incident_type column contains short codes. Use a simple CASE to produce a readable label:
- 'auto' -> 'Motor Vehicle'
- 'home' -> 'Property'
- 'health' -> 'Medical'
- 'travel' -> 'Travel'
- 'liability' -> 'Liability'

Show claim_id, claimant_name, the original incident_type, and the readable label.

### Task 3: Flag SLA Breaches

The target response time is 48 hours. Use CASE WHEN to flag each claim:
- 'Breached' if response_hours > 48
- 'Within SLA' if response_hours <= 48
- 'Not recorded' if response_hours IS NULL

Show claim_id, claimant_name, response_hours, and the SLA status.

### Task 4: Count by Priority

Using CASE WHEN inside COUNT, produce a single summary row showing how many claims fall into each priority band: High, Medium, and Low.

### Task 5: Full Triage Report

Combine Tasks 1, 2, and 3 into a single query. Show claim_id, claimant_name, the readable incident type, claim_amount, priority, and SLA status. Sort by priority (High first, then Medium, then Low), and within each group by claim_amount descending.

## Key Concepts Covered
- **Simple CASE:** Matches a single column against a list of values - cleaner than multiple OR conditions
- **Searched CASE WHEN:** Evaluates any boolean condition - handles ranges, NULL checks, and combined logic
- **CASE in SELECT:** Adds a derived classification column without changing the underlying data
- **CASE in aggregates:** COUNT(CASE WHEN condition THEN 1 END) counts only matching rows - pivot-style summaries
- **ELSE clause:** Always include ELSE when there could be unmatched rows - omitting it returns NULL silently
- **Nested CASE:** Use sparingly - one level deep is usually the limit before a lookup table is cleaner

---

[← Day 10: Date Functions & CAST](../day-10/) | [Day 12: Subqueries & Temp Tables →](../day-12/)
