# Day 12 - Subqueries & Temp Tables

[Watch the video](https://youtu.be/SOt5jUrzKOU) | [← Day 11: CASE WHEN](../day-11/) | [Day 13: CTEs (Part 1) →](../day-13/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to nest one query inside another to answer multi-step questions
- Subquery patterns in WHERE: comparison operators and IN
- Scalar subqueries in SELECT for adding calculated benchmark columns
- Correlated subqueries that reference the outer query row by row
- Derived tables in FROM for multi-step calculations
- Temporary tables for storing intermediate results you need to reuse

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-11
- Comfortable with SELECT, WHERE, GROUP BY, aggregate functions, NULL handling, string/date functions, and CASE WHEN

## Dataset

Today uses two tables:

**Teaching table:** Grocery shopping data - 25 purchases across 6 categories, 4 stores, and 5 shoppers.

**Exercise table:** School exam results - 30 records from students across 4 schools, 4 subjects, and grade levels 7-11.

Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand full setup SQL</summary>

```sql
-- ============================================
-- DAY 12 SETUP: Grocery + School Results data
-- ============================================

-- Teaching table
DROP TABLE IF EXISTS grocery_purchases;

CREATE TABLE grocery_purchases (
    purchase_id   SERIAL PRIMARY KEY,
    item_name     VARCHAR(100) NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    price         NUMERIC(6,2) NOT NULL,
    store_name    VARCHAR(50)  NOT NULL,
    purchase_date DATE         NOT NULL,
    shopper_name  VARCHAR(50)  NOT NULL
);

INSERT INTO grocery_purchases
    (item_name, category, price, store_name, purchase_date, shopper_name)
VALUES
    ('Chicken Breast',     'Protein',    7.80,  'FreshMart',    '2025-04-01', 'Kofi'),
    ('Brown Rice',         'Grains',     2.50,  'GreenGrocer',  '2025-04-01', 'Nyla'),
    ('Broccoli',           'Produce',    1.90,  'FreshMart',    '2025-04-02', 'Dante'),
    ('Greek Yoghurt',      'Dairy',      4.20,  'QuickStop',    '2025-04-02', 'Maren'),
    ('Granola Bars',       'Snacks',     3.60,  'WholeBasket',  '2025-04-02', 'Suki'),
    ('Orange Juice',       'Beverages',  3.10,  'FreshMart',    '2025-04-03', 'Kofi'),
    ('Salmon Fillet',      'Protein',   14.50,  'WholeBasket',  '2025-04-03', 'Nyla'),
    ('Whole Wheat Bread',  'Grains',     3.40,  'GreenGrocer',  '2025-04-03', 'Dante'),
    ('Spinach',            'Produce',    2.10,  'FreshMart',    '2025-04-04', 'Maren'),
    ('Cheddar Cheese',     'Dairy',      5.60,  'QuickStop',    '2025-04-04', 'Suki'),
    ('Trail Mix',          'Snacks',     4.80,  'WholeBasket',  '2025-04-05', 'Kofi'),
    ('Sparkling Water',    'Beverages',  1.20,  'GreenGrocer',  '2025-04-05', 'Nyla'),
    ('Minced Beef',        'Protein',    6.90,  'FreshMart',    '2025-04-05', 'Dante'),
    ('Pasta',              'Grains',     1.80,  'QuickStop',    '2025-04-06', 'Maren'),
    ('Bananas',            'Produce',    1.40,  'GreenGrocer',  '2025-04-06', 'Suki'),
    ('Milk',               'Dairy',      2.30,  'FreshMart',    '2025-04-07', 'Kofi'),
    ('Crisps',             'Snacks',     2.90,  'QuickStop',    '2025-04-07', 'Nyla'),
    ('Herbal Tea',         'Beverages',  3.70,  'WholeBasket',  '2025-04-08', 'Dante'),
    ('Eggs',               'Protein',    4.10,  'GreenGrocer',  '2025-04-08', 'Maren'),
    ('Oats',               'Grains',     2.80,  'FreshMart',    '2025-04-09', 'Suki'),
    ('Tomatoes',           'Produce',    2.60,  'GreenGrocer',  '2025-04-09', 'Kofi'),
    ('Butter',             'Dairy',      3.50,  'QuickStop',    '2025-04-09', 'Nyla'),
    ('Dark Chocolate',     'Snacks',     5.20,  'WholeBasket',  '2025-04-10', 'Dante'),
    ('Apple Juice',        'Beverages',  2.90,  'FreshMart',    '2025-04-10', 'Maren'),
    ('Prawns',             'Protein',   11.40,  'WholeBasket',  '2025-04-10', 'Suki');

-- Exercise table
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
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM grocery_purchases;
-- Expected: 25 rows

SELECT COUNT(*) FROM school_results;
-- Expected: 30 rows
```

## Exercises

You work at a regional education authority. The Head of School Performance needs a benchmarking report that compares student scores against school and national averages.

Using the `school_results` table, complete the tasks below.

### Task 1: Above-Average Students

Use a subquery to find all students who scored above the overall average score. Show the student name, school, subject, and score, sorted by score descending.

### Task 2: School Average vs Student Score

Use a correlated subquery in SELECT to show each student's score alongside their school's average score. Add a column showing the difference between the student's score and their school average. Sort by school name, then score descending.

### Task 3: Underperforming Schools

Use a derived table (subquery in FROM) to find schools whose average score is below the national average. Show the school name and average score.

### Task 4: Temp Table Report

Create a temp table that stores each school's average score, student count, and highest score. Then query the temp table to produce a summary report, adding a performance rating: "Strong" for averages above 80, "Average" for 60+, and "Needs Support" for below 60.

## Key Concepts Covered
- **Subqueries in WHERE:** Use a subquery as a dynamic threshold instead of hardcoding values
- **Scalar subqueries in SELECT:** Add calculated benchmark columns (like averages) to every row
- **Correlated subqueries:** Reference the outer query to calculate row-specific values (e.g. school average per student)
- **Derived tables in FROM:** Wrap a subquery as a virtual table for multi-step calculations - always needs an alias
- **Temp tables:** Calculate once, reuse many times - session-scoped, disappear when you disconnect
- **CREATE TEMP TABLE AS:** Shortcut to create and populate a temp table from a query in one step

---

[← Day 11: CASE WHEN](../day-11/) | [Day 13: CTEs (Part 1) →](../day-13/)
