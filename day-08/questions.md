<p align="center">
  <a href="https://www.youtube.com/watch?v=0nH464EoZ9w"><img src="../assets/banners/day-08-null-handling.svg" width="800" alt="Day 8 - NULL Handling"></a>
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=0nH464EoZ9w"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-8_of_30-blue" alt="Day 8">
  <img src="https://img.shields.io/badge/Questions-4-brightgreen" alt="4 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 8 - Exercise Questions

[<< Back to Day 8](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

You are a data analyst at Bean and Leaf, a coffee shop chain. The menu system has been filled in by different people over time, so plenty of fields were simply left empty. Kwame, the operations manager, needs an audit before the monthly supplier review.

| Table | One row is |
|---|---|
| `menu_items` | one item on the menu, with its prices, supplier, category and stock |

**Before you start: an empty field is not a zero, and it is not equal to anything - including another empty field. Almost every question below turns on that.**

---

## Question 1 - Audit what is actually missing

Kwame wants one row telling him how many items are missing a cost price, how many are missing a supplier, and how many have no category.

**Return:** three counts, one per field, on a single row.

> **Check yourself:** COUNT(*) and COUNT(column) do not return the same number. The gap between them is your answer.

---

## Question 2 - A price list that reads properly

Print the menu with its selling price and cost price, but where no cost has been recorded the report must say so in words rather than showing a manager a blank cell.

**Return:** item name, sell price, cost price, and a display column that falls back to a readable message.

> **Check yourself:** Every row in the table must appear. If your row count dropped, you filtered instead of substituting.

---

## Question 3 - Items nobody has categorised

The menu is being reorganised and anything without a category needs assigning.

**Return:** item name, sell price, stock quantity.

> **Check yourself:** If you compared the category to an empty value with =, you will get nothing back. That is the lesson, not a bug.

---

## Question 4 - Low stock and nobody to call

This is the one that gets escalated: items running low that also have no supplier recorded to reorder from. Fewer than 20 in stock, and no supplier.

**Return:** item name, stock quantity, sell price.

> **Check yourself:** Two conditions, and one of them is about absence rather than a value.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 7](../day-07/) | [Back to Day 8](README.md) | [Day 9 >>](../day-09/)
