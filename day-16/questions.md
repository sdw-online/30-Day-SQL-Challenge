<p align="center">
  <a href="https://youtu.be/ZYwPGw4ghkI"><img src="../assets/banners/day-16-cross-self-join.svg" width="800" alt="Day 16 - JOINs Part 2: CROSS and Self"></a>
</p>

<p align="center">
  <a href="https://youtu.be/ZYwPGw4ghkI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-16_of_30-blue" alt="Day 16">
  <img src="https://img.shields.io/badge/Questions-5-brightgreen" alt="5 questions">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 16 - Exercise Questions

[<< Back to Day 16](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

A pharmacy system holds medications, known dangerous interactions between them, and what each patient is currently prescribed. Nneka needs a report she can hand straight to the clinical board.

| Table | One row is |
|---|---|
| `medications` | one medication, with its class |
| `interactions` | one known dangerous pair, with severity and effect |
| `patient_prescriptions` | one medication prescribed to one patient, by one doctor |

**Two of these ask you to combine a table with itself. The trap throughout is producing each pair twice, once in each direction.**

---

## Question 1 - Every possible pair of drugs

Produce every unique pair of medications that could be checked against each other, with each drug's class.

**Return:** drug 1, class 1, drug 2, class 2, ordered by both names.

> **Check yourself:** Aspirin with Warfarin is the same pair as Warfarin with Aspirin, and no drug pairs with itself. If your count looks roughly double what you expected, that is why.

---

## Question 2 - Only the dangerous pairs

Narrow that to the pairs that appear in the known interactions table, with the severity and the effect.

**Return:** drug 1, class 1, drug 2, class 2, severity, effect.

> **Check yourself:** This must be a small fraction of the previous answer.

---

## Question 3 - Patients on more than one medication

Find patients prescribed two or more medications at once, showing both drugs and which doctor prescribed each.

**Return:** patient name, medication 1, medication 2, doctor 1, doctor 2.

> **Check yourself:** Same pairing trap as question 1, this time within a patient.

---

## Question 4 - The dangerous combinations actually prescribed

This is the report that matters clinically: patients whose prescribed pair appears in the interactions table.

**Return:** patient name, drug 1, drug 2, severity, effect, and both prescribing doctors.

> **Check yourself:** Two different doctors on one row is exactly the situation this report exists to surface.

---

## Question 5 - Tell the pharmacist what to do

Add a recommended action driven by the severity, so the output is actionable rather than merely alarming.

**Return:** as above, plus both drug classes and a recommended action.

> **Check yourself:** A severity with no matching action rule must not produce a blank instruction.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 15](../day-15/) | [Back to Day 16](README.md) | [Day 17 >>](../day-17/)
