-- Day 22: Window Functions Part 1 - Exercise Script
-- 30 Day SQL Challenge | Stephen | Data
--
-- Creates ONLY the exercise table. If you have already run setup.sql you do
-- not need this file - setup.sql builds the teaching AND the exercise tables.

-- Day 22 - Window Functions Part 1 exercise dataset: Year 11 mock exam results.
-- Grain of mock_results: one row per student per subject.
-- 8 students x 3 subjects (Maths, English, Science) = 24 rows. Exam marks are
-- whole numbers, so several students land on the same mark - the ties are
-- deliberate, because they are what make the choice of ranking function matter.
--
-- WARNING: this script DROPs and rebuilds mock_results in the PUBLIC schema.
-- Do not run against a live database without first confirming that is intended.

DROP TABLE IF EXISTS mock_results;

CREATE TABLE mock_results (
    result_id       SERIAL PRIMARY KEY,
    student_name    VARCHAR(50) NOT NULL,
    subject         VARCHAR(20) NOT NULL,
    exam_mark       INTEGER     NOT NULL CHECK (exam_mark BETWEEN 0 AND 100),
    coursework_mark INTEGER     NOT NULL CHECK (coursework_mark BETWEEN 0 AND 100)
);

-- =====================================================================
-- INSERT - mock_results (24 rows: 8 students x 3 subjects)
-- Ties on exam_mark: English 88 (Ottilie, Clemmie), Maths 84 (Mabel, Percy),
-- Maths 72 (Ottilie, Hamish). coursework_mark is the tie-breaker in Task 3.
-- =====================================================================

INSERT INTO mock_results (student_name, subject, exam_mark, coursework_mark) VALUES
    ('Yaw',     'Maths',   91, 78),
    ('Mabel',   'Maths',   84, 70),
    ('Percy',   'Maths',   84, 81),
    ('Anouk',   'Maths',   77, 66),
    ('Ottilie', 'Maths',   72, 74),
    ('Hamish',  'Maths',   72, 59),
    ('Bea',     'Maths',   65, 71),
    ('Clemmie', 'Maths',   58, 62),
    ('Ottilie', 'English', 88, 84),
    ('Clemmie', 'English', 88, 90),
    ('Bea',     'English', 81, 77),
    ('Anouk',   'English', 79, 80),
    ('Percy',   'English', 74, 69),
    ('Mabel',   'English', 70, 75),
    ('Hamish',  'English', 63, 60),
    ('Yaw',     'English', 61, 72),
    ('Hamish',  'Science', 95, 88),
    ('Anouk',   'Science', 92, 85),
    ('Yaw',     'Science', 89, 80),
    ('Percy',   'Science', 86, 79),
    ('Bea',     'Science', 83, 90),
    ('Ottilie', 'Science', 80, 76),
    ('Mabel',   'Science', 76, 82),
    ('Clemmie', 'Science', 71, 74);

SELECT 'mock_results' AS table_name, COUNT(*) AS row_count FROM mock_results;
