<p align="center">
  <a href="../README.md"><img src="../assets/banners/sql-in-the-ai-era.svg" width="800" alt="SQL in the AI Era"></a>
</p>

<p align="center">
  <a href="../README.md"><img src="https://img.shields.io/badge/Back-Main_Page-grey" alt="Back to Main"></a>
  <a href="why-this-challenge.md"><img src="https://img.shields.io/badge/Next-Why_This_Challenge-blue" alt="Why This Challenge"></a>
</p>

# SQL in the AI Era

"Why would I learn SQL when ChatGPT can write it for me?"

Fair question. Here's the honest answer.

---

## AI can write SQL. It can't guarantee it's correct.

Ask an LLM to write a query and you'll get something that looks right. It'll have proper syntax, reasonable column names, and a plausible WHERE clause. It might even run without errors.

But "runs without errors" and "returns the right answer" are two completely different things.

Here's what goes wrong in practice:

- **It guesses column names.** If your table has `order_date` and the AI writes `created_at`, you get an error. If it writes `date` and your table happens to have a `date` column that means something different - you get wrong results silently.
- **It gets JOIN logic wrong.** LEFT vs INNER JOIN changes your row count. The AI doesn't know your data well enough to choose correctly. One wrong JOIN and your revenue number is off by 40%.
- **It ignores NULLs.** Most AI-generated queries don't handle NULLs properly. A simple `AVG(score)` silently drops NULL rows. If that changes your answer from 72 to 68, you'd never know unless you understand what's happening.
- **It can't optimise.** AI writes queries that work. It doesn't write queries that work fast. On a 10-million-row table, the difference between a sequential scan and an indexed lookup is the difference between 45 seconds and 200 milliseconds.

The people who use AI effectively for SQL are the ones who already know SQL. They use it to draft faster, then verify and fix. That's not "AI replacing SQL skills" - that's "SQL skills making AI useful."

---

## But the bigger reason isn't about AI at all

Even if AI could write perfect SQL every time (it can't), learning SQL would still be worth it. Here's why.

---

<p align="center">
  <img src="../assets/banners/why-decompose.svg" width="800" alt="Decompose Problems">
</p>

### SQL teaches you to decompose problems

Every complex query starts as a vague question. "Which schools are underperforming?" sounds simple until you try to write it.

What does "underperforming" mean? Below the national average? Below their own historical average? In which subjects? Over what time period? Compared to schools of similar size?

SQL forces you to answer all of those questions before you write a single line. You learn to break a vague request into precise, solvable pieces:

1. Calculate the national average
2. Calculate each school's average
3. Compare the two
4. Filter to schools below the threshold

That decomposition skill transfers to everything - data analysis, product thinking, debugging, system design. It's not a SQL skill. It's a thinking skill that SQL happens to teach better than almost anything else.

---

<p align="center">
  <img src="../assets/banners/why-precision.svg" width="800" alt="Precision">
</p>

### SQL teaches you to be precise

A database doesn't guess what you meant. If your logic is wrong, your results are wrong - and they're wrong silently. There's no red error message. The query runs, returns numbers, and those numbers are quietly incorrect.

This forces a kind of rigour that most people never develop:

- You learn to think about edge cases before they bite you
- You learn that `WHERE status != 'cancelled'` doesn't catch NULLs
- You learn that joining on the wrong key can multiply your rows without warning
- You learn to verify your assumptions with COUNT(*) before building on them

That precision makes you a better analyst, a better engineer, and a better thinker. It's the difference between someone who says "the data shows X" and someone who says "the data shows X, and here's how I verified it."

---

<p align="center">
  <img src="../assets/banners/why-direct-access.svg" width="800" alt="Direct Access">
</p>

### SQL gives you direct access to the truth

When someone in a meeting says "revenue is up 20%", most people nod. A SQL-literate person opens a query tool and checks.

When a dashboard shows a number that doesn't look right, most people flag it and wait for someone else to investigate. A SQL-literate person queries the source table and finds the answer in 5 minutes.

SQL removes the middleman between you and the data. That's powerful in any role:

- **Data analysts** can answer questions without waiting for engineers
- **Product managers** can validate metrics without filing a ticket
- **Engineers** can debug data issues at the source
- **Business people** can spot problems before they become expensive

In a world drowning in dashboards and reports, being the person who can go straight to the source is a genuine career advantage.

---

## The bottom line

AI makes SQL faster to write. It doesn't make SQL knowledge optional.

The people who thrive with AI tools are the ones who understand what the AI is doing - and can catch it when it's wrong. That requires knowing SQL properly, not just knowing how to prompt for it.

This challenge teaches you that.

---

<p align="center">
  <a href="where-to-start.md"><strong>Find your starting point &rarr;</strong></a>
</p>

<p align="center">
  <a href="../day-01/">Or just start Day 1</a>
</p>
