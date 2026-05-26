<p align="center">
  <img src="../assets/banners/day-09-string-numeric.svg" width="800" alt="Day 9 - String & Numeric Functions">
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=h6J7AajBD6w"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-9_of_30-blue" alt="Day 9">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 9 - String & Numeric Functions

[<< Day 8: NULL Handling](../day-08/) | [Day 10: Date Functions & CAST >>](../day-10/)

---

## What You'll Learn

- TRIM, LTRIM, RTRIM - removing unwanted whitespace from messy data
- UPPER and LOWER - standardising text casing across inconsistent records
- INITCAP - converting names and titles to proper case
- SUBSTRING, LEFT, RIGHT - extracting specific parts of a string
- CONCAT and the || operator - combining values from multiple columns
- ROUND, CEIL, FLOOR - controlling decimal precision in calculations

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

- **TRIM / LTRIM / RTRIM:** Remove leading and trailing whitespace - essential first step in any data cleaning pipeline

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-09-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-08/">&#9664; Day 8: NULL Handling</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-10/">Day 10: Date Functions & CAST &#9654;</a>
</p>
