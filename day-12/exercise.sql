-- Day 12: Subqueries & Temp Tables - Exercise Script
-- Exercise table: school_results (30 rows)

DROP TABLE IF EXISTS school_results;

CREATE TABLE school_results (
    result_id    SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    school_name  VARCHAR(80)  NOT NULL,
    subject      VARCHAR(50)  NOT NULL,
    score        INTEGER      NOT NULL,
    exam_date    DATE         NOT NULL,
    grade_level  INTEGER      NOT NULL
);

INSERT INTO school_results
    (student_name, school_name, subject, score, exam_date, grade_level)
VALUES
    ('Hamza',     'Oakfield Academy',  'Maths',    72, '2025-03-03', 9),
    ('Oluchi',    'Oakfield Academy',  'English',  85, '2025-03-04', 10),
    ('Ewan',      'Oakfield Academy',  'Science',  63, '2025-03-05', 9),
    ('Thea',      'Oakfield Academy',  'History',  91, '2025-03-06', 11),
    ('Jaden',     'Oakfield Academy',  'Maths',    58, '2025-03-07', 8),
    ('Blessing',  'Oakfield Academy',  'English',  79, '2025-03-10', 10),
    ('Noor',      'Oakfield Academy',  'Science',  88, '2025-03-11', 11),
    ('Felix',     'Riverside High',    'Maths',    45, '2025-03-03', 7),
    ('Ria',       'Riverside High',    'English',  67, '2025-03-04', 8),
    ('Oscar',     'Riverside High',    'Science',  52, '2025-03-05', 7),
    ('Zainab',    'Riverside High',    'History',  73, '2025-03-06', 9),
    ('Leo',       'Riverside High',    'Maths',    38, '2025-03-07', 7),
    ('Esme',      'Riverside High',    'English',  61, '2025-03-10', 8),
    ('Dex',       'Riverside High',    'Science',  44, '2025-03-11', 7),
    ('Hamza',     'Riverside High',    'History',  56, '2025-03-12', 9),
    ('Callista',  'St Margarets',      'Maths',    94, '2025-03-03', 11),
    ('Oluchi',    'St Margarets',      'English',  87, '2025-03-04', 10),
    ('Thea',      'St Margarets',      'Science',  76, '2025-03-05', 9),
    ('Jaden',     'St Margarets',      'History',  82, '2025-03-06', 10),
    ('Noor',      'St Margarets',      'Maths',    91, '2025-03-07', 11),
    ('Blessing',  'St Margarets',      'English',  78, '2025-03-10', 10),
    ('Felix',     'St Margarets',      'Science',  69, '2025-03-11', 9),
    ('Ewan',      'St Margarets',      'History',  83, '2025-03-12', 10),
    ('Ria',       'Hillcrest School',  'Maths',    55, '2025-03-03', 8),
    ('Oscar',     'Hillcrest School',  'English',  70, '2025-03-04', 9),
    ('Leo',       'Hillcrest School',  'Science',  48, '2025-03-05', 7),
    ('Zainab',    'Hillcrest School',  'History',  62, '2025-03-06', 8),
    ('Esme',      'Hillcrest School',  'Maths',    30, '2025-03-07', 7),
    ('Dex',       'Hillcrest School',  'English',  41, '2025-03-10', 7),
    ('Callista',  'Hillcrest School',  'Science',  98, '2025-03-11', 11);
