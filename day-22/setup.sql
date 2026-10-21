-- Day 22: Window Functions Part 1 - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

DROP TABLE IF EXISTS marathon_results;
DROP TABLE IF EXISTS mock_results;

CREATE TABLE marathon_results (
    runner_id      SERIAL PRIMARY KEY,
    runner_name    VARCHAR(50) NOT NULL,
    age_category   VARCHAR(10) NOT NULL,
    finish_minutes INTEGER     NOT NULL
);

INSERT INTO marathon_results (runner_name, age_category, finish_minutes) VALUES
    ('Hector',  'Under-40', 134),
    ('Sofia',   '40-49',    138),
    ('Wilf',    'Under-40', 142),
    ('Anna',    '40-49',    142),
    ('Barnaby', '50-plus',  147),
    ('Edie',    '50-plus',  150),
    ('Rufus',   'Under-40', 155),
    ('Pippa',   '40-49',    155),
    ('Fergus',  '50-plus',  160),
    ('Tamsin',  '50-plus',  165),
    ('Ansel',   'Under-40', 170),
    ('Maya',    '40-49',    178);

CREATE TABLE mock_results (
    result_id       SERIAL PRIMARY KEY,
    student_name    VARCHAR(50) NOT NULL,
    subject         VARCHAR(20) NOT NULL,
    exam_mark       INTEGER     NOT NULL CHECK (exam_mark BETWEEN 0 AND 100),
    coursework_mark INTEGER     NOT NULL CHECK (coursework_mark BETWEEN 0 AND 100)
);

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

SELECT 'marathon_results' AS table_name, COUNT(*) AS row_count FROM marathon_results
UNION ALL
SELECT 'mock_results', COUNT(*) FROM mock_results;

SELECT runner_name, age_category, finish_minutes
FROM marathon_results
ORDER BY finish_minutes
LIMIT 2;