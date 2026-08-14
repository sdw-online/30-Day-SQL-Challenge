<p align="center">
  <a href="https://youtu.be/eZ5iTTsKGkI"><img src="../assets/banners/day-11-case-when.svg" width="800" alt="Day 11 - CASE WHEN"></a>
</p>

<p align="center">
  <a href="https://youtu.be/eZ5iTTsKGkI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-11_of_30-blue" alt="Day 11">
  <img src="https://img.shields.io/badge/Questions-5-brightgreen" alt="5 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 11 - Exercise Questions

[<< Back to Day 11](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

You are a data analyst at an insurance company. Ingrid, the operations manager, needs a triage report to help the claims team prioritise their workload.

| Table | One row is |
|---|---|
| `insurance_claims` | one claim, with the claimant, incident type, amount and response time |

**Every question here turns a raw value into a business label. Watch what happens to rows that match none of your conditions.**

---

## Question 1 - Band the claims by priority

Anything from 10,000 upwards is High, from 2,500 up to 10,000 is Medium, everything else is Low.

**Return:** claim id, claimant name, incident type, claim amount, priority.

> **Check yourself:** Every row must come back with a priority. A blank means a value fell through every branch.

---

## Question 2 - Turn codes into labels

The incident types are stored as short codes. Produce the customer-facing labels: auto is Motor Vehicle, home is Property, health is Medical, travel is Travel, liability is Liability.

**Return:** claim id, claimant name, incident type, incident label.

> **Check yourself:** If a code appears that you did not list, what does your query return for it? Decide that deliberately.

---

## Question 3 - Flag the service breaches

Anything answered in over 48 hours has breached the service level, anything within 48 hours has not, and some claims have no response time recorded at all - those must not be reported as either.

**Return:** claim id, claimant name, response hours, SLA status.

> **Check yourself:** Three possible outcomes, not two. The third is the one people forget.

---

## Question 4 - Count the bands on one row

Ingrid wants the three priority counts side by side on a single row, not as three separate rows.

**Return:** high count, medium count, low count.

> **Check yourself:** The three counts must add up to the total number of claims.

---

## Question 5 - The full triage report

Combine it: claim, claimant, the readable incident label, the amount, and its priority band.

**Return:** claim id, claimant name, incident label, claim amount, priority.

> **Check yourself:** This is what a claims handler would actually open. If any column still shows a raw code, it is not finished.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 10](../day-10/) | [Back to Day 11](README.md) | [Day 12 >>](../day-12/)
