# Day 18 - Normalisation and Denormalisation

[Watch the video](https://youtu.be/dhdWwX8DAEg) | [← Day 17: UNION and UNION ALL](../day-17/) | [Day 19: Recursive CTEs →](../day-19/)

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
