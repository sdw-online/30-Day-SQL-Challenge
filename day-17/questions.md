<p align="center">
  <a href="https://youtu.be/wlohArgOSd4"><img src="../assets/banners/day-17-union.svg" width="800" alt="Day 17 - UNION and UNION ALL"></a>
</p>

<p align="center">
  <a href="https://youtu.be/wlohArgOSd4"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-17_of_30-blue" alt="Day 17">
  <img src="https://img.shields.io/badge/Questions-4-brightgreen" alt="4 questions">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 17 - Exercise Questions

[<< Back to Day 17](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

Rachel, the Head of Finance, wants a reconciliation report: the money that went out against the money that came in, checked against each other so nothing slips through. Invoices and payments sit in two separate tables with the same shape.

| Table | One row is |
|---|---|
| `invoices_sent` | one invoice, with client, amount, date and category |
| `payments_received` | one payment, with client, amount, date and category |

**Two of these turn on whether duplicates should be removed. Choosing wrongly changes the totals without any error appearing.**

---

## Question 1 - One combined transaction ledger

Stack invoices and payments into a single list, each row labelled with which it came from.

**Return:** type, reference id, client name, amount, transaction date, category.

> **Check yourself:** Every row from both tables must survive. If two clients happen to share an amount and a date you still need both rows, so think carefully about which set operator you reach for.

---

## Question 2 - Invoices with no matching payment

Which invoices have nothing corresponding in the payments table?

**Return:** client name, amount, category.

> **Check yourself:** Compare like with like: both sides must select the same columns in the same order.

---

## Question 3 - Invoices that were paid

The mirror image: invoices that do have a match in payments.

**Return:** client name, amount, category.

> **Check yourself:** Questions 2 and 3 together should account for every distinct invoice line.

---

## Question 4 - Per-client reconciliation

Rachel needs, for each client: total invoiced, total paid, and the outstanding balance.

**Return:** client name, total invoiced, total paid, balance.

> **Check yourself:** A client who has paid everything should show a balance of zero, not a blank.

---

## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day 16](../day-16/) | [Back to Day 17](README.md) | [Day 18 >>](../day-18/)
