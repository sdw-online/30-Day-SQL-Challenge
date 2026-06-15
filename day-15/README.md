<p align="center">
  <a href="https://youtu.be/wtBxs_iDLo4"><img src="../assets/banners/day-15-joins.svg" width="800" alt="Day 15 - JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER"></a>
</p>

<p align="center">
  <a href="https://youtu.be/wtBxs_iDLo4"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-15_of_30-blue" alt="Day 15">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 15 - JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER

[<< Day 14: Project: Fleet Intelligence Pipeline](../day-14/) | [Day 16: CROSS JOIN & Self Joins >>](../day-16/)

---

## What You'll Learn

- Why real databases split data across multiple tables (normalisation)
- INNER JOIN - returns only rows that match in both tables
- LEFT JOIN - keeps all rows from the left table, fills NULLs where no match
- RIGHT JOIN - the mirror image of LEFT JOIN (and why most people just use LEFT JOIN)
- FULL OUTER JOIN - returns all rows from both tables, NULLs on either side
- The anti-join pattern (LEFT JOIN + WHERE IS NULL) for finding missing relationships
- How to join three or more tables and choose the right JOIN type at each step

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
SELECT 'users'            AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'songs',           COUNT(*) FROM songs
UNION ALL
SELECT 'playlist_tracks', COUNT(*) FROM playlist_tracks
UNION ALL
SELECT 'incidents',       COUNT(*) FROM incidents
UNION ALL
SELECT 'responder_units', COUNT(*) FROM responder_units
UNION ALL
SELECT 'dispatches',      COUNT(*) FROM dispatches
UNION ALL
SELECT 'hospital_capacity', COUNT(*) FROM hospital_capacity;
```

</details>

---

## Exercises

You are a data analyst supporting the dispatch coordinator, **Katja**. She is preparing the weekly board report and needs your help across four emergency response tables: `incidents`, `responder_units`, `dispatches`, and `hospital_capacity`.

### Task 1: Match Incidents to Responders

Write a query that shows which units responded to which incidents. Use INNER JOINs to connect `incidents` to `dispatches` on `incident_id`, and `dispatches` to `responder_units` on `unit_id`. Show the incident ID, type, severity, unit name, unit type, dispatched time, and arrived time, ordered by `reported_at`.

### Task 2: Find Unassigned Incidents

**Part A:** Write a LEFT JOIN query across all three tables (`incidents`, `dispatches`, `responder_units`) that shows all 12 incidents, including the 4 with no dispatch record. Add `dispatch_id` and `unit_name` to your SELECT so the NULLs are visible.

**Part B:** Extend Part A with an anti-join. Add a WHERE clause to isolate only the incidents with no dispatch record. Show the incident ID, type, location, severity, reported time, and status.

### Task 3: Hospital Capacity Check

Write a query that joins `incidents`, `dispatches`, `responder_units`, and `hospital_capacity` together. The link between incidents and hospitals is the district name - use `SPLIT_PART(i.location, ', ', 2)` to extract it from the location string and match it against `h.nearest_district`. Show the incident ID, type, severity, location, unit name, hospital name, available beds, and whether the hospital accepts emergencies.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **INNER JOIN:** Returns only rows where a match exists in both tables - unmatched rows on either side are dropped
- **LEFT JOIN:** Keeps every row from the left table; fills NULLs for columns from the right table where no match exists
- **Anti-join pattern:** LEFT JOIN + WHERE right_table.id IS NULL - isolates rows from the left table with no match on the right
- **Multi-table JOIN:** Chain multiple JOINs in sequence; each JOIN adds a new table's columns to the result set

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="../assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-15-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-14/">&#9664; Day 14: Project: Fleet Intelligence Pipeline</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-16/">Day 16: CROSS JOIN & Self Joins &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="../README.md#curriculum"><b>Day 16 coming soon &raquo;</b></a></p>
<p align="center"><b>Day 16 &nbsp;&middot;&nbsp; JOINs Part 2: CROSS & Self Joins</b></p>
<p align="center"><i>JOINs look easy until they silently drop your data.</i></p>
<!-- /CLIFFHANGER -->
