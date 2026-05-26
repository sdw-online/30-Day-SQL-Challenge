<p align="center">
  <img src="../assets/banners/day-03-order-by-limit.svg" width="800" alt="Day 3 - ORDER BY & LIMIT">
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=s86nI9dPZqY"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-3_of_30-blue" alt="Day 3">
  <img src="https://img.shields.io/badge/Week-1-purple" alt="Week 1">
  <img src="https://img.shields.io/badge/Difficulty-Beginner-orange" alt="Beginner">
</p>

# Day 3 - ORDER BY & LIMIT

[<< Day 2: SELECT & WHERE](../day-02/) | [Day 4: Aggregate Functions & GROUP BY >>](../day-04/)

---

## What You'll Learn

- How to sort results with ORDER BY (ascending and descending)
- How to limit rows returned with LIMIT and paginate with OFFSET
- How to find unique values with DISTINCT
- How to search for text patterns with LIKE, ILIKE, and wildcards
- How to filter against value lists with IN and ranges with BETWEEN

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

- **ORDER BY:** Sorts results - ASC (low to high, A to Z, oldest first) is the default; DESC reverses it

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-03-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-02/">&#9664; Day 2: SELECT & WHERE</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-04/">Day 4: Aggregate Functions & GROUP BY &#9654;</a>
</p>
