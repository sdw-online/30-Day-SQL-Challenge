<p align="center">
  <a href="https://youtu.be/DI1swwiKxUc"><img src="../assets/banners/day-19-recursive-ctes.svg" width="800" alt="Day 19 - Recursive CTEs"></a>
</p>

<p align="center">
  <a href="https://youtu.be/DI1swwiKxUc"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-19_of_30-blue" alt="Day 19">
  <img src="https://img.shields.io/badge/Questions-4-brightgreen" alt="4 questions">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 19 - Exercise Questions

[<< Back to Day 19](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

Ifeoma, the Supply Chain Director, needs the full supplier network mapped for the quarterly review. It is a hierarchy: Tier 1 suppliers buy from Tier 2, who buy from Tier 3, and each row points at its parent.

| Table | One row is |
|---|---|
| `suppliers` | one supplier, with its product, country, annual cost and a pointer to its parent supplier |

**A row pointing at another row in the same table is a tree. You cannot walk it with a fixed number of joins unless you already know how deep it goes.**

---

## Question 1 - Find the top of the tree

List the direct suppliers - the ones that answer to nobody - most expensive first. No recursion needed yet.

**Return:** supplier name, product, country, annual cost.

> **Check yourself:** 4 rows. These are the starting points for everything that follows.

---

## Question 2 - Walk the whole chain

Now traverse the full network, labelling every supplier with the tier it sits at.

**Return:** supplier name, product, country, annual cost, tier.

> **Check yourself:** 20 rows: 4 at tier 1, 8 at tier 2, 8 at tier 3. If it never stops, your recursive step is not moving down the tree.

---

## Question 3 - How deep does each chain run

For each Tier 1 supplier, how many suppliers sit beneath it and how deep does its chain go? Every row needs to remember which Tier 1 supplier it ultimately traces back to.

**Return:** root supplier, deepest tier, supplier count.

> **Check yourself:** 4 rows, one per Tier 1 supplier.

---

## Question 4 - A monthly timeline with no table behind it

A different use of the same tool: generate the monthly timeline Ifeoma wants for her review schedule - one row per month for 2025, without a calendar table.

**Return:** 12 dates, January to December 2025.

> **Check yourself:** No source table at all. The first row is written by hand and each pass adds a month, stopping at December.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 18](../day-18/) | [Back to Day 19](README.md) | [Day 20 >>](../day-20/)
