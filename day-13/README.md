<p align="center">
  <img src="../assets/banners/day-13-ctes.svg" width="800" alt="Day 13 - CTEs (Part 1)">
</p>

<p align="center">
  <a href="https://youtu.be/IijQJAfqcJc"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-13_of_30-blue" alt="Day 13">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 13 - CTEs (Part 1)

[<< Day 12: Subqueries & Temp Tables](../day-12/) | [Day 14: Project: Fleet Intelligence Pipeline >>](../day-14/)

---

## What You'll Learn

- What Common Table Expressions (CTEs) are and how the WITH keyword works
- How to define multiple CTEs in a single query, separated by commas
- How to chain CTEs into multi-step pipelines where each step feeds the next
- When to use a CTE versus a subquery versus a temp table
- Naming conventions that make your CTEs self-documenting

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

- **WITH keyword:** Defines named temporary result sets at the top of a query, referenced like tables below

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-13-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-12/">&#9664; Day 12: Subqueries & Temp Tables</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-14/">Day 14: Project: Fleet Intelligence Pipeline &#9654;</a>
</p>
