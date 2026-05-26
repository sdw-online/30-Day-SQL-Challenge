<p align="center">
  <a href="https://www.youtube.com/watch?v=0nH464EoZ9w"><img src="../assets/banners/day-08-null-handling.svg" width="800" alt="Day 8 - NULL Handling"></a>
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=0nH464EoZ9w"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-8_of_30-blue" alt="Day 8">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 8 - NULL Handling

[<< Day 7: Project: Freight & Logistics Report](../day-07/) | [Day 9: String & Numeric Functions >>](../day-09/)

---

## What You'll Learn

- What NULL actually means in SQL and why it causes silent bugs
- Three-valued logic - how TRUE, FALSE, and UNKNOWN work
- IS NULL and IS NOT NULL - the only correct way to check for missing values
- COALESCE - replacing NULLs with fallback values in reports and calculations
- NULLIF - preventing division-by-zero errors and cleaning placeholder values
- How NULL behaves in aggregate functions and sorting

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

You are a data analyst at Bean & Leaf, a coffee shop chain. The operations manager, **Kwame**, needs an audit of missing data before the monthly supplier review.

Using the `menu_items` table, complete the tasks below.

### Task 1: Audit Missing Data Counts

Write a single query that counts the number of NULLs in `cost_price`, `supplier_name`, and `category`. Use the `COUNT(*) - COUNT(column)` pattern to produce a summary row showing how many gaps exist in each column.

### Task 2: Menu Pricing with Missing Cost

For every menu item, show the item name, sell price, cost price, and a `display_cost` column that shows the cost price if known, or the text `'Cost not recorded'` if it is NULL. Use COALESCE.

### Task 3: Uncategorised Items

Find all menu items that have no category assigned. Show the item name, sell price, and stock quantity. How many items are uncategorised?

### Task 4: Low-Stock Items with No Supplier

Find all items with fewer than 20 units in stock where the supplier name is also NULL. These are the urgent procurement blind spots. Show the item name, stock quantity, and sell price.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **NULL means unknown:** It is not zero, not an empty string - it is the complete absence of a value

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-08-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-07/">&#9664; Day 7: Project: Freight & Logistics Report</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-09/">Day 9: String & Numeric Functions &#9654;</a>
</p>
