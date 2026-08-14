<p align="center">
  <a href="https://youtu.be/dhdWwX8DAEg"><img src="../assets/banners/day-18-normalisation.svg" width="800" alt="Day 18 - Normalisation and Denormalisation"></a>
</p>

<p align="center">
  <a href="https://youtu.be/dhdWwX8DAEg"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-18_of_30-blue" alt="Day 18">
  <img src="https://img.shields.io/badge/Questions-3-brightgreen" alt="3 questions">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 18 - Exercise Questions

[<< Back to Day 18](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

A census extract arrives as one wide table, with one row per person and the household and region details repeated on every row.

| Table | One row is |
|---|---|
| `census_raw` | one person, plus their household address and region details repeated inline |

**This day changes the shape of the data rather than querying it. Read the columns first and ask which facts belong to the person, which to the household, and which to the region.**

---

## Question 1 - Split it into normalised tables

Break the wide table into three: one for regions, one for households, one for people. Address details belong to a household rather than repeating per person, and region type belongs to a region rather than to a person.

**Return:** three table definitions, plus the inserts that populate them from the raw table.

> **Check yourself:** Each address should now be stored once. If an address still appears three times for a three-person household, the split has not gone far enough.

---

## Question 2 - Put it back together

Prove the split was lossless by reconstructing the original view from your three tables.

**Return:** person name, relationship, occupation, address line, district, region, region type.

> **Check yourself:** 20 rows, matching the original. A different number means something was lost or duplicated in the split.

---

## Question 3 - Denormalise deliberately for reporting

Dashboards do not want three tables. Build a reporting layer that presents the joined-up view, while the normalised tables remain the source of truth.

**Return:** a view combining person, household and region detail.

> **Check yourself:** Be ready to say why the reporting layer is allowed to repeat data when the base tables are not. That argument is the whole day.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 17](../day-17/) | [Back to Day 18](README.md) | [Day 19 >>](../day-19/)
