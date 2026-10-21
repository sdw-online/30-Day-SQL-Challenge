-- ============================================================
-- DAY 22 SOLUTIONS: Window Functions Part 1
-- ============================================================
-- Two datasets today.
--   marathon_results - the teaching table. 12 runners in three age categories,
--                      with tied finish times so you can see how each ranking
--                      function treats a tie.
--   mock_results     - the exercise table. 24 Year 11 mock exam results, 8
--                      students x 3 subjects, with an exam mark and a coursework
--                      mark each.
--
-- Run setup.sql first (it builds both tables), or exercise.sql for just
-- mock_results. Part A walks the lesson queries on the marathon data. Part B is
-- the exercise - Delphine's prize-evening report.


-- ============================================================
-- PART A: THE LESSON - RANKING THE MARATHON
-- ============================================================


-- ------------------------------------------------------------
-- A1. GROUP BY collapses the rows
-- ------------------------------------------------------------
-- One row per age category. The 12 runners are gone - you get 3 averages and
-- nothing else.
-- Expected: Under-40 150.3, 40-49 153.3, 50-plus 155.5.
SELECT
    age_category,
    ROUND(AVG(finish_minutes), 1) AS avg_finish
FROM marathon_results
GROUP BY age_category
ORDER BY avg_finish;

-- A window function keeps every row. Same average, but it sits alongside each
-- runner as a new column instead of replacing them. 12 rows, not 3.
SELECT
    runner_name,
    age_category,
    finish_minutes,
    ROUND(AVG(finish_minutes) OVER (PARTITION BY age_category), 1) AS category_avg
FROM marathon_results
ORDER BY age_category, finish_minutes;


-- ------------------------------------------------------------
-- A2. The OVER clause - empty brackets means "everyone"
-- ------------------------------------------------------------
-- OVER () with nothing inside makes the window the whole result set, so every
-- runner is compared to the same field average of 153.0. Hector is 19 minutes
-- under it; Maya is 25 minutes over.
SELECT
    runner_name,
    finish_minutes,
    ROUND(AVG(finish_minutes) OVER (), 1) AS field_avg,
    finish_minutes - ROUND(AVG(finish_minutes) OVER (), 1) AS vs_field
FROM marathon_results
ORDER BY finish_minutes;


-- ------------------------------------------------------------
-- A3. ROW_NUMBER - a clean 1 to 12, no ties allowed
-- ------------------------------------------------------------
-- Wilf and Anna both finished in 142, but ROW_NUMBER hands out 3 and 4 anyway.
-- Which of them gets 3 is not defined, because nothing in the ORDER BY breaks
-- the tie. That is the catch with ROW_NUMBER: always give it a tie-breaker.
SELECT
    ROW_NUMBER() OVER (ORDER BY finish_minutes) AS position,
    runner_name,
    age_category,
    finish_minutes
FROM marathon_results
ORDER BY position;


-- ------------------------------------------------------------
-- A4. RANK - ties share a place, then skip
-- ------------------------------------------------------------
-- Wilf and Anna are both 3rd. Barnaby is 5th - there is no 4th, because two
-- people are ahead of him in joint 3rd. Same again at 155: Rufus and Pippa
-- share 7th, Fergus is 9th.
-- Expected ranks: 1, 2, 3, 3, 5, 6, 7, 7, 9, 10, 11, 12.
SELECT
    RANK() OVER (ORDER BY finish_minutes) AS finish_rank,
    runner_name,
    finish_minutes
FROM marathon_results
ORDER BY finish_rank;


-- ------------------------------------------------------------
-- A5. DENSE_RANK - ties share a place, no skip
-- ------------------------------------------------------------
-- Wilf and Anna are still joint 3rd, but Barnaby is now 4th. The numbering
-- never leaves a gap, so the biggest tier is 10 even though there are 12
-- runners.
-- Expected tiers: 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 10.
SELECT
    DENSE_RANK() OVER (ORDER BY finish_minutes) AS finish_tier,
    runner_name,
    finish_minutes
FROM marathon_results
ORDER BY finish_tier;


-- ------------------------------------------------------------
-- A6. All three side by side
-- ------------------------------------------------------------
-- The one query to remember. Read across the 142 rows: ROW_NUMBER says 3 and
-- 4, RANK says 3 and 3, DENSE_RANK says 3 and 3. Then read the next row:
-- RANK jumps to 5, DENSE_RANK carries on at 4.
SELECT
    runner_name,
    finish_minutes,
    ROW_NUMBER() OVER (ORDER BY finish_minutes) AS row_num,
    RANK()       OVER (ORDER BY finish_minutes) AS rank_val,
    DENSE_RANK() OVER (ORDER BY finish_minutes) AS dense_val
FROM marathon_results
ORDER BY finish_minutes;


-- ------------------------------------------------------------
-- A7. NTILE - splitting the runners into buckets
-- ------------------------------------------------------------
-- 12 runners into 4 quartiles means exactly 3 per bucket. NTILE splits by
-- position, not by value: Wilf and Anna share a time but one lands in
-- quartile 1 and the other in quartile 2.
-- Expected: quartile 1 = Hector, Sofia + one of the 142s; quartile 4 = Tamsin,
-- Ansel, Maya.
SELECT
    NTILE(4) OVER (ORDER BY finish_minutes) AS quartile,
    runner_name,
    finish_minutes
FROM marathon_results
ORDER BY quartile, finish_minutes;


-- ------------------------------------------------------------
-- A8. PARTITION BY - ranking within groups
-- ------------------------------------------------------------
-- The rank restarts at 1 for each age category. All 12 rows are still here;
-- each category simply gets its own leaderboard.
-- Expected winners: Hector (Under-40), Sofia (40-49), Barnaby (50-plus).
SELECT
    age_category,
    runner_name,
    finish_minutes,
    RANK() OVER (
        PARTITION BY age_category
        ORDER BY finish_minutes
    ) AS category_rank
FROM marathon_results
ORDER BY age_category, category_rank;

-- The trap: you cannot filter on a window function in WHERE, because WHERE
-- runs before the rank exists. This version FAILS with
--   ERROR: column "category_rank" does not exist
-- It is left commented out so the rest of this file runs clean.
--
-- SELECT
--     age_category,
--     runner_name,
--     finish_minutes,
--     RANK() OVER (
--         PARTITION BY age_category
--         ORDER BY finish_minutes
--     ) AS category_rank
-- FROM marathon_results
-- WHERE category_rank = 1;

-- The fix: rank in an inner query, filter in an outer one. The inner query
-- builds the rank; the outer query keeps only position 1.
-- Expected: 3 rows - Hector 134, Sofia 138, Barnaby 147.
SELECT *
FROM (
    SELECT
        age_category,
        runner_name,
        finish_minutes,
        ROW_NUMBER() OVER (
            PARTITION BY age_category
            ORDER BY finish_minutes
        ) AS category_position
    FROM marathon_results
) ranked
WHERE category_position = 1
ORDER BY finish_minutes;


-- ============================================================
-- PART B: THE EXERCISE - DELPHINE'S PRIZE-EVENING REPORT
-- ============================================================
-- Delphine is Head of Year 11. Prize evening is next week and she needs the
-- mock results sorted: the Maths results ranked honestly, every subject ranked
-- separately and split into four sets, and one prize winner per subject - with
-- coursework deciding any tie on the exam.


-- ------------------------------------------------------------
-- Explore the data
-- ------------------------------------------------------------
-- 24 rows, sorted by subject then exam mark. The thing to spot: Ottilie and
-- Clemmie are both on 88 in English, sharing the top spot. That tie decides
-- who gets the English prize.
SELECT *
FROM mock_results
ORDER BY subject, exam_mark DESC;

-- Every subject has a full set of 8 students.
-- Expected: English 61-88, Maths 58-91, Science 71-95.
SELECT
    subject,
    COUNT(*)       AS students,
    MIN(exam_mark) AS lowest,
    MAX(exam_mark) AS highest
FROM mock_results
GROUP BY subject
ORDER BY subject;

-- Find every mark that more than one student shares in the same subject.
-- Expected 3 rows: English 88, Maths 84, Maths 72 - two students on each.
-- The ties are real, so the ranking function you choose changes the answer.
SELECT
    subject,
    exam_mark,
    COUNT(*) AS students_on_this_mark
FROM mock_results
GROUP BY subject, exam_mark
HAVING COUNT(*) > 1
ORDER BY subject, exam_mark DESC;


-- ------------------------------------------------------------
-- Task 1: Rank the Maths results three ways
-- ------------------------------------------------------------
-- Start with just the Maths rows, best first. WHERE can filter on subject
-- because subject is an ordinary column already in the table - and because
-- WHERE runs first, the ranking only ever sees the Maths rows.
-- Expected: 8 rows, Yaw on top with 91, Clemmie at the bottom on 58.
SELECT
    student_name,
    exam_mark
FROM mock_results
WHERE subject = 'Maths'
ORDER BY exam_mark DESC;

-- Now all three ranking functions side by side. Read across Mabel and Percy,
-- both on 84:
--   row_num   2 and 3 - ROW_NUMBER forced them apart for no reason
--   rank_val  2 and 2 - then Anouk (77) jumps to 4; 3rd is skipped
--   dense_val 2 and 2 - then Anouk is 3; no gap
-- Lower down, Ottilie and Hamish on 72: RANK gives 5 and 5 then Bea is 7;
-- DENSE_RANK gives 4 and 4 then Bea is 5.
--
-- Which column does Delphine read? If a student asks "how many people beat
-- me?", RANK answers it. If she asks "what was the 3rd-highest mark?",
-- DENSE_RANK answers it (Anouk's 77). ROW_NUMBER is the wrong tool for a
-- report card.
-- Expected: row_num 1-8; rank_val 1,2,2,4,5,5,7,8; dense_val 1,2,2,3,4,4,5,6.
SELECT
    student_name,
    exam_mark,
    ROW_NUMBER() OVER (ORDER BY exam_mark DESC) AS row_num,
    RANK()       OVER (ORDER BY exam_mark DESC) AS rank_val,
    DENSE_RANK() OVER (ORDER BY exam_mark DESC) AS dense_val
FROM mock_results
WHERE subject = 'Maths'
ORDER BY exam_mark DESC;


-- ------------------------------------------------------------
-- Task 2: Rank every subject and split into sets
-- ------------------------------------------------------------
-- PARTITION BY subject restarts the rank at 1 for each subject, so a top mark
-- in Science never competes against a top mark in English. All 24 rows stay.
-- Expected: English - Ottilie and Clemmie both rank 1, Bea is 3. Maths - Yaw
-- 1, Mabel and Percy 2, Anouk 4. Science - Hamish 1, a clean 1 to 8.
SELECT
    subject,
    student_name,
    exam_mark,
    RANK() OVER (
        PARTITION BY subject
        ORDER BY exam_mark DESC
    ) AS subject_rank
FROM mock_results
ORDER BY subject, subject_rank;

-- Add the sets. NTILE(4) inside the same partition splits each subject's 8
-- students into 4 sets of exactly 2.
--
-- Two things to notice. Science set 4 is Mabel (76) and Clemmie (71) - good
-- marks, but NTILE is relative: it fills every set however well everyone did.
-- If you want sets based on a threshold ("70 or more goes in set X"), that is
-- a CASE WHEN on the mark, not NTILE. And in Maths, Mabel and Percy share 84
-- but one lands in set 1 and the other in set 2 - NTILE splits by position,
-- not by value, so Delphine would have to move one of them by hand.
SELECT
    subject,
    student_name,
    exam_mark,
    RANK() OVER (
        PARTITION BY subject
        ORDER BY exam_mark DESC
    ) AS subject_rank,
    NTILE(4) OVER (
        PARTITION BY subject
        ORDER BY exam_mark DESC
    ) AS teaching_set
FROM mock_results
ORDER BY subject, subject_rank;


-- ------------------------------------------------------------
-- Task 3: One prize winner per subject (the capstone)
-- ------------------------------------------------------------
-- One prize per subject, so we need exactly one row at position 1 - that is
-- ROW_NUMBER. But ROW_NUMBER needs a rule for splitting ties, and Delphine
-- gave us one: coursework. coursework_mark DESC after the comma is the
-- tie-breaker, and it is only consulted when the exam marks match.
--
-- English: Clemmie (coursework 90) now sits 1st, Ottilie (84) 2nd. Maths:
-- Percy (81) now sits above Mabel (70) on 84. Run it again tomorrow and you
-- get the same answer.
SELECT
    subject,
    student_name,
    exam_mark,
    coursework_mark,
    ROW_NUMBER() OVER (
        PARTITION BY subject
        ORDER BY exam_mark DESC, coursework_mark DESC
    ) AS prize_position
FROM mock_results
ORDER BY subject, prize_position;

-- Keep only the winners. You cannot filter a rank in WHERE, so wrap it: the
-- inner query ranks, the outer query keeps prize_position 1.
-- Expected 3 rows:
--   English - Clemmie, 88 (on the coursework tie-breaker)
--   Maths   - Yaw, 91
--   Science - Hamish, 95
-- If two students ever tied on coursework as well, add one more column no two
-- students share (their name, if every name is different) to the ORDER BY.
-- That makes the result repeatable; the coursework column makes it fair.
SELECT
    subject,
    student_name,
    exam_mark,
    coursework_mark
FROM (
    SELECT
        subject,
        student_name,
        exam_mark,
        coursework_mark,
        ROW_NUMBER() OVER (
            PARTITION BY subject
            ORDER BY exam_mark DESC, coursework_mark DESC
        ) AS prize_position
    FROM mock_results
) ranked
WHERE prize_position = 1
ORDER BY subject;
