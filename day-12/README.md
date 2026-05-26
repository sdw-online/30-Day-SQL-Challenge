<p align="center">
  <img src="../assets/banners/day-12-subqueries.svg" width="800" alt="Day 12 - Subqueries & Temp Tables">
</p>

<p align="center">
  <a href="https://youtu.be/SOt5jUrzKOU"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-12_of_30-blue" alt="Day 12">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 12 - Subqueries & Temp Tables

[<< Day 11: CASE WHEN](../day-11/) | [Day 13: CTEs (Part 1) >>](../day-13/)

---

## What You'll Learn

- How to nest one query inside another to answer multi-step questions
- Subquery patterns in WHERE: comparison operators and IN
- Scalar subqueries in SELECT for adding calculated benchmark columns
- Correlated subqueries that reference the outer query row by row
- Derived tables in FROM for multi-step calculations
- Temporary tables for storing intermediate results you need to reuse

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

- **Subqueries in WHERE:** Use a subquery as a dynamic threshold instead of hardcoding values

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-12-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-11/">&#9664; Day 11: CASE WHEN</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-13/">Day 13: CTEs (Part 1) &#9654;</a>
</p>
