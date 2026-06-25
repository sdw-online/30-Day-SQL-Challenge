<p align="center">
  <a href="https://youtu.be/ZYwPGw4ghkI"><img src="../assets/banners/day-16-cross-self-join.svg" width="800" alt="Day 16 - CROSS JOIN & Self Joins"></a>
</p>

<p align="center">
  <a href="https://youtu.be/ZYwPGw4ghkI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-16_of_30-blue" alt="Day 16">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 16 - CROSS JOIN & Self Joins

[<< Day 15: JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER](../day-15/) | [Day 17: UNION & UNION ALL >>](../day-17/)

---

## What You'll Learn

- How CROSS JOIN generates every possible combination of two tables - and when you'd actually want that
- How self joins let you join a table to itself to query hierarchies, compare rows, and find colleague pairs
- How non-equi joins match values to ranges using BETWEEN instead of equals
- The `<` trick for producing unique pairs without duplicates

---

## Quick Setup

```sql
-- Run in pgAdmin (takes a few seconds)
\i setup.sql
\i exercise.sql
```

Or open [`setup.sql`](setup.sql) and [`exercise.sql`](exercise.sql) and run each script manually.

<details>
<summary>Verify your setup</summary>

```sql
-- Check your tables loaded correctly
SELECT 'airports'             AS table_name, COUNT(*) AS row_count FROM airports
UNION ALL
SELECT 'flights',             COUNT(*) FROM flights
UNION ALL
SELECT 'medications',         COUNT(*) FROM medications
UNION ALL
SELECT 'interactions',        COUNT(*) FROM interactions
UNION ALL
SELECT 'patient_prescriptions', COUNT(*) FROM patient_prescriptions;
```

</details>

---

## Exercises

You are supporting **Nneka**, Head of Pharmacy Compliance at a hospital. She asks: "I need to know which of our patients are currently on two drugs that interact badly. Flag the dangerous combinations and tell me what to do."

You have three tables: `medications`, `interactions`, and `patient_prescriptions`.

### Task 1: Generate All Drug Pairs

**Part A:** Use a CROSS JOIN on `medications` to produce every unique pair of drugs. Use the less-than trick (`m1.med_id < m2.med_id`) to remove self-pairs and duplicates. Show `drug_1`, `class_1`, `drug_2`, `class_2`. Expected: 45 rows.

**Part B:** Extend Part A by adding an INNER JOIN to `interactions` to keep only the 8 known dangerous pairs. Add `severity` and `effect` columns. Order by severity (High first, then Moderate, then Low).

### Task 2: Find Patients on Multiple Medications

Self join `patient_prescriptions` to find every patient prescribed more than one drug. Show `patient_name`, `medication_1`, `medication_2`, `doctor_1`, and `doctor_2` (the prescribing doctors for each drug). Use `pp1.med_id < pp2.med_id` to avoid duplicate pairs. Expected: 30 rows.

### Task 3: Flag Dangerous Combinations

**Part A:** Extend Task 2 by adding an INNER JOIN to `interactions` to keep only patient-drug pairs where a known dangerous interaction exists. Add `severity` and `effect` columns. Order by severity (High first), then `patient_name`. Expected: 6 rows.

**Part B:** Extend Part A by adding a `recommended_action` column using CASE:
- `'High'` -> `'STOP - immediate review'`
- `'Moderate'` -> `'MONITOR - schedule follow-up'`
- `'Low'` -> `'NOTE - document in records'`

Also add `class_1` and `class_2` columns.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **CROSS JOIN:** Produces the Cartesian product - every row from the left table paired with every row from the right table; no ON clause required
- **Less-than trick:** Adding `WHERE m1.id < m2.id` to a CROSS JOIN removes self-pairs and duplicate reverse-order pairs, leaving only unique combinations
- **Self join:** A table joined to itself using two aliases; used for comparing rows within the same table (patient-drug pairs, hierarchy lookups, same-route comparisons)
- **Non-equi join:** A join using BETWEEN instead of equals; matches a value to a range rather than an exact key

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="../assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-16-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-15/">&#9664; Day 15: JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-17/">Day 17: UNION & UNION ALL &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="https://www.youtube.com/watch?v=wlohArgOSd4"><img src="https://img.youtube.com/vi/wlohArgOSd4/maxresdefault.jpg" width="480" alt="Day 17 - UNION & UNION ALL"/></a></p>
<p align="center"><b>Day 17 &nbsp;&middot;&nbsp; UNION & UNION ALL</b></p>
<p align="center"><i>UNION & UNION ALL - the thing most people get wrong.</i></p>
<!-- /CLIFFHANGER -->
