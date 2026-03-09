# Day 18 - Normalisation & Denormalisation

[Watch the video](COMING_SOON) | [← Day 17: UNION & UNION ALL](../day-17/) | [Day 19: Recursive CTEs →](../day-19/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- Why poorly structured tables cause update, insertion, and deletion anomalies
- The three normal forms (1NF, 2NF, 3NF) and how to apply them step by step
- How to split a messy flat table into focused, normalised tables
- When and why experienced engineers deliberately denormalise for read performance

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-17
- Comfortable with JOINs (Days 15-16) and UNION (Day 17)

## Dataset

Today uses a deliberately messy flat table from **BrightPath Education**, a UK-based online learning platform. The table stores students, courses, instructors, and enrolment details all in one wide table - with real design problems you will diagnose.

Run this SQL in pgAdmin to create the table structure.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop table if it already exists (safe to re-run)
DROP TABLE IF EXISTS course_enrolments_flat;

CREATE TABLE course_enrolments_flat (
    enrolment_id        SERIAL PRIMARY KEY,
    student_name        VARCHAR(100)    NOT NULL,
    student_email       VARCHAR(150)    NOT NULL,
    student_city        VARCHAR(100),
    student_country     VARCHAR(50)     DEFAULT 'United Kingdom',
    course_code         VARCHAR(20)     NOT NULL,
    course_title        VARCHAR(200)    NOT NULL,
    course_category     VARCHAR(50),
    course_level        VARCHAR(20),
    course_price_gbp    NUMERIC(8,2),
    instructor_name     VARCHAR(100),
    instructor_email    VARCHAR(150),
    instructor_dept     VARCHAR(100),
    dept_head           VARCHAR(100),
    enrolment_date      DATE            NOT NULL,
    completion_date     DATE,
    score               INTEGER,
    certificate_issued  BOOLEAN         DEFAULT FALSE,
    student_phone       VARCHAR(100),
    student_tags        VARCHAR(200)
);
```

Then populate it using the Python script below. Save it as `day_18_seed.py`, update the connection details, and run it with `python day_18_seed.py`:

```python
import psycopg2
import random
from datetime import date, timedelta
from faker import Faker

DB_HOST = 'localhost'
DB_PORT = 5432
DB_NAME = 'sql_challenge'
DB_USER = 'postgres'
DB_PASSWORD = 'your_password'   # <-- Update this

ENROLMENT_COUNT = 60

random.seed(18)
fake = Faker('en_GB')
Faker.seed(18)

conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
conn.autocommit = False
cursor = conn.cursor()

STUDENTS = [
    ('Amara Okafor',    'amara.okafor@brightmail.co.uk',   'London',       'United Kingdom'),
    ('Callum Reid',     'callum.reid@outlook.com',         'Edinburgh',    'United Kingdom'),
    ('Priya Nair',      'priya.nair@gmail.com',            'Manchester',   'United Kingdom'),
    ('Finn Gallagher',  'finn.gallagher@proton.me',        'Dublin',       'Ireland'),
    ('Mei Zhang',       'mei.zhang@brightmail.co.uk',      'Birmingham',   'United Kingdom'),
    ('Idris Mensah',    'idris.mensah@yahoo.co.uk',        'Bristol',      'United Kingdom'),
    ('Isla Crawford',   'isla.crawford@outlook.com',       'Glasgow',      'United Kingdom'),
    ('Ravi Kapoor',     'ravi.kapoor@gmail.com',           'Leeds',        'United Kingdom'),
    ('Sienna Blake',    'sienna.blake@proton.me',          'Cardiff',      'United Kingdom'),
    ('Kwame Asante',    'kwame.asante@brightmail.co.uk',   'London',       'United Kingdom'),
    ('Freya Lindqvist', 'freya.lindqvist@gmail.com',       'Stockholm',    'Sweden'),
    ('Mateo Reyes',     'mateo.reyes@outlook.com',         'Barcelona',    'Spain'),
    ('Nia Osei',        'nia.osei@yahoo.co.uk',            'London',       'United Kingdom'),
    ('Euan Mackenzie',  'euan.mackenzie@proton.me',        'Aberdeen',     'United Kingdom'),
    ('Safiya Hassan',   'safiya.hassan@brightmail.co.uk',  'Leicester',    'United Kingdom'),
]

COURSES = [
    ('SQL101',  'Introduction to SQL',              'Data',         'Beginner',     49.99),
    ('SQL201',  'Intermediate SQL for Analytics',    'Data',         'Intermediate', 79.99),
    ('SQL301',  'Advanced SQL & Performance',        'Data',         'Advanced',     99.99),
    ('PY101',   'Python Fundamentals',               'Programming',  'Beginner',     59.99),
    ('PY201',   'Python for Data Science',           'Programming',  'Intermediate', 89.99),
    ('DA101',   'Data Analysis with Excel',          'Data',         'Beginner',     39.99),
    ('ML101',   'Machine Learning Foundations',       'Data Science', 'Intermediate', 119.99),
    ('WEB101',  'Web Development Basics',            'Engineering',  'Beginner',     69.99),
    ('CLD101',  'Cloud Computing with AWS',          'Engineering',  'Intermediate', 109.99),
    ('DBT101',  'Analytics Engineering with dbt',    'Data',         'Advanced',     89.99),
]

INSTRUCTORS = [
    ('Dr Aisha Begum',     'aisha.begum@brightpath.edu',       'Data & Analytics',     'Prof. Yuki Tanaka'),
    ('Marcus Chen',        'marcus.chen@brightpath.edu',       'Data & Analytics',     'Prof. Yuki Tanaka'),
    ('Dr Niamh Kelly',     'niamh.kelly@brightpath.edu',       'Computer Science',     'Prof. Jamal Williams'),
    ('Arjun Patel',        'arjun.patel@brightpath.edu',       'Computer Science',     'Prof. Jamal Williams'),
    ('Zara El-Amin',       'zara.elamin@brightpath.edu',       'Data Science',         'Prof. Leila Okonkwo'),
]

COURSE_INSTRUCTOR_MAP = {
    'SQL101': 0, 'SQL201': 0, 'SQL301': 1, 'PY101': 3, 'PY201': 2,
    'DA101': 0, 'ML101': 4, 'WEB101': 3, 'CLD101': 2, 'DBT101': 1,
}

TAG_OPTIONS = [
    'career-changer', 'graduate', 'self-taught', 'corporate',
    'part-time', 'full-time', 'scholarship', 'returning-learner',
    'data-track', 'engineering-track'
]

def generate_phone(has_multiple):
    phone1 = f"+44 7{random.randint(100,999)} {random.randint(100,999)} {random.randint(1000,9999)}"
    if has_multiple:
        phone2 = f"+44 7{random.randint(100,999)} {random.randint(100,999)} {random.randint(1000,9999)}"
        return f"{phone1}, {phone2}"
    return phone1

enrolment_pairs = []
for student_idx in range(len(STUDENTS)):
    num_courses = random.randint(3, 6)
    course_indices = random.sample(range(len(COURSES)), num_courses)
    for course_idx in course_indices:
        enrolment_pairs.append((student_idx, course_idx))

random.shuffle(enrolment_pairs)
enrolment_pairs = enrolment_pairs[:ENROLMENT_COUNT]

student_phones = {}
for idx in range(len(STUDENTS)):
    has_multiple = random.random() < 0.3
    student_phones[idx] = generate_phone(has_multiple)

student_tags = {}
for idx in range(len(STUDENTS)):
    num_tags = random.randint(1, 3)
    tags = random.sample(TAG_OPTIONS, num_tags)
    student_tags[idx] = ', '.join(tags)

inserted_count = 0
for student_idx, course_idx in enrolment_pairs:
    student = STUDENTS[student_idx]
    course = COURSES[course_idx]
    instructor_idx = COURSE_INSTRUCTOR_MAP[course[0]]
    instructor = INSTRUCTORS[instructor_idx]

    enrolment_date = date(2025, 1, 1) + timedelta(days=random.randint(0, 180))

    if random.random() < 0.70:
        completion_date = enrolment_date + timedelta(days=random.randint(14, 90))
        score = random.randint(40, 100)
        certificate_issued = score >= 60
    else:
        completion_date = None
        score = None
        certificate_issued = False

    cursor.execute(
        """
        INSERT INTO course_enrolments_flat (
            student_name, student_email, student_city, student_country,
            course_code, course_title, course_category, course_level, course_price_gbp,
            instructor_name, instructor_email, instructor_dept, dept_head,
            enrolment_date, completion_date, score, certificate_issued,
            student_phone, student_tags
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (
            student[0], student[1], student[2], student[3],
            course[0], course[1], course[2], course[3], course[4],
            instructor[0], instructor[1], instructor[2], instructor[3],
            enrolment_date, completion_date, score, certificate_issued,
            student_phones[student_idx], student_tags[student_idx]
        )
    )
    inserted_count += 1

conn.commit()
cursor.close()
conn.close()
print(f"Inserted {inserted_count} enrolment records.")
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM course_enrolments_flat;
-- Expected: 60 rows

SELECT COUNT(DISTINCT student_email) AS unique_students FROM course_enrolments_flat;
-- Expected: 15

SELECT COUNT(DISTINCT course_code) AS unique_courses FROM course_enrolments_flat;
-- Expected: 10

SELECT COUNT(DISTINCT instructor_email) AS unique_instructors FROM course_enrolments_flat;
-- Expected: 5
```

## Exercises

You are an analytics engineer at **BrightPath Education** - an online learning platform. The data team lead, Ravi, sends you a message on Monday morning. He says the `course_enrolments_flat` table is causing data quality issues. Instructors' names show up wrong in some reports. They cannot add new courses without fake enrolments. And the BI dashboard takes twelve seconds to load.

BrightPath is preparing for a Series A fundraise. Investors will audit the data platform. If the data team cannot demonstrate clean architecture, it raises red flags about operational maturity. Ravi needs this done before the audit next week.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** How many total rows are there in the flat table, and how many unique students, courses, and instructors exist? On average, how many times is each student's information repeated?

**Q2:** Find any rows where `student_phone` contains multiple phone numbers in a single cell. Which students have this 1NF violation?

### 🟡 Practice

**Q3:** Design and build a normalised schema (3NF). Create separate tables for departments, instructors, students, courses, and enrolments. Then migrate the data from the flat table using `INSERT INTO ... SELECT DISTINCT`. After migration, verify the row counts: 3 departments, 5 instructors, 15 students, 10 courses, and 60 enrolments.

**Q4:** Create a materialised view called `mv_enrolment_dashboard` that pre-joins enrolments with students, courses, and instructors. The dashboard team should be able to query this view with zero JOINs. Verify that the materialised view contains the same number of rows as the original flat table.

### 🔴 Challenge

**Q5:** After building your normalised schema, simulate an update anomaly fix. Change one instructor's name in your normalised `instructors` table and confirm the change is reflected everywhere by querying the materialised view after refreshing it. How many rows would you have needed to update in the flat table for the same change?

**Q6:** Identify every transitive dependency in the flat table. For each one, explain the chain (A determines B, B determines C) and show with a query how many rows you would need to update if the value of C changed. Which transitive dependency has the highest redundancy cost?

## Key Concepts Covered
- **Normalisation:** A set of rules for organising data so each fact is stored exactly once, eliminating update, insertion, and deletion anomalies
- **First Normal Form (1NF):** Every cell holds one value, every row is unique - no comma-separated lists or multi-value fields
- **Second Normal Form (2NF):** Every column depends on the entire primary key, not just part of it - no partial dependencies
- **Third Normal Form (3NF):** No column depends on another non-key column - no transitive dependencies ("the key, the whole key, and nothing but the key")
- **Denormalisation:** Deliberately adding redundancy back in for read performance - used on derived copies like materialised views, never on the source of truth
- **Materialised views:** A saved snapshot of a query result stored on disk, refreshable on demand with `REFRESH MATERIALIZED VIEW`

---

[← Day 17: UNION & UNION ALL](../day-17/) | [Day 19: Recursive CTEs →](../day-19/)
