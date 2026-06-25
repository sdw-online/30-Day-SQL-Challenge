<p align="center">
  <a href="https://youtu.be/wlohArgOSd4"><img src="../assets/banners/day-17-union.svg" width="800" alt="Day 17 - UNION & UNION ALL"></a>
</p>

<p align="center">
  <a href="https://youtu.be/wlohArgOSd4"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-17_of_30-blue" alt="Day 17">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 17 - UNION & UNION ALL

[<< Day 16: CROSS JOIN & Self Joins](../day-16/) | [Day 18: Normalisation & Denormalisation >>](../day-18/)

---

## What You'll Learn

- How UNION stacks rows from two queries into one result and removes exact duplicates
- How UNION ALL stacks rows and keeps everything - faster, and why it should be your default
- The strict column rules both queries must follow (same count, compatible types)
- How source tagging labels where each row came from, and how INTERSECT and EXCEPT compare two result sets

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
SELECT 'spotify_songs'      AS table_name, COUNT(*) AS row_count FROM spotify_songs
UNION ALL
SELECT 'youtube_songs',     COUNT(*) FROM youtube_songs
UNION ALL
SELECT 'invoices_sent',     COUNT(*) FROM invoices_sent
UNION ALL
SELECT 'payments_received', COUNT(*) FROM payments_received;
```

Expected: `spotify_songs` 12, `youtube_songs` 10, `invoices_sent` 15, `payments_received` 12.

</details>

---

## Exercises

You work on the data team at a consulting firm. **Rachel**, the Head of Finance, needs a reconciliation report. Every job the firm finishes sends an **invoice**; when the client pays, that **payment** is recorded in a separate table. She needs the full picture: what was invoiced, what was paid, and what is still owed.

You have two tables: `invoices_sent` (15 rows) and `payments_received` (12 rows).

### Task 1: Combine All Transactions With Source Labels

Stack every invoice and every payment into one unified view, each row tagged with its source. Rename the columns so the two tables line up (`invoice_id` -> `ref_id`, `invoice_date` -> `trans_date`), add a `type` label (`'Invoice'` / `'Payment'`), and stack with UNION ALL. Expected: 27 rows.

### Task 2: Find the Unpaid Invoices

Use EXCEPT to find the invoices with no matching payment - compare on `client_name`, `amount`, and `category` only (leave out the IDs and dates, which never match between the two tables). Expected: 5 rows. Then flip EXCEPT for INTERSECT to see the invoices that HAVE been paid. Expected: 9 rows.

### Task 3: Per-Client Reconciliation Summary

The capstone. Use a UNION ALL inside a CTE to gather all 27 transactions, then `SUM(CASE WHEN ...)` in the outer query to produce, per client: total invoiced, total paid, and the balance owed. Expected: 5 rows, totalling $6,600 owed across all clients.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **UNION:** Stacks the rows of two queries into one result and removes exact duplicate rows (like DISTINCT on the combined set). Both queries must return the same number of columns with compatible types.
- **UNION ALL:** Stacks every row and keeps the duplicates. It skips the de-duplication scan, so it is faster - make it your default and only reach for UNION when you genuinely need to drop duplicates.
- **Source tagging:** Adding a fixed text label column (`'Spotify'` / `'YouTube'`, or `'Invoice'` / `'Payment'`) so you can trace every row back to where it came from after stacking. A source tag quietly switches off UNION's de-duplication, since the tag makes otherwise-identical rows different.
- **INTERSECT:** Keeps only the rows that appear in BOTH query results (the overlap).
- **EXCEPT:** Keeps the rows in the first query that are NOT in the second. It is directional - flipping the two queries gives a different answer.

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="../assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-17-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-16/">&#9664; Day 16: CROSS JOIN & Self Joins</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-18/">Day 18: Normalisation & Denormalisation &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="../README.md#curriculum"><b>Day 18 coming soon &raquo;</b></a></p>
<p align="center"><b>Day 18 &nbsp;&middot;&nbsp; Normalisation & Denormalisation</b></p>
<p align="center"><i>The rule that decides whether your schema scales or rots.</i></p>
<!-- /CLIFFHANGER -->
