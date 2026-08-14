<p align="center">
  <a href="https://youtu.be/Iturx2kgs1A"><img src="../assets/banners/day-10-date-functions.svg" width="800" alt="Day 10 - Date Functions and CAST"></a>
</p>

<p align="center">
  <a href="https://youtu.be/Iturx2kgs1A"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-10_of_30-blue" alt="Day 10">
  <img src="https://img.shields.io/badge/Questions-6-brightgreen" alt="6 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 10 - Exercise Questions

[<< Back to Day 10](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

You are a data analyst at a health organisation. The operations lead needs a board report on referral-to-appointment wait times before the quarterly review. Some patients have been seen; some are still waiting.

| Table | One row is |
|---|---|
| `patient_referrals` | one referral, with patient, department, urgency, referral date and appointment date if one exists |

**A missing appointment date does not mean nothing happened - it means the patient is still waiting. Several questions below depend on treating it that way rather than dropping the row.**

---

## Question 1 - How long ago was each referral

Show every referral with a readable elapsed time since it was made - years, months and days rather than a raw number.

**Return:** patient name, department, referral date, time since referral.

> **Check yourself:** This should return every row in the table.

---

## Question 2 - Patients waiting 90 days or more

The waiting list review needs everyone whose wait has reached 90 days. A patient who has been seen waited until their appointment; a patient still waiting has waited until today.

**Return:** patient name, department, urgency, referral date, appointment date, days waited.

> **Check yourself:** If your query silently drops the patients with no appointment, you have excluded the people the report exists for.

---

## Question 3 - Referrals per month

Show how many referrals came in each month, labelled readably, oldest month first.

**Return:** month, referral count.

> **Check yourself:** Group by the actual month value, not by the formatted label, or your ordering will go alphabetical.

---

## Question 4 - Referrals per quarter

The same count, but by year and quarter, for the board pack.

**Return:** year, quarter, referral count.

> **Check yourself:** Four quarters per year, in order.

---

## Question 5 - A report a human can read

Format the dates as day, short month and year. Where no appointment exists, say so in words.

**Return:** patient name, department, formatted referral date, formatted appointment date or a message, urgency.

> **Check yourself:** No raw timestamps and no blank cells in the output.

---

## Question 6 - The full triage view

Bring it together: how long each patient has waited, and whether they have been seen or are still waiting, longest wait first.

**Return:** patient name, department, urgency, days waited, status.

> **Check yourself:** The top of this list is the report's whole purpose. If the longest waits are not at the top, check your ordering.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 9](../day-09/) | [Back to Day 10](README.md) | [Day 11 >>](../day-11/)
