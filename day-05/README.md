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

## Exercises

You're a data engineer at CloudMetrics, a SaaS company that tracks website performance for small businesses. The Head of Customer Support, Tobias, sends you a message on Monday morning: "We've got a backlog situation in the ticket system. Before the team standup, I need a few things sorted."

Using the `support_tickets` and `products` tables, complete these tasks:

### Warm-Up

**Q1:** Three new tickets came in over the weekend. Add them to the `support_tickets` table:
- Suki Patel (`suki@pateldesign.co.uk`) - "Heatmap not tracking mobile clicks", High priority, Open, unassigned, created 2025-04-16, product: Heatmap Tracker
- Jordan Marsh (`jordan@marshconsulting.com`) - "Need invoice for April", Low priority, Open, unassigned, created 2025-04-16, product: Enterprise Dashboard
- Freya Mitchell (`freya@mitchellhr.com`) - "A/B test variant not loading", Medium priority, Open, unassigned, created 2025-04-16, product: A/B Test Runner

<details>
<summary>Hint</summary>

Use INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name) VALUES (...). For the unassigned agent, use NULL. You can insert all three rows in a single multi-row INSERT by separating value sets with commas.

</details>

**Q2:** Tobias wants all unassigned Open tickets assigned to a new agent called Suki Patel. Before running the UPDATE, write the SELECT query you would use to preview which tickets would be affected. Then apply the update. How many tickets does Suki get?

<details>
<summary>Hint</summary>

Preview: SELECT * FROM support_tickets WHERE assigned_to IS NULL AND status = 'Open'. Then UPDATE support_tickets SET assigned_to = 'Suki Patel' WHERE assigned_to IS NULL AND status = 'Open'. Always preview before updating.

</details>

### Practice

**Q3:** Tobias says all Heatmap Tracker tickets that are not already High priority should be escalated. Find any Heatmap Tracker tickets where priority is not High and update them. Before running the UPDATE, write the SELECT query to preview the affected rows.

<details>
<summary>Hint</summary>

Preview: SELECT * FROM support_tickets WHERE product_name = 'Heatmap Tracker' AND priority != 'High'. Then UPDATE support_tickets SET priority = 'High' WHERE product_name = 'Heatmap Tracker' AND priority != 'High'.

</details>

**Q4:** Tobias wants all Cancelled tickets removed from the live system. Write the DELETE query to remove them. Before running it, write the SELECT query to preview how many rows will be affected.

<details>
<summary>Hint</summary>

Preview: SELECT COUNT(*) FROM support_tickets WHERE status = 'Cancelled'. Then DELETE FROM support_tickets WHERE status = 'Cancelled'. There is no undo - always preview first.

</details>

### Challenge

**Q5:** The data pipeline runs nightly. Before each load, the staging tables must be wiped so yesterday's data does not carry over. Write the TRUNCATE statement to clear the `staging_daily_metrics` table. Why is TRUNCATE faster than DELETE for this job?

<details>
<summary>Hint</summary>

TRUNCATE staging_daily_metrics; - TRUNCATE removes all rows without scanning them individually, resets the sequence, and does not write individual row deletions to the transaction log, making it much faster than DELETE for full-table clears.

</details>

**Q6:** The legacy tables are no longer needed - the product team has confirmed they can be removed entirely. Drop both `legacy_ticket_categories` and `legacy_pricing_v1`. What is the difference between DROP and TRUNCATE?

<details>
<summary>Hint</summary>

DROP TABLE legacy_ticket_categories; DROP TABLE legacy_pricing_v1; - DROP removes the entire table structure including columns, constraints, and indexes. TRUNCATE only empties the data. After DROP, the table no longer exists and cannot be queried.

</details>

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

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
