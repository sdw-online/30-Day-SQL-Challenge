<p align="center">
  <img src="../assets/banners/day-06-keys-constraints.svg" width="800" alt="Day 6 - Primary & Foreign Keys">
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=1AdFU8Vdq-0"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-6_of_30-blue" alt="Day 6">
  <img src="https://img.shields.io/badge/Week-1-purple" alt="Week 1">
  <img src="https://img.shields.io/badge/Difficulty-Beginner-orange" alt="Beginner">
</p>

# Day 6 - Primary & Foreign Keys

[<< Day 5: INSERT, UPDATE & DELETE](../day-05/) | [Day 7: Project: Freight & Logistics Report >>](../day-07/)

---

## What You'll Learn

- How PRIMARY KEY uniquely identifies every row and prevents duplicates
- How FOREIGN KEY links tables together and prevents orphan records
- How NOT NULL, UNIQUE, CHECK, and DEFAULT enforce data quality rules
- Composite keys - primary keys made of multiple columns
- CASCADE, SET NULL, and RESTRICT - controlling what happens when referenced data changes

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

- **PRIMARY KEY**: Uniquely identifies every row - no duplicates, no NULLs, and SERIAL handles auto-incrementing

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-06-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-05/">&#9664; Day 5: INSERT, UPDATE & DELETE</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-07/">Day 7: Project: Freight & Logistics Report &#9654;</a>
</p>
