<p align="center">
  <a href="https://youtu.be/bZjfSWOIsBI"><img src="../assets/banners/day-20-star-schema.svg" width="800" alt="Day 20 - Data Modelling (Star Schema)"></a>
</p>

<p align="center">
  <a href="https://youtu.be/bZjfSWOIsBI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-20_of_30-blue" alt="Day 20">
  <img src="https://img.shields.io/badge/Questions-3-brightgreen" alt="3 questions">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 20 - Exercise Questions

[<< Back to Day 20](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

An energy company models generation data as a star schema: one fact table surrounded by dimensions, plus a bridge table because a site can supply more than one region.

| Table | One row is |
|---|---|
| `generation_fact` | one generation measurement, for one site in one period |
| `sites` | one generation site, with its energy source |
| `regions` | one region |
| `time_periods` | one time period |
| `site_region_supply` | one site supplying one region - the bridge |

**Look at the row counts before you write anything. The big table is the fact and the small ones are dimensions. Which table a question needs is usually decided by which column it asks about.**

---

## Question 1 - Read the shape of the model

Count every table so you can tell which is the fact and which are the dimensions.

**Return:** table name and row count, for all five.

> **Check yourself:** 96 generation rows against 8 sites is the giveaway. If you cannot tell which is the fact table, you cannot plan a query against it.

---

## Question 2 - Through the bridge

How many sites feed each region, most first?

**Return:** region name, site count.

> **Check yourself:** There is no region on the fact table. If you tried to start there, that is the lesson: the bridge is the only route.

---

## Question 3 - Renewable against non-renewable share

Split total generation into renewable and non-renewable, and express each as a percentage of the whole.

**Return:** energy source, total generation, percentage share.

> **Check yourself:** The two percentages must add to 100. Going through the bridge here would double-count any site supplying more than one region, so ask yourself whether this question needs it at all.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 19](../day-19/) | [Back to Day 20](README.md) | [Day 21 >>](../day-21/)
