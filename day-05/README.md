<p align="center">
  <img src="../assets/banners/day-05-insert-update-delete.svg" width="800" alt="Day 5 - INSERT, UPDATE & DELETE">
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=NJ4ujmOZt60"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-5_of_30-blue" alt="Day 5">
  <img src="https://img.shields.io/badge/Week-1-purple" alt="Week 1">
  <img src="https://img.shields.io/badge/Difficulty-Beginner-orange" alt="Beginner">
</p>

# Day 5 - INSERT, UPDATE & DELETE

[<< Day 4: Aggregate Functions & GROUP BY](../day-04/) | [Day 6: Primary & Foreign Keys >>](../day-06/)

---

## What You'll Learn

- How to add new rows to a table with INSERT (single-row and multi-row)
- How to modify existing rows with UPDATE (including calculated values and WHERE targeting)
- How to remove rows permanently with DELETE
- The difference between DELETE, TRUNCATE, and DROP
- The golden rule: always SELECT before UPDATE or DELETE

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

- **INSERT:** Adds new rows to a table - always list column names explicitly so your queries survive table structure changes

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-05-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-04/">&#9664; Day 4: Aggregate Functions & GROUP BY</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-06/">Day 6: Primary & Foreign Keys &#9654;</a>
</p>
