<p align="center">
  <a href="https://www.youtube.com/watch?v=h6J7AajBD6w"><img src="../assets/banners/day-09-string-numeric.svg" width="800" alt="Day 9 - String and Numeric Functions"></a>
</p>

<p align="center">
  <a href="https://www.youtube.com/watch?v=h6J7AajBD6w"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-9_of_30-blue" alt="Day 9">
  <img src="https://img.shields.io/badge/Questions-4-brightgreen" alt="4 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 9 - Exercise Questions

[<< Back to Day 9](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

You are supporting a city council infrastructure team. Road repair records imported from four district offices are inconsistent - stray spaces, mixed capitalisation, and reference codes with meaning buried inside them - and cannot be used for reporting until they are cleaned.

| Table | One row is |
|---|---|
| `raw_road_repairs` | one repair job, with its reference, road, district, type and costs |

**The data is not wrong, it is untidy. Your job is to make it comparable without changing what is stored.**

---

## Question 1 - Find the invisible mess

Before cleaning anything, prove which rows actually have a spacing problem. Show the road name and district with their lengths before and after the stray spaces come off, and return only the rows where those differ.

**Return:** repair id, road name, its raw and trimmed length, district, its raw and trimmed length.

> **Check yourself:** If a row appears here, the two lengths in it must not match. That is the entire filter.

---

## Question 2 - Make the text presentable

Produce a clean version for a public-facing report: road names in title case, districts in capitals, repair type tidied.

**Return:** repair ref, cleaned road name, cleaned district, cleaned repair type.

> **Check yourself:** Trim before you change case, or you will capitalise a space.

---

## Question 3 - Where the money went over

Finance wants the difference between what each job was estimated at and what it actually cost, in pounds and as a percentage, both to two decimal places.

**Return:** repair ref, road name, cost variance, variance percentage.

> **Check yourself:** A negative variance means it came in under. Do not take an absolute value - the sign is the information.

---

## Question 4 - The city code hidden in the reference

Each repair reference carries a three-character city code inside it, starting at the fourth character. Pull it into its own column so jobs can be grouped by city.

**Return:** repair ref, city code, road name.

> **Check yourself:** Count the characters carefully. Off by one here is silent and wrong.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 8](../day-08/) | [Back to Day 9](README.md) | [Day 10 >>](../day-10/)
