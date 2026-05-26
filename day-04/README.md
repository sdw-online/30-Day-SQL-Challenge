<p align="center">
  <a href="https://www.youtube.com/watch?v=7IWrvTIrIkg"><img src="../assets/banners/day-04-group-by.svg" width="800" alt="Day 4 - Aggregate Functions & GROUP BY"></a>
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=7IWrvTIrIkg"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-4_of_30-blue" alt="Day 4">
  <img src="https://img.shields.io/badge/Week-1-purple" alt="Week 1">
  <img src="https://img.shields.io/badge/Difficulty-Beginner-orange" alt="Beginner">
</p>

# Day 4 - Aggregate Functions & GROUP BY

[<< Day 3: ORDER BY & LIMIT](../day-03/) | [Day 5: INSERT, UPDATE & DELETE >>](../day-05/)

---

## What You'll Learn

- How to summarise data with the five core aggregate functions: COUNT, SUM, AVG, MIN, MAX
- How to count unique values with COUNT(DISTINCT)
- How to split data into categories with GROUP BY
- How to filter groups after aggregation with HAVING
- How SQL execution order works (FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT)

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

You're a junior data analyst at an auditing firm. It's the year-end review period and your manager, Priya, drops a message on Teams: "Before the client meeting tomorrow, I need a quick breakdown of the transaction data. Can you pull together some headline numbers?"

Using the `client_transactions` table, complete these tasks:

### Warm-Up

**Q1:** Priya wants a single-row summary to kick off the report. Write a query that shows: the total number of transactions, the total revenue across all transactions, the average transaction value (rounded to 2 decimal places), and the smallest and largest single transaction.

<details>
<summary>Hint</summary>

Use COUNT(*), SUM(amount), ROUND(AVG(amount), 2), MIN(amount), and MAX(amount) in a single SELECT with no GROUP BY.

</details>

**Q2:** Priya asks: "How many unique clients and unique sales reps are in the data?" Write a single query that returns both counts.

<details>
<summary>Hint</summary>

Use COUNT(DISTINCT client_name) and COUNT(DISTINCT sales_rep) together in one SELECT.

</details>

### Practice

**Q3:** Priya needs a department-level revenue breakdown. Write a query that shows each department, the number of transactions in it, and the total revenue for that department. Sort by total revenue descending so the highest-earning department appears first.

<details>
<summary>Hint</summary>

GROUP BY department. Use COUNT(*) for transaction count and SUM(amount) for revenue. ORDER BY the SUM descending.

</details>

**Q4:** Priya now wants to see how each sales rep is performing. Write a query that shows each sales rep, their department, the number of transactions they handled, and their total revenue. Filter to show only sales reps whose total revenue exceeds $300,000. Sort by total revenue descending.

<details>
<summary>Hint</summary>

GROUP BY sales_rep, department. Use HAVING SUM(amount) > 300000 to filter after aggregation - you cannot use WHERE for this because the filter applies to a grouped total, not individual rows.

</details>

### Challenge

**Q5:** Priya wants to flag any departments where cash transactions account for more than $75,000 in total. Write a query that shows the department, the total cash revenue (where payment_method = 'Cash'), and the number of cash transactions - but only for departments that exceed the $75,000 threshold.

<details>
<summary>Hint</summary>

Filter to Cash rows first using WHERE payment_method = 'Cash', then GROUP BY department, then use HAVING SUM(amount) > 75000.

</details>

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **COUNT(*):** Counts all rows including NULLs - use this when you want a row total

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-04-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-03/">&#9664; Day 3: ORDER BY & LIMIT</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-05/">Day 5: INSERT, UPDATE & DELETE &#9654;</a>
</p>
