<p align="center">
  <a href="https://youtu.be/DI1swwiKxUc"><img src="../assets/banners/day-19-recursive-ctes.svg" width="800" alt="Day 19 - Recursive CTEs"></a>
</p>

<p align="center">
  <a href="https://youtu.be/DI1swwiKxUc"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-19_of_30-blue" alt="Day 19">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 19 - Recursive CTEs

[<< Day 18: Normalisation & Denormalisation](../day-18/) | [Day 20: Data Modelling (Star Schema) >>](../day-20/)

---

## What You'll Learn

- How recursive CTEs walk through tree-shaped data one level at a time
- The two-part structure: anchor member (starting rows) and recursive member (next level)
- How to traverse org charts, category trees, folder hierarchies, and bill of materials
- How to add safety limits and detect cycles to prevent infinite recursion

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
SELECT 'family_tree' AS table_name, COUNT(*) AS row_count FROM family_tree
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers;
```

Expected: `family_tree` 20, `suppliers` 20.

</details>

---

## Exercises

You work on the data team at a manufacturer. **Ifeoma**, the Supply Chain Director, needs the full supplier network mapped for the quarterly review.

You have one table: `suppliers` (20 rows across 3 tiers). Tier 1 suppliers have no parent (`parent_supplier_id IS NULL`); every other supplier points back to the supplier it supplies.

> "I need the full supplier network mapped for the quarterly review. Preview the data first. Show me all my Tier 1 suppliers. Trace the full chain from Tier 1 down to Tier 3. Tell me how deep each product line's chain goes. And give me a monthly timeline for my review schedule."

### Task 1: Map the Direct Suppliers

Pull out the Tier 1 suppliers on their own - the direct companies the business deals with face to face (the rows with no parent). Return the supplier name, product, country and annual cost, most expensive first. There is no recursion here yet - this is just the anchor on its own. Expected: 4 rows - Millie Motors ($5.2m), Taiwo Steel ($3.1m), Darcy Electronics ($2.4m), Caleb Components ($1.8m).

### Task 2: Trace the Full Chain, Tier by Tier

Write a recursive CTE that returns every supplier across all three tiers, with a `tier` column labelling which level each one sits in. The anchor grabs the Tier 1 suppliers and starts a tier counter at 1; the recursive member finds everyone whose parent points at a supplier already found and adds 1 to the tier one level deeper. Order by tier, then annual cost descending. Expected: 20 rows - 4 at Tier 1, 8 at Tier 2, 8 at Tier 3.

### Task 3: Ifeoma's Final Reports (Capstone)

**3A - How deep does each chain run?** Extend the recursive CTE so every row remembers which Tier 1 supplier it ultimately traces back to (the anchor captures the Tier 1 name, the recursive member carries it down unchanged). Group by that root supplier and return the deepest tier and the total number of suppliers in each chain. Expected: 4 rows - every chain runs 3 tiers deep with 5 suppliers each.

**3B - A monthly timeline for 2025.** No tree this time - use the sequence pattern. Start at `2025-01-01`, add one month each pass, and stop when the loop reaches December. Return the date and a formatted month label. Expected: 12 rows - January through December 2025.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **Recursive CTE:** A common table expression that refers to itself, walking through layered data one level at a time - no matter how many levels deep it goes. Written with `WITH RECURSIVE`.
- **Anchor member:** The starting point (the "start"). It selects the first level of rows - the root of the tree, or the first value in a sequence.
- **Recursive member:** The repeating step (the "repeat"). It calls the CTE by name to reach the next level, joining the source table back to the rows found so far. The anchor and recursive member are joined with `UNION ALL`, and both sides must return the same columns.
- **Termination condition:** The "stop". On clean tree data the recursion ends by itself when no more child rows are found. For sequences you add an explicit condition (e.g. `WHERE report_date < DATE '2025-12-01'`).
- **Depth / level counter:** A column that starts at 1 in the anchor and adds 1 in the recursive member, tracking how many levels from the start each row sits in (a generation, a tier).
- **Cycle safety:** Recursion with no brake runs until the database kills the query. On self-referencing data that could loop, a depth limit is cheap insurance.
- **Sequence generation:** The same start-repeat-stop recipe with no tree - generating a clean run of numbers or dates (like a monthly calendar backbone) to join real data against and expose the gaps.

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-19-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-18/">&#9664; Day 18: Normalisation & Denormalisation</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-20/">Day 20: Data Modelling (Star Schema) &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="../README.md#curriculum"><b>Day 20 coming soon &raquo;</b></a></p>
<p align="center"><b>Day 20 &nbsp;&middot;&nbsp; Data Modelling (Star Schema)</b></p>
<p align="center"><i>How analytics teams actually structure data. Not how textbooks teach it.</i></p>
<!-- /CLIFFHANGER -->
