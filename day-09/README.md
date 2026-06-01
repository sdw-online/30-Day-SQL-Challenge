<p align="center">
  <a href="https://www.youtube.com/watch?v=h6J7AajBD6w"><img src="../assets/banners/day-09-string-numeric.svg" width="800" alt="Day 9 - String & Numeric Functions"></a>
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

## Exercises

You are a data analyst supporting a city council infrastructure team. The data manager has flagged that the road repair records imported from four district offices are inconsistent and cannot be used for reporting until cleaned.

Using the `raw_road_repairs` table, complete the tasks below.

### Task 1: Audit Spacing Issues

Write a query to identify records where `road_name` or `district` have leading or trailing spaces. Compare `LENGTH(road_name)` against `LENGTH(TRIM(road_name))` to surface any rows where extra whitespace is present.

### Task 2: Clean Text with TRIM and INITCAP

Write a query that returns a cleaned version of the data. Use TRIM to remove extra whitespace from `road_name`, `district`, and `repair_type`. Use INITCAP to standardise the casing on `road_name` and UPPER for `district`. Show the repair_ref alongside the cleaned columns.

### Task 3: Calculate Cost Variance with ROUND

For each repair, calculate the cost variance between `actual_cost` and `estimated_cost`. Use ROUND to display the variance to 2 decimal places. Add a second column showing the variance as a percentage of estimated cost, also rounded to 2 decimal places. Show repair_ref, road_name (trimmed), and both variance columns.

### Task 4: Extract Location Codes with SUBSTRING

The `repair_ref` column contains structured codes in the format `RD-XXX-Y-NNNN`. Extract the city code (characters 4-6, e.g. `LON`, `BRI`, `MAN`, `EDI`) using SUBSTRING. Show repair_ref, the extracted city code as `city_code`, and the trimmed road_name.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

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

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="https://youtu.be/Iturx2kgs1A"><img src="https://img.youtube.com/vi/Iturx2kgs1A/maxresdefault.jpg" width="480" alt="Day 10 - Date Functions & CAST"/></a></p>
<p align="center"><b>Day 10 &nbsp;&middot;&nbsp; Date Functions & CAST</b></p>
<p align="center"><i>Dates have more traps than any other type. Spot them before they spot you.</i></p>
<!-- /CLIFFHANGER -->
