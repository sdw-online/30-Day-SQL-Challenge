<p align="center">
  <a href="https://youtu.be/eZ5iTTsKGkI"><img src="../assets/banners/day-11-case-when.svg" width="800" alt="Day 11 - CASE WHEN"></a>
</p>

<p align="center">
  <a href="https://youtu.be/eZ5iTTsKGkI"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-11_of_30-1f6feb" alt="Day 11">
  <img src="https://img.shields.io/badge/Questions-5-2da44e" alt="5 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
  <img src="https://img.shields.io/badge/Solutions-not_on_this_page-8250df" alt="No solutions">
</p>

<h1 align="center">Day 11 &middot; Exercise Questions</h1>

<p align="center">
  <a href="README.md">&#8592; Back to Day 11</a> &nbsp;&middot;&nbsp;
  <a href="exercise.sql">Exercise tables</a> &nbsp;&middot;&nbsp;
  <a href="solutions.sql">Solutions</a>
</p>

---

> [!NOTE]
> **How to use this page.** Run [`exercise.sql`](exercise.sql) first to create the tables and load the
> data, then answer the questions below **without opening the solutions**. Each one tells you what to
> return, and hides the expected result behind a toggle so you can check yourself once you have tried.
>
> The technique is deliberately not named. Working out which tool the question needs is most of the skill.

### Your run

- [ ] [1. Band the claims by priority](#q1)
- [ ] [2. Turn codes into labels](#q2)
- [ ] [3. Flag the service breaches](#q3)
- [ ] [4. Count the bands on one row](#q4)
- [ ] [5. The full triage report](#q5)

---

## The scenario

You are a data analyst at an insurance company. Ingrid, the operations manager, needs a triage report to help the claims team prioritise their workload.

```mermaid
erDiagram
    insurance_claims {
        int claim_id PK
        text claimant_name
        text incident_type
        numeric claim_amount
        numeric response_hours
        date filed_date
    }
```

| Table | One row is |
|---|---|
| `insurance_claims` | one claim, with the claimant, incident type, amount and response time |

> [!IMPORTANT]
> Every question here turns a raw value into a business label. Watch what happens to rows that match none of your conditions.

---

<a id="q1"></a>

### 1. Band the claims by priority

Anything from 10,000 upwards is High, from 2,500 up to 10,000 is Medium, everything else is Low.

**Return:** claim id, claimant name, incident type, claim amount, priority.

<details>
<summary><b>Check yourself</b></summary>

<br>

Every row must come back with a priority. A blank means a value fell through every branch.

</details>

---

<a id="q2"></a>

### 2. Turn codes into labels

The incident types are stored as short codes. Produce the customer-facing labels: auto is Motor Vehicle, home is Property, health is Medical, travel is Travel, liability is Liability.

**Return:** claim id, claimant name, incident type, incident label.

<details>
<summary><b>Check yourself</b></summary>

<br>

If a code appears that you did not list, what does your query return for it? Decide that deliberately.

</details>

---

<a id="q3"></a>

### 3. Flag the service breaches

Anything answered in over 48 hours has breached the service level, anything within 48 hours has not, and some claims have no response time recorded at all - those must not be reported as either.

**Return:** claim id, claimant name, response hours, SLA status.

<details>
<summary><b>Check yourself</b></summary>

<br>

Three possible outcomes, not two. The third is the one people forget.

</details>

---

<a id="q4"></a>

### 4. Count the bands on one row

Ingrid wants the three priority counts side by side on a single row, not as three separate rows.

**Return:** high count, medium count, low count.

<details>
<summary><b>Check yourself</b></summary>

<br>

The three counts must add up to the total number of claims.

</details>

---

<a id="q5"></a>

### 5. The full triage report

Combine it: claim, claimant, the readable incident label, the amount, and its priority band.

**Return:** claim id, claimant name, incident label, claim amount, priority.

<details>
<summary><b>Check yourself</b></summary>

<br>

This is what a claims handler would actually open. If any column still shows a raw code, it is not finished.

</details>

---

## When you are done

Compare against [`solutions.sql`](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer.

> [!TIP]
> What matters is whether you can say **why you chose yours**, what it costs, and what would have to be
> true about the data for it to break. That question, not the syntax, is the one interviews are
> actually testing.

<p align="center">
  <a href="../day-10/">&#8592; Day 10</a> &nbsp;&middot;&nbsp;
  <a href="README.md">Back to Day 11</a> &nbsp;&middot;&nbsp;
  <a href="../day-12/">Day 12 &#8594;</a>
</p>
