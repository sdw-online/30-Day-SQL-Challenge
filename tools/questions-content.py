# -*- coding: utf-8 -*-
"""Generate questions.md for the 11 remaining days, in the Day 15 pattern."""
import io, os



META = {
 '08': ('day-08-null-handling.svg', 'https://www.youtube.com/watch?v=0nH464EoZ9w', 'NULL Handling', 'Intermediate'),
 '09': ('day-09-string-numeric.svg', 'https://www.youtube.com/watch?v=h6J7AajBD6w', 'String and Numeric Functions', 'Intermediate'),
 '10': ('day-10-date-functions.svg', 'https://youtu.be/Iturx2kgs1A', 'Date Functions and CAST', 'Intermediate'),
 '11': ('day-11-case-when.svg', 'https://youtu.be/eZ5iTTsKGkI', 'CASE WHEN', 'Intermediate'),
 '12': ('day-12-subqueries.svg', 'https://youtu.be/SOt5jUrzKOU', 'Subqueries and Temp Tables', 'Intermediate'),
 '13': ('day-13-ctes.svg', 'https://youtu.be/IijQJAfqcJc', 'CTEs (Part 1)', 'Intermediate'),
 '16': ('day-16-cross-self-join.svg', 'https://youtu.be/ZYwPGw4ghkI', 'JOINs Part 2: CROSS and Self', 'Advanced'),
 '17': ('day-17-union.svg', 'https://youtu.be/wlohArgOSd4', 'UNION and UNION ALL', 'Advanced'),
 '18': ('day-18-normalisation.svg', 'https://youtu.be/dhdWwX8DAEg', 'Normalisation and Denormalisation', 'Advanced'),
 '19': ('day-19-recursive-ctes.svg', 'https://youtu.be/DI1swwiKxUc', 'Recursive CTEs', 'Advanced'),
 '20': ('day-20-star-schema.svg', 'https://youtu.be/bZjfSWOIsBI', 'Data Modelling (Star Schema)', 'Advanced'),
}

DATA = {}

DATA['08'] = dict(
 scenario="You are a data analyst at Bean and Leaf, a coffee shop chain. The menu system has been filled in by different people over time, so plenty of fields were simply left empty. Kwame, the operations manager, needs an audit before the monthly supplier review.",
 tables=[("menu_items", "one item on the menu, with its prices, supplier, category and stock")],
 note="Before you start: an empty field is not a zero, and it is not equal to anything - including another empty field. Almost every question below turns on that.",
 qs=[
  ("Audit what is actually missing",
   "Kwame wants one row telling him how many items are missing a cost price, how many are missing a supplier, and how many have no category.",
   "**Return:** three counts, one per field, on a single row.",
   "`COUNT(*)` and `COUNT(column)` do not return the same number. The gap between them is your answer."),
  ("A price list that reads properly",
   "Print the menu with its selling price and cost price, but where no cost has been recorded the report must say so in words rather than showing a manager a blank cell.",
   "**Return:** item name, sell price, cost price, and a display column that falls back to a readable message.",
   "Every row in the table must appear. If your row count dropped, you filtered instead of substituting."),
  ("Items nobody has categorised",
   "The menu is being reorganised and anything without a category needs assigning.",
   "**Return:** item name, sell price, stock quantity.",
   "If you compared the category to an empty value with =, you will get nothing back. That is the lesson, not a bug."),
  ("Low stock and nobody to call",
   "This is the one that gets escalated: items running low that also have no supplier recorded to reorder from. Fewer than 20 in stock, and no supplier.",
   "**Return:** item name, stock quantity, sell price.",
   "Two conditions, and one of them is about absence rather than a value."),
 ])

DATA['09'] = dict(
 scenario="You are supporting a city council infrastructure team. Road repair records imported from four district offices are inconsistent - stray spaces, mixed capitalisation, and reference codes with meaning buried inside them - and cannot be used for reporting until they are cleaned.",
 tables=[("raw_road_repairs", "one repair job, with its reference, road, district, type and costs")],
 note="The data is not wrong, it is untidy. Your job is to make it comparable without changing what is stored.",
 qs=[
  ("Find the invisible mess",
   "Before cleaning anything, prove which rows actually have a spacing problem. Show the road name and district with their lengths before and after the stray spaces come off, and return only the rows where those differ.",
   "**Return:** repair id, road name, its raw and trimmed length, district, its raw and trimmed length.",
   "If a row appears here, the two lengths in it must not match. That is the entire filter."),
  ("Make the text presentable",
   "Produce a clean version for a public-facing report: road names in title case, districts in capitals, repair type tidied.",
   "**Return:** repair ref, cleaned road name, cleaned district, cleaned repair type.",
   "Trim before you change case, or you will capitalise a space."),
  ("Where the money went over",
   "Finance wants the difference between what each job was estimated at and what it actually cost, in pounds and as a percentage, both to two decimal places.",
   "**Return:** repair ref, road name, cost variance, variance percentage.",
   "A negative variance means it came in under. Do not take an absolute value - the sign is the information."),
  ("The city code hidden in the reference",
   "Each repair reference carries a three-character city code inside it, starting at the fourth character. Pull it into its own column so jobs can be grouped by city.",
   "**Return:** repair ref, city code, road name.",
   "Count the characters carefully. Off by one here is silent and wrong."),
 ])

DATA['10'] = dict(
 scenario="You are a data analyst at a health organisation. The operations lead needs a board report on referral-to-appointment wait times before the quarterly review. Some patients have been seen; some are still waiting.",
 tables=[("patient_referrals", "one referral, with patient, department, urgency, referral date and appointment date if one exists")],
 note="A missing appointment date does not mean nothing happened - it means the patient is still waiting. Several questions below depend on treating it that way rather than dropping the row.",
 qs=[
  ("How long ago was each referral",
   "Show every referral with a readable elapsed time since it was made - years, months and days rather than a raw number.",
   "**Return:** patient name, department, referral date, time since referral.",
   "This should return every row in the table."),
  ("Patients waiting 90 days or more",
   "The waiting list review needs everyone whose wait has reached 90 days. A patient who has been seen waited until their appointment; a patient still waiting has waited until today.",
   "**Return:** patient name, department, urgency, referral date, appointment date, days waited.",
   "If your query silently drops the patients with no appointment, you have excluded the people the report exists for."),
  ("Referrals per month",
   "Show how many referrals came in each month, labelled readably, oldest month first.",
   "**Return:** month, referral count.",
   "Group by the actual month value, not by the formatted label, or your ordering will go alphabetical."),
  ("Referrals per quarter",
   "The same count, but by year and quarter, for the board pack.",
   "**Return:** year, quarter, referral count.",
   "Four quarters per year, in order."),
  ("A report a human can read",
   "Format the dates as day, short month and year. Where no appointment exists, say so in words.",
   "**Return:** patient name, department, formatted referral date, formatted appointment date or a message, urgency.",
   "No raw timestamps and no blank cells in the output."),
  ("The full triage view",
   "Bring it together: how long each patient has waited, and whether they have been seen or are still waiting, longest wait first.",
   "**Return:** patient name, department, urgency, days waited, status.",
   "The top of this list is the report's whole purpose. If the longest waits are not at the top, check your ordering."),
 ])

DATA['11'] = dict(
 scenario="You are a data analyst at an insurance company. Ingrid, the operations manager, needs a triage report to help the claims team prioritise their workload.",
 tables=[("insurance_claims", "one claim, with the claimant, incident type, amount and response time")],
 note="Every question here turns a raw value into a business label. Watch what happens to rows that match none of your conditions.",
 qs=[
  ("Band the claims by priority",
   "Anything from 10,000 upwards is High, from 2,500 up to 10,000 is Medium, everything else is Low.",
   "**Return:** claim id, claimant name, incident type, claim amount, priority.",
   "Every row must come back with a priority. A blank means a value fell through every branch."),
  ("Turn codes into labels",
   "The incident types are stored as short codes. Produce the customer-facing labels: auto is Motor Vehicle, home is Property, health is Medical, travel is Travel, liability is Liability.",
   "**Return:** claim id, claimant name, incident type, incident label.",
   "If a code appears that you did not list, what does your query return for it? Decide that deliberately."),
  ("Flag the service breaches",
   "Anything answered in over 48 hours has breached the service level, anything within 48 hours has not, and some claims have no response time recorded at all - those must not be reported as either.",
   "**Return:** claim id, claimant name, response hours, SLA status.",
   "Three possible outcomes, not two. The third is the one people forget."),
  ("Count the bands on one row",
   "Ingrid wants the three priority counts side by side on a single row, not as three separate rows.",
   "**Return:** high count, medium count, low count.",
   "The three counts must add up to the total number of claims."),
  ("The full triage report",
   "Combine it: claim, claimant, the readable incident label, the amount, and its priority band.",
   "**Return:** claim id, claimant name, incident label, claim amount, priority.",
   "This is what a claims handler would actually open. If any column still shows a raw code, it is not finished."),
 ])

DATA['12'] = dict(
 scenario="You work at a regional education authority. The Head of School Performance needs a benchmarking report comparing student scores against school and overall averages.",
 tables=[("school_results", "one student's score in one subject at one school")],
 note="Several of these need a number worked out from the same table you are querying. That is the point of the day.",
 qs=[
  ("Who is above the overall average",
   "List every result that beat the average score across all schools and all subjects, best first.",
   "**Return:** student name, school name, subject, score.",
   "The average is a single number computed over the whole table, not per school."),
  ("Each student against their own school",
   "Now compare each student to their own school's average, and show the gap.",
   "**Return:** student name, school name, subject, score, school average, difference from that average.",
   "The average has to change per row depending on the school. If every row shows the same average, it is not tied to the school."),
  ("Schools below the overall picture",
   "Which schools have an average below the overall average across all schools?",
   "**Return:** school name, average score to one decimal place.",
   "You need the per-school averages to exist before you can compare them to anything."),
  ("A reusable summary",
   "Build a summary the rest of the analysis can query repeatedly without recomputing it - average score, number of students and highest score per school - then select from it.",
   "**Return:** school name, average score, student count, highest score.",
   "One row per school. More than that and your grouping is wrong."),
 ])

DATA['13'] = dict(
 scenario="You are working with Claire Foster, Head of Supply Chain Compliance. She needs a traceability report that flags high-risk stages across the food supply chain.",
 tables=[("supply_chain_stages", "one product at one stage, with its cost, duration and location")],
 note="Every question after the first is easier to read if the intermediate result has a name. That is what the day is teaching.",
 qs=[
  ("Get your bearings",
   "Before analysing anything, establish the shape of the data: how many records, how many distinct products, how many distinct stages, how many locations.",
   "**Return:** four counts.",
   "Distinct counts, not row counts. The difference is the point."),
  ("Where the money goes by stage",
   "Total cost for each processing stage, most expensive first.",
   "**Return:** stage name, total cost.",
   "One row per stage."),
  ("A product-level summary",
   "For each product: total cost, total days across all its stages, and how many stages it passes through. Most expensive product first.",
   "**Return:** product name, total cost, total days, stage count.",
   "One row per product."),
  ("Find the bottlenecks",
   "A stage is a bottleneck when its cost per day is above the average cost per day across everything. Work out cost per day for each record, then return only those above that average - these are the stages Claire needs to escalate.",
   "**Return:** stage id, product name, stage name, location, cost, duration, cost per day.",
   "You need two things named before you can compare them: the per-record rate, and the overall average of those rates."),
 ])

DATA['16'] = dict(
 scenario="A pharmacy system holds medications, known dangerous interactions between them, and what each patient is currently prescribed. Nneka needs a report she can hand straight to the clinical board.",
 tables=[("medications", "one medication, with its class"),
         ("interactions", "one known dangerous pair, with severity and effect"),
         ("patient_prescriptions", "one medication prescribed to one patient, by one doctor")],
 note="Two of these ask you to combine a table with itself. The trap throughout is producing each pair twice, once in each direction.",
 qs=[
  ("Every possible pair of drugs",
   "Produce every unique pair of medications that could be checked against each other, with each drug's class.",
   "**Return:** drug 1, class 1, drug 2, class 2, ordered by both names.",
   "Aspirin with Warfarin is the same pair as Warfarin with Aspirin, and no drug pairs with itself. If your count looks roughly double what you expected, that is why."),
  ("Only the dangerous pairs",
   "Narrow that to the pairs that appear in the known interactions table, with the severity and the effect.",
   "**Return:** drug 1, class 1, drug 2, class 2, severity, effect.",
   "This must be a small fraction of the previous answer."),
  ("Patients on more than one medication",
   "Find patients prescribed two or more medications at once, showing both drugs and which doctor prescribed each.",
   "**Return:** patient name, medication 1, medication 2, doctor 1, doctor 2.",
   "Same pairing trap as question 1, this time within a patient."),
  ("The dangerous combinations actually prescribed",
   "This is the report that matters clinically: patients whose prescribed pair appears in the interactions table.",
   "**Return:** patient name, drug 1, drug 2, severity, effect, and both prescribing doctors.",
   "Two different doctors on one row is exactly the situation this report exists to surface."),
  ("Tell the pharmacist what to do",
   "Add a recommended action driven by the severity, so the output is actionable rather than merely alarming.",
   "**Return:** as above, plus both drug classes and a recommended action.",
   "A severity with no matching action rule must not produce a blank instruction."),
 ])

DATA['17'] = dict(
 scenario="Rachel, the Head of Finance, wants a reconciliation report: the money that went out against the money that came in, checked against each other so nothing slips through. Invoices and payments sit in two separate tables with the same shape.",
 tables=[("invoices_sent", "one invoice, with client, amount, date and category"),
         ("payments_received", "one payment, with client, amount, date and category")],
 note="Two of these turn on whether duplicates should be removed. Choosing wrongly changes the totals without any error appearing.",
 qs=[
  ("One combined transaction ledger",
   "Stack invoices and payments into a single list, each row labelled with which it came from.",
   "**Return:** type, reference id, client name, amount, transaction date, category.",
   "Every row from both tables must survive. If two clients happen to share an amount and a date you still need both rows, so think carefully about which set operator you reach for."),
  ("Invoices with no matching payment",
   "Which invoices have nothing corresponding in the payments table?",
   "**Return:** client name, amount, category.",
   "Compare like with like: both sides must select the same columns in the same order."),
  ("Invoices that were paid",
   "The mirror image: invoices that do have a match in payments.",
   "**Return:** client name, amount, category.",
   "Questions 2 and 3 together should account for every distinct invoice line."),
  ("Per-client reconciliation",
   "Rachel needs, for each client: total invoiced, total paid, and the outstanding balance.",
   "**Return:** client name, total invoiced, total paid, balance.",
   "A client who has paid everything should show a balance of zero, not a blank."),
 ])

DATA['18'] = dict(
 scenario="A census extract arrives as one wide table, with one row per person and the household and region details repeated on every row.",
 tables=[("census_raw", "one person, plus their household address and region details repeated inline")],
 note="This day changes the shape of the data rather than querying it. Read the columns first and ask which facts belong to the person, which to the household, and which to the region.",
 qs=[
  ("Split it into normalised tables",
   "Break the wide table into three: one for regions, one for households, one for people. Address details belong to a household rather than repeating per person, and region type belongs to a region rather than to a person.",
   "**Return:** three table definitions, plus the inserts that populate them from the raw table.",
   "Each address should now be stored once. If an address still appears three times for a three-person household, the split has not gone far enough."),
  ("Put it back together",
   "Prove the split was lossless by reconstructing the original view from your three tables.",
   "**Return:** person name, relationship, occupation, address line, district, region, region type.",
   "20 rows, matching the original. A different number means something was lost or duplicated in the split."),
  ("Denormalise deliberately for reporting",
   "Dashboards do not want three tables. Build a reporting layer that presents the joined-up view, while the normalised tables remain the source of truth.",
   "**Return:** a view combining person, household and region detail.",
   "Be ready to say why the reporting layer is allowed to repeat data when the base tables are not. That argument is the whole day."),
 ])

DATA['19'] = dict(
 scenario="Ifeoma, the Supply Chain Director, needs the full supplier network mapped for the quarterly review. It is a hierarchy: Tier 1 suppliers buy from Tier 2, who buy from Tier 3, and each row points at its parent.",
 tables=[("suppliers", "one supplier, with its product, country, annual cost and a pointer to its parent supplier")],
 note="A row pointing at another row in the same table is a tree. You cannot walk it with a fixed number of joins unless you already know how deep it goes.",
 qs=[
  ("Find the top of the tree",
   "List the direct suppliers - the ones that answer to nobody - most expensive first. No recursion needed yet.",
   "**Return:** supplier name, product, country, annual cost.",
   "4 rows. These are the starting points for everything that follows."),
  ("Walk the whole chain",
   "Now traverse the full network, labelling every supplier with the tier it sits at.",
   "**Return:** supplier name, product, country, annual cost, tier.",
   "20 rows: 4 at tier 1, 8 at tier 2, 8 at tier 3. If it never stops, your recursive step is not moving down the tree."),
  ("How deep does each chain run",
   "For each Tier 1 supplier, how many suppliers sit beneath it and how deep does its chain go? Every row needs to remember which Tier 1 supplier it ultimately traces back to.",
   "**Return:** root supplier, deepest tier, supplier count.",
   "4 rows, one per Tier 1 supplier."),
  ("A monthly timeline with no table behind it",
   "A different use of the same tool: generate the monthly timeline Ifeoma wants for her review schedule - one row per month for 2025, without a calendar table.",
   "**Return:** 12 dates, January to December 2025.",
   "No source table at all. The first row is written by hand and each pass adds a month, stopping at December."),
 ])

DATA['20'] = dict(
 scenario="An energy company models generation data as a star schema: one fact table surrounded by dimensions, plus a bridge table because a site can supply more than one region.",
 tables=[("generation_fact", "one generation measurement, for one site in one period"),
         ("sites", "one generation site, with its energy source"),
         ("regions", "one region"),
         ("time_periods", "one time period"),
         ("site_region_supply", "one site supplying one region - the bridge")],
 note="Look at the row counts before you write anything. The big table is the fact and the small ones are dimensions. Which table a question needs is usually decided by which column it asks about.",
 qs=[
  ("Read the shape of the model",
   "Count every table so you can tell which is the fact and which are the dimensions.",
   "**Return:** table name and row count, for all five.",
   "96 generation rows against 8 sites is the giveaway. If you cannot tell which is the fact table, you cannot plan a query against it."),
  ("Through the bridge",
   "How many sites feed each region, most first?",
   "**Return:** region name, site count.",
   "There is no region on the fact table. If you tried to start there, that is the lesson: the bridge is the only route."),
  ("Renewable against non-renewable share",
   "Split total generation into renewable and non-renewable, and express each as a percentage of the whole.",
   "**Return:** energy source, total generation, percentage share.",
   "The two percentages must add to 100. Going through the bridge here would double-count any site supplying more than one region, so ask yourself whether this question needs it at all."),
 ])

HDR = '''<p align="center">
  <a href="{vid}"><img src="../assets/banners/{banner}" width="800" alt="Day {n} - {title}"></a>
</p>

<p align="center">
  <a href="{vid}"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-{n}_of_30-blue" alt="Day {n}">
  <img src="https://img.shields.io/badge/Questions-{q}-brightgreen" alt="{q} questions">
  <img src="https://img.shields.io/badge/Difficulty-{diff}-orange" alt="{diff}">
</p>

# Day {n} - Exercise Questions

[<< Back to Day {n}](README.md) | [Exercise tables](exercise.sql) | [Solutions](solutions.sql)

---

**How to use this page.** Run [exercise.sql](exercise.sql) first to create the tables and load the
data. Then answer the questions below **without opening the solutions**. Each one tells you what to
return and gives you a way to check yourself. The technique is deliberately not named - working out
which tool the question needs is most of the skill.

Stuck? The video walks through every one of these.

---

## The scenario

{scenario}

| Table | One row is |
|---|---|
{tbl}

**{note}**

---

'''

FTR = '''## When you are done

Compare against [solutions.sql](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer. What matters is
whether you can say **why you chose yours**, what it costs, and what would have to be true about the
data for it to break.

That question - not the syntax - is the one interviews are actually testing.

---

[<< Day {prev}](../day-{prevp}/) | [Back to Day {n}](README.md) | [Day {nxt} >>](../day-{nxtp}/)
'''

# Content only. Rendering lives in render-questions.py.
