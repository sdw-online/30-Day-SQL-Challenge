# Day 10 - Date Functions & CAST

[Watch the video](https://youtu.be/Iturx2kgs1A) | [← Day 9: String & Numeric Functions](../day-09/) | [Day 11: CASE WHEN →](../day-11/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- AGE() - calculating durations between two dates or from a date to today
- EXTRACT() - pulling out specific parts of a date (year, month, day, quarter)
- DATE_TRUNC() - rounding dates down to a period for grouping by month or quarter
- TO_CHAR() - formatting dates as readable strings for reports
- CURRENT_DATE - getting today's date dynamically
- Date arithmetic - adding and subtracting intervals from dates
- CAST - converting between data types (text to date, numeric to integer)

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-9
- Comfortable with SELECT, WHERE, GROUP BY, NULL handling, string and numeric functions

## Dataset

Today uses two tables:

**Teaching table:** Hotel booking data - 30 bookings spanning 2024-2026 with guest dates of birth, booking dates, check-in/check-out dates, and loyalty membership dates.

**Exercise table:** Patient referral data - 20 referrals from a health organisation with referral dates, appointment dates, and urgency levels.

Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand setup SQL (CREATE TABLE only - 30 rows, run setup.sql for full data)</summary>

```sql
-- ============================================
-- DAY 10 SETUP: Hotel booking data
-- ============================================

DROP TABLE IF EXISTS hotel_bookings;

CREATE TABLE hotel_bookings (
    booking_id          SERIAL PRIMARY KEY,
    guest_name          VARCHAR(100)    NOT NULL,
    guest_dob           DATE            NOT NULL,
    booking_date        DATE            NOT NULL,
    check_in            DATE            NOT NULL,
    check_out           DATE,
    room_type           VARCHAR(30)     NOT NULL,
    nightly_rate        NUMERIC(8, 2)   NOT NULL,
    loyalty_member_since DATE
);
-- 30 rows inserted - see setup.sql for full INSERT
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM hotel_bookings;
-- Expected: 30 rows

SELECT COUNT(*) FROM patient_referrals;
-- Expected: 20 rows
```

## Exercises

You are a data analyst at a health organisation. The operations lead needs a board report on referral-to-appointment wait times before the quarterly review.

Using the `patient_referrals` table, complete the tasks below.

### Task 1: Calculate AGE Since Referral

For each patient, calculate how long ago they were referred using AGE(). Show the patient name, department, referral date, and the calculated age since referral. Include patients still waiting (no appointment yet).

### Task 2: Patients Waiting 90 or More Days

Find all patients who waited 90 or more days between referral and appointment, or who have been waiting 90+ days with no appointment yet. Use date arithmetic. Show patient name, department, urgency, referral date, appointment date, and the wait in days.

### Task 3: Referrals Per Month

Count the number of referrals per month using DATE_TRUNC. Show the month (formatted with TO_CHAR as 'Mon YYYY'), and the referral count. Sort chronologically.

### Task 4: Group by Quarter

Using EXTRACT, group referrals by year and quarter. Show the year, quarter number, and count of referrals. Sort by year and quarter.

### Task 5: Format Dates for the Report

Produce a clean summary showing patient name, department, referral date formatted as 'DD Mon YYYY', appointment date formatted the same way (or 'Awaiting appointment' for NULLs), and urgency. Use TO_CHAR and COALESCE.

### Task 6: Full Combined Report

Combine the above into a single triage report. For each patient, show name, department, urgency, days waited (or days waiting so far for those still pending), and a status column: 'Seen' if appointment_date IS NOT NULL, or 'Waiting' otherwise. Sort by days waited descending.

## Key Concepts Covered
- **AGE():** Calculates a human-readable interval between two dates - ideal for age and duration reporting
- **EXTRACT():** Pulls a single numeric component from a date - year, month, day, quarter, week
- **DATE_TRUNC():** Truncates a date to a time boundary - essential for grouping by month or quarter
- **TO_CHAR():** Formats a date or number as a string - used for readable report output
- **CURRENT_DATE:** Returns today's date dynamically - avoids hardcoding dates in queries
- **Date arithmetic:** Add or subtract intervals directly - appointment_date - referral_date gives days as an integer
- **CAST:** Converts between data types - text to date, numeric to integer, date to text

---

[← Day 9: String & Numeric Functions](../day-09/) | [Day 11: CASE WHEN →](../day-11/)
