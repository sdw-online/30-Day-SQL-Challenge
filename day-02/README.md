<p align="center">
  <img src="../assets/banners/day-02-select-where.svg" width="800" alt="Day 2 - SELECT & WHERE">
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=-0uVBtXCZ_s"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-2_of_30-blue" alt="Day 2">
  <img src="https://img.shields.io/badge/Week-1-purple" alt="Week 1">
  <img src="https://img.shields.io/badge/Difficulty-Beginner-orange" alt="Beginner">
</p>

# Day 2 - SELECT & WHERE

[<< Day 1: Introduction to SQL & Databases](../day-01/) | [Day 3: ORDER BY & LIMIT >>](../day-03/)

---

## What You'll Learn

- How to pull data from a table using SELECT
- How to filter rows based on conditions using WHERE
- How to use comparison operators (=, <>, >, <, >=, <=)
- How to combine conditions with AND, OR, NOT, and parentheses
- How to handle NULL values with IS NULL

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

- **SELECT:** Pulls data from a table - use `SELECT *` for exploring, specific columns for production queries

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-02-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-01/">&#9664; Day 1: Introduction to SQL & Databases</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-03/">Day 3: ORDER BY & LIMIT &#9654;</a>
</p>
