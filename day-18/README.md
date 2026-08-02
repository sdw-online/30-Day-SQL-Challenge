<p align="center">
  <a href="https://youtu.be/dhdWwX8DAEg"><img src="../assets/banners/day-18-normalisation.svg" width="800" alt="Day 18 - Normalisation and Denormalisation"></a>
</p>

<p align="center">
  <a href="https://youtu.be/dhdWwX8DAEg"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-18_of_30-blue" alt="Day 18">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 18 - Normalisation and Denormalisation

[<< Day 17: UNION and UNION ALL](../day-17/) | [Day 19: Recursive CTEs >>](../day-19/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- Why Normalisation Exists - The Problem With Repeated Data
- First Normal Form (1NF) - One Value Per Cell
- Second Normal Form (2NF) - The Whole Key
- Third Normal Form (3NF)
- The Full Normalised Structure
- Denormalisation - When and Why to Break the Rules
- Trade-offs - Fast Writes or Fast Reads
- Homework
- What You Learned Today

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-17

## Dataset

Today uses one table. Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

- **song_plays**: 17 rows

### Setup

Run [setup.sql](setup.sql) to create and populate the teaching table.

### Verification

After running the setup, verify your table:

```sql
SELECT COUNT(*) FROM song_plays; -- expected: 17 rows
```

## Exercises

See video for the full exercise walkthrough.

### Exercise Setup

Run [exercise.sql](exercise.sql) to create the exercise table.

- **census_raw**


## Key Concepts Covered

- Why Normalisation Exists - The Problem With Repeated Data
- First Normal Form (1NF) - One Value Per Cell
- Second Normal Form (2NF) - The Whole Key
- Third Normal Form (3NF)
- The Full Normalised Structure
- Denormalisation - When and Why to Break the Rules
- Trade-offs - Fast Writes or Fast Reads
- Exercise - National Census Data Cleanup
- Homework

---

[Watch the video](https://youtu.be/dhdWwX8DAEg) | [← Day 17: UNION and UNION ALL](../day-17/) | [Day 19: Recursive CTEs →](../day-19/)

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="../assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-18-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-17/">&#9664; Day 17: UNION and UNION ALL</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-19/">Day 19: Recursive CTEs &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="https://www.youtube.com/watch?v=DI1swwiKxUc"><img src="https://img.youtube.com/vi/DI1swwiKxUc/maxresdefault.jpg" width="480" alt="Day 19 - Recursive CTEs"/></a></p>
<p align="center"><b>Day 19 &nbsp;&middot;&nbsp; Recursive CTEs</b></p>
<p align="center"><i>The query that calls itself until the answer runs out.</i></p>
<!-- /CLIFFHANGER -->
