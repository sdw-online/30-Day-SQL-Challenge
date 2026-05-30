<p align="center">
  <a href="https://www.youtube.com/playlist?list=PL92LwdfbhlXF4qeI8P4bMKepuEPGtKFWx"><img src="assets/banners/cover.svg" width="800" alt="30 Day SQL Challenge"></a>
</p>

<p align="center">
  <a href="https://www.youtube.com/playlist?list=PL92LwdfbhlXF4qeI8P4bMKepuEPGtKFWx"><img src="https://img.shields.io/badge/Playlist-Watch_on_YouTube-red?logo=youtube" alt="Watch Playlist"></a>
  <a href="https://www.youtube.com/@sdw-online"><img src="https://img.shields.io/badge/Channel-Stephen_|_Data-red?logo=youtube" alt="YouTube Channel"></a>
  <img src="https://img.shields.io/badge/PostgreSQL-15+-blue?logo=postgresql" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Lessons-30-brightgreen" alt="30 Lessons">
  <img src="https://img.shields.io/badge/License-Educational-lightgrey" alt="License">
</p>

<p align="center">
  Master SQL from scratch with daily video lessons, hands-on datasets, and real-world exercises.<br>
  Whether you're aiming for your first data role or levelling up your skills - this is the structure to get you there.
</p>

---

## How It Works

```
Fork this repo  -->  Watch the video  -->  Run the SQL  -->  Solve the exercises  -->  Check solutions
```

Each day gives you:
- A **video lesson** that walks you through the concept with real examples
- A **dataset** you set up yourself in pgAdmin - you're building tables, not just reading about them
- **Exercises** that put you in a real role solving a real problem with what you just learnt
- **Solutions** so you can check your work and see how you did

---

## Why This Challenge?

<p align="center">
  <a href="guides/why-this-challenge.md"><img src="assets/banners/why-this-challenge.svg" width="800" alt="Why This Challenge"></a>
</p>

**You don't get good at SQL by watching someone else write it.** You get good by writing it yourself, every day, with data you can actually see and query. That's what this challenge is built around - not theory, not slides, just you and a database.

**30 minutes a day beats a weekend bootcamp.** It's tempting to binge-watch a 12-hour course on a Saturday and call it done. But that's exposure, not skill. When you write SQL every single day for 30 days, it stops being something you "learnt once" and becomes something you just know. The consistency is the point.

**Every exercise puts you in a real job.** You're not answering textbook questions here. You're a data analyst at a regional education authority. You're an analytics engineer at a logistics company. You're debugging a fintech lending pipeline. The scenarios are modelled on real work - logistics, healthcare, finance, infrastructure - so when you do land that role, nothing feels unfamiliar.

---

## "But can't AI write SQL for me?"

<p align="center">
  <a href="guides/sql-in-the-ai-era.md"><img src="assets/banners/sql-in-the-ai-era.svg" width="800" alt="SQL in the AI Era"></a>
</p>

Sure, AI can generate SQL. But here's what it can't do: guarantee the output is correct, performant, or even answering the right question. And when it gets it wrong - which it regularly does - someone needs to spot the mistake, understand why it happened, and fix it. That someone needs SQL fluency.

But honestly, the AI argument misses the bigger picture. SQL isn't just a language you type into a database. It's a way of thinking:

- **It teaches you to decompose problems.** Every complex query starts as a vague question like "which schools are underperforming?" You learn to break that down - what does underperforming mean? Compared to what? Over what time period? SQL forces you to be specific, and that skill transfers to everything you do with data.
- **It teaches you to be precise.** A database won't guess what you meant. If your logic is wrong, your results are wrong - silently. You learn to think about edge cases, NULLs, duplicates, and assumptions. That kind of rigour makes you a better analyst, engineer, and thinker.
- **It gives you direct access to the truth.** When someone says "revenue is up 20%", you can check. When a dashboard looks wrong, you can query the source yourself. SQL removes the middleman between you and the data - and that's powerful in any role.

AI makes SQL faster to write. This challenge makes you someone who knows what to write - and when AI gets it wrong.

---

## Where Should I Start?

Not everyone is starting from scratch - and that's fine. This challenge is designed so you can jump in wherever makes sense for you.

<p align="center">
  <a href="guides/where-to-start.md"><img src="assets/banners/decision-tree-start.svg" width="800" alt="Where Should I Start?"></a>
</p>

**Never written SQL before?** Start at **Day 1**. You'll install PostgreSQL, set up your first database, and write your first query. No prerequisites, no assumptions - just follow along.

**Know the basics but it's been a while?** Jump to **Day 8**. Week 2 covers the stuff most people forget first - NULL handling, string functions, CASE WHEN. It's a great refresher that fills in the gaps.

**Comfortable with queries but never learnt JOINs properly?** Start at **Day 15**. This is where most people in data jobs realise they've been winging it. We cover all the JOIN types with clear visual explanations.

**Already use SQL at work and want the advanced stuff?** Go straight to **Day 22**. Window functions, MERGE statements, query optimisation, and a full capstone project. This is production-grade SQL.

---

## Curriculum

<br>

<a href="day-01/"><img src="assets/banners/week-1-banner.svg" width="800" alt="Week 1: SQL Fundamentals"></a>

<br>

| Day | Topic | What You'll Do | Video |
|:---:|-------|----------------|:-----:|
| 01 | Introduction to SQL & Databases | Set up PostgreSQL, create your first database, and run your first query | [Watch](https://www.youtube.com/watch?v=mFIMPhiO-N0) |
| 02 | SELECT & WHERE | Pull specific data from a table and filter rows using conditions | [Watch](https://www.youtube.com/watch?v=-0uVBtXCZ_s) |
| 03 | ORDER BY & LIMIT | Sort your results and control how many rows come back | [Watch](https://www.youtube.com/watch?v=s86nI9dPZqY) |
| 04 | Aggregate Functions & GROUP BY | Count, sum, and average your data - then group it to find patterns | [Watch](https://www.youtube.com/watch?v=7IWrvTIrIkg) |
| 05 | INSERT, UPDATE & DELETE | Add new rows, change existing ones, and remove what you don't need | [Watch](https://www.youtube.com/watch?v=NJ4ujmOZt60) |
| 06 | Primary & Foreign Keys | Understand how tables relate to each other and why constraints matter | [Watch](https://www.youtube.com/watch?v=1AdFU8Vdq-0) |
| 07 | **Project:** Freight & Logistics Report | Put it all together - build a performance report from real shipping data | [Watch](https://youtu.be/fiBYAziNtGI) |

<br>

<a href="day-08/"><img src="assets/banners/week-2-banner.svg" width="800" alt="Week 2: Data Quality & Transformation"></a>

<br>

| Day | Topic | What You'll Do | Video |
|:---:|-------|----------------|:-----:|
| 08 | NULL Handling | Deal with missing data without breaking your queries | [Watch](https://www.youtube.com/watch?v=0nH464EoZ9w) |
| 09 | String & Numeric Functions | Clean messy text, extract parts of strings, and round numbers properly | [Watch](https://www.youtube.com/watch?v=h6J7AajBD6w) |
| 10 | Date Functions & CAST | Work with dates, calculate time differences, and convert between types | [Watch](https://youtu.be/Iturx2kgs1A) |
| 11 | CASE WHEN | Add conditional logic to your queries - like if/else but inside SQL | [Watch](https://youtu.be/eZ5iTTsKGkI) |
| 12 | Subqueries & Temp Tables | Nest queries inside each other and store intermediate results for reuse | [Watch](https://youtu.be/SOt5jUrzKOU) |
| 13 | CTEs (Part 1) | Write cleaner, more readable queries using Common Table Expressions | [Watch](https://youtu.be/IijQJAfqcJc) |
| 14 | **Project:** Fleet Intelligence Pipeline | Build a multi-step data pipeline using everything from Week 2 | [Watch](https://youtu.be/afIJ4VsQYSo) |

<br>

<a href="day-15/"><img src="assets/banners/week-3-banner.svg" width="800" alt="Week 3: JOINs & Relational Data"></a>

<br>

| Day | Topic | What You'll Do | Video |
|:---:|-------|----------------|:-----:|
| 15 | JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER | Connect tables together and understand what each JOIN type keeps and drops | Coming soon |
| 16 | JOINs Part 2: CROSS & Self Joins | Generate combinations and compare rows within the same table | Coming soon |
| 17 | UNION & UNION ALL | Stack result sets on top of each other and know when to deduplicate | Coming soon |
| 18 | Normalisation & Denormalisation | Understand why databases split data across tables - and when to flatten it | Coming soon |
| 19 | Recursive CTEs | Query hierarchical data like org charts and category trees | Coming soon |
| 20 | Data Modelling (Star Schema) | Design fact and dimension tables the way analytics teams actually do it | Coming soon |
| 21 | **Project:** SaaS Trial-to-Paid Conversion | Analyse a real SaaS funnel - which trials convert and why | Coming soon |

<br>

<a href="day-22/"><img src="assets/banners/week-4-banner.svg" width="800" alt="Week 4: Advanced Analytics & Performance"></a>

<br>

| Day | Topic | What You'll Do | Video |
|:---:|-------|----------------|:-----:|
| 22 | Window Functions Part 1 | Rank rows, number them, and calculate running totals without GROUP BY | Coming soon |
| 23 | Window Functions Part 2 | Compare current rows to previous ones with LAG, LEAD, and QUALIFY | Coming soon |
| 24 | SCD Types & MERGE | Track how data changes over time and upsert rows in one statement | Coming soon |
| 25 | Views & Materialised Views | Save queries as reusable objects and pre-compute expensive results | Coming soon |
| 26 | Information Schema & Metadata | Query the database about itself - table sizes, column types, constraints | Coming soon |
| 27 | CREATE FUNCTION (UDFs) | Build your own reusable SQL functions for logic you use repeatedly | Coming soon |
| 28 | EXPLAIN & Indexing | Read query plans, spot bottlenecks, and make your queries faster | Coming soon |
| 29 | PostgreSQL Pro Tips | Shortcuts, settings, and techniques that save time every day | Coming soon |
| 30 | **Capstone:** FinTech Lending Analytics | Build a full analytics platform - schema, pipelines, segmentation, tuning | Coming soon |

---

## Quick Start

**All you need is a computer and an internet connection.** Seriously, that's it.

**Step 1** - Install PostgreSQL & pgAdmin ([watch the setup guide](https://youtu.be/g8GwhsVPaOg) - takes about 10 minutes)

**Step 2** - Clone this repo
```bash
git clone https://github.com/sdw-online/30-Day-SQL-Challenge.git
```

**Step 3** - Create your database
```sql
CREATE DATABASE sql_challenge;
```

**Step 4** - Open [`day-01/`](day-01/) and you're off

---

## What People Are Saying

Real comments from people doing the challenge right now.

<p align="center">
  <img src="assets/social-proof/biggoucho-day1.jpg" width="420" alt="You could be sitting on that couch watching TV, but instead you're doing this. Thank you.">
</p>

<p align="center">
  <img src="assets/social-proof/ceejay-day2-best-sql.jpg" width="420" alt="This is the best SQL videos clearly explanation">
  &nbsp;&nbsp;
  <img src="assets/social-proof/kgomotso-day4-great-structure.jpg" width="420" alt="Just finished day 4, great structure. I have notes on the side writing queries before you reveal answers">
</p>

<p align="center">
  <img src="assets/social-proof/neels-day5-clearly-break-down.jpg" width="420" alt="Really enjoying how clearly you break down SQL concepts">
  &nbsp;&nbsp;
  <img src="assets/social-proof/travelagent-day10-shining-at-work.jpg" width="420" alt="Working on exercises while shining at the work place as a data analyst">
</p>

<p align="center">
  <img src="assets/social-proof/lizadeka-day30-complete.jpg" width="420" alt="Day 30 completed! Practical and structured challenge. Pushed me to practice consistently.">
</p>

---

## Other Installation Guides

Need to set up other tools? These walk you through each one step by step:

| Tool | Guide |
|------|:-----:|
| PostgreSQL & pgAdmin | [Watch](https://youtu.be/g8GwhsVPaOg) |
| MySQL & Workbench | [Watch](https://youtu.be/u8gGLYOhJuA) |
| SQL Server & SSMS | [Watch](https://youtu.be/Th0hB2h7F14) |
| VS Code | [Watch](https://youtu.be/ny-uBrcGP_U) |
| Git | [Watch](https://youtu.be/26moiTYEw6I) |
| Docker | [Watch](https://youtu.be/6KWp6pNAVLU) |

---

## Join the community

<p align="center">
  <a href="https://data100x.carrd.co/"><strong>Join the free data community →</strong></a><br/>
  <sub>Weekly drops, member projects, no spam, 100% free.</sub>
</p>

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

You just mass-gained a skill most people spend months fumbling through. Stephen drops new challenges, projects, and deep dives regularly - [subscribe on YouTube](https://www.youtube.com/@sdw-online?sub_confirmation=1) so you don't miss the next one.

That's how people go from "learning SQL" to being the SQL person on the team.

---

## About

I'm Stephen - a Senior Data Engineer who's worked across consulting, startups, and enterprise (BDO, TCS, easyJet, C. Hoare & Co., Veolia UK/US).

I've spent years doing this work professionally, and I created this challenge to pass on what I've learnt - the practical stuff, not the theory. The kind of SQL you actually write on the job. Thousands of people have gone through the Excel and SQL challenges already, and watching people message me saying they got their first data role because of these videos is genuinely why I keep doing it.

**YouTube:** [Stephen | Data](https://www.youtube.com/@sdw-online?sub_confirmation=1)

---

## License

For educational purposes. Fork it, clone it, learn from it. If you share it, a link back is appreciated.
