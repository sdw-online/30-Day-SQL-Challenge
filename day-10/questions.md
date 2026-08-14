<p align="center">
  <a href="https://youtu.be/Iturx2kgs1A"><img src="../assets/banners/day-10-date-functions.svg" width="800" alt="Day 10 - Date Functions and CAST"></a>
</p>

<p align="center">
  <a href="https://youtu.be/Iturx2kgs1A"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-10_of_30-1f6feb" alt="Day 10">
  <img src="https://img.shields.io/badge/Questions-6-2da44e" alt="6 questions">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
  <img src="https://img.shields.io/badge/Solutions-not_on_this_page-8250df" alt="No solutions">
</p>

<h1 align="center">Day 10 &middot; Exercise Questions</h1>

<p align="center">
  <a href="README.md">&#8592; Back to Day 10</a> &nbsp;&middot;&nbsp;
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

- [ ] [1. How long ago was each referral](#q1)
- [ ] [2. Patients waiting 90 days or more](#q2)
- [ ] [3. Referrals per month](#q3)
- [ ] [4. Referrals per quarter](#q4)
- [ ] [5. A report a human can read](#q5)
- [ ] [6. The full triage view](#q6)

---

## The scenario

You are a data analyst at a health organisation. The operations lead needs a board report on referral-to-appointment wait times before the quarterly review. Some patients have been seen; some are still waiting.

```mermaid
erDiagram
    patient_referrals {
        int referral_id PK
        text patient_name
        date patient_dob
        text department
        date referral_date
        date appointment_date
        text urgency
        text referring_source
    }
```

| Table | One row is |
|---|---|
| `patient_referrals` | one referral, with patient, department, urgency, referral date and appointment date if one exists |

> [!IMPORTANT]
> A missing appointment date does not mean nothing happened - it means the patient is still waiting. Several questions below depend on treating it that way rather than dropping the row.

---

<a id="q1"></a>

### 1. How long ago was each referral

Show every referral with a readable elapsed time since it was made - years, months and days rather than a raw number.

**Return:** patient name, department, referral date, time since referral.

<details>
<summary><b>Check yourself</b></summary>

<br>

This should return every row in the table.

</details>

---

<a id="q2"></a>

### 2. Patients waiting 90 days or more

The waiting list review needs everyone whose wait has reached 90 days. A patient who has been seen waited until their appointment; a patient still waiting has waited until today.

**Return:** patient name, department, urgency, referral date, appointment date, days waited.

<details>
<summary><b>Check yourself</b></summary>

<br>

If your query silently drops the patients with no appointment, you have excluded the people the report exists for.

</details>

---

<a id="q3"></a>

### 3. Referrals per month

Show how many referrals came in each month, labelled readably, oldest month first.

**Return:** month, referral count.

<details>
<summary><b>Check yourself</b></summary>

<br>

Group by the actual month value, not by the formatted label, or your ordering will go alphabetical.

</details>

---

<a id="q4"></a>

### 4. Referrals per quarter

The same count, but by year and quarter, for the board pack.

**Return:** year, quarter, referral count.

<details>
<summary><b>Check yourself</b></summary>

<br>

Four quarters per year, in order.

</details>

---

<a id="q5"></a>

### 5. A report a human can read

Format the dates as day, short month and year. Where no appointment exists, say so in words.

**Return:** patient name, department, formatted referral date, formatted appointment date or a message, urgency.

<details>
<summary><b>Check yourself</b></summary>

<br>

No raw timestamps and no blank cells in the output.

</details>

---

<a id="q6"></a>

### 6. The full triage view

Bring it together: how long each patient has waited, and whether they have been seen or are still waiting, longest wait first.

**Return:** patient name, department, urgency, days waited, status.

<details>
<summary><b>Check yourself</b></summary>

<br>

The top of this list is the report's whole purpose. If the longest waits are not at the top, check your ordering.

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
  <a href="../day-09/">&#8592; Day 9</a> &nbsp;&middot;&nbsp;
  <a href="README.md">Back to Day 10</a> &nbsp;&middot;&nbsp;
  <a href="../day-11/">Day 11 &#8594;</a>
</p>
