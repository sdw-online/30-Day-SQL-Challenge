<p align="center">
  <img src="../assets/banners/day-10-date-functions.svg" width="800" alt="Day 10 - Date Functions & CAST">
</p>

<p align="center">
  <a href="https://youtu.be/Iturx2kgs1A"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-10_of_30-blue" alt="Day 10">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 10 - Date Functions & CAST

[<< Day 9: String & Numeric Functions](../day-09/) | [Day 11: CASE WHEN >>](../day-11/)

---

## What You'll Learn

- AGE() - calculating durations between two dates or from a date to today
- EXTRACT() - pulling out specific parts of a date (year, month, day, quarter)
- DATE_TRUNC() - rounding dates down to a period for grouping by month or quarter
- TO_CHAR() - formatting dates as readable strings for reports
- CURRENT_DATE - getting today's date dynamically
- Date arithmetic - adding and subtracting intervals from dates
- CAST - converting between data types (text to date, numeric to integer)

---

## Quick Setup

```sql
-- Run in pgAdmin (takes a few seconds)
\i setup.sql
```

Or open [`setup.sql`](setup.sql) and run the full script manually.

<details>
<summary>Verify your setup</summary>

```sql
-- Check your tables loaded correctly
SELECT COUNT(*) FROM your_table;
```

</details>

---

## Key Concepts

- **AGE():** Calculates a human-readable interval between two dates - ideal for age and duration reporting

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-10-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-09/">&#9664; Day 9: String & Numeric Functions</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-11/">Day 11: CASE WHEN &#9654;</a>
</p>
