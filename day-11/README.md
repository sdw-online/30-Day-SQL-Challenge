<p align="center">
  <img src="../assets/banners/day-11-case-when.svg" width="800" alt="Day 11 - CASE WHEN">
</p>

<p align="center">
  <a href="https://youtu.be/eZ5iTTsKGkI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-11_of_30-blue" alt="Day 11">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 11 - CASE WHEN

[<< Day 10: Date Functions & CAST](../day-10/) | [Day 12: Subqueries & Temp Tables >>](../day-12/)

---

## What You'll Learn

- Simple CASE - matching a single column against fixed values to produce labels
- Searched CASE WHEN - evaluating flexible conditions with full boolean expressions
- CASE WHEN in SELECT - adding classification columns to any query
- CASE WHEN in aggregates - counting or summing only rows that match a condition
- Nested CASE - building multi-level decision logic
- How ELSE and NULL interact when no condition is matched

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

- **Simple CASE:** Matches a single column against a list of values - cleaner than multiple OR conditions

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-11-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-10/">&#9664; Day 10: Date Functions & CAST</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-12/">Day 12: Subqueries & Temp Tables &#9654;</a>
</p>
