# Day 8 - NULL Handling

[Watch the video](https://www.youtube.com/watch?v=0nH464EoZ9w) | [← Day 7: Project - Freight & Logistics Performance Report](../day-07/) | [Day 9: String & Numeric Functions →](../day-09/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What NULL actually means in SQL and why it causes silent bugs
- Three-valued logic - how TRUE, FALSE, and UNKNOWN work
- IS NULL and IS NOT NULL - the only correct way to check for missing values
- COALESCE - replacing NULLs with fallback values in reports and calculations
- NULLIF - preventing division-by-zero errors and cleaning placeholder values
- How NULL behaves in aggregate functions and sorting

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-7 (Week 1 fundamentals + project)
- pgAdmin open and connected to your `sql_challenge` database

## Dataset

Today uses two tables:

**Teaching table:** Library catalogue data - 20 books with intentional NULL patterns mirroring real-world data quality issues.

**Exercise table:** Coffee shop menu data - 20 menu items for the Bean & Leaf loyalty audit.

Run the SQL in [setup.sql](setup.sql) to create the teaching table, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand full setup SQL</summary>

```sql
-- ============================================
-- DAY 8 SETUP: library_books table for NULL Handling
-- ============================================

DROP TABLE IF EXISTS library_books;

CREATE TABLE library_books (
    book_id        SERIAL PRIMARY KEY,
    title          VARCHAR(100)    NOT NULL,
    author         VARCHAR(100)    NOT NULL,
    genre          VARCHAR(50),
    base_price     NUMERIC(6, 2)   NOT NULL,
    discount_pct   NUMERIC(5, 2),
    page_count     INTEGER         NOT NULL DEFAULT 0,
    is_available   BOOLEAN         NOT NULL DEFAULT TRUE,
    last_borrower  VARCHAR(50),
    reserved_by    VARCHAR(50),
    return_date    DATE
);

INSERT INTO library_books
    (title, author, genre, base_price, discount_pct, page_count, is_available, last_borrower, reserved_by, return_date)
VALUES
    ('The Glass Library',   'A. Morton',  'Fiction',  14.99,  NULL,   320,  TRUE,   NULL,      NULL,    NULL),
    ('Midnight Garden',     'B. Shaw',    'Fiction',  18.50,  NULL,   280,  TRUE,   NULL,      'Holly', NULL),
    ('Paper Kingdoms',      'C. Frost',   'Fiction',  22.99,  NULL,   410,  TRUE,   NULL,      NULL,    NULL),
    ('The Lost Chapter',    'D. Webb',    'Fiction',  12.99,  10.00,  195,  FALSE,  NULL,      'Jake',  NULL),
    ('Signal and Noise',    'E. Hart',    NULL,       29.99,  NULL,   0,    TRUE,   NULL,      NULL,    NULL),
    ('Quiet Earth',         'F. Lane',    NULL,       9.99,   NULL,   150,  TRUE,   NULL,      'Quinn', NULL),
    ('Dark Waters',         'G. Cole',    'Mystery',  16.99,  15.00,  340,  TRUE,   'Alice',   NULL,    '2025-02-10'),
    ('The Iron Bridge',     'H. Voss',    'History',  24.99,  20.00,  520,  TRUE,   'Ben',     NULL,    '2025-01-20'),
    ('Code Red',            'J. Osei',    'Science',  31.50,  10.00,  290,  TRUE,   'Callum',  NULL,    '2025-03-05'),
    ('Silent Witness',      'K. Ruiz',    'Mystery',  19.99,  15.00,  380,  TRUE,   'Ellie',   NULL,    '2024-12-15'),
    ('The Amber Room',      'L. Kato',    'Fiction',  27.50,  25.00,  450,  TRUE,   'George',  NULL,    '2025-04-01'),
    ('First Light',         'M. Chen',    NULL,       14.99,  NULL,   200,  TRUE,   'Grace',   NULL,    '2025-02-28'),
    ('Rust and Gold',       'N. Bell',    'History',  21.00,  10.00,  310,  FALSE,  'Harry',   NULL,    '2024-11-10'),
    ('The Quiet Storm',     'P. Das',     NULL,       35.99,  20.00,  280,  TRUE,   'Hiroshi', NULL,    '2025-03-18'),
    ('Border Lines',        'Q. Flynn',   'Science',  17.50,  15.00,  240,  TRUE,   'Jess',    NULL,    '2025-01-05'),
    ('The Long Walk',       'R. Mbeki',   'Unknown',  11.99,  10.00,  180,  TRUE,   'Lily',    NULL,    '2025-04-12'),
    ('Ocean Deep',          'S. Vega',    'Fiction',  28.00,  15.00,  360,  TRUE,   'Max',     NULL,    '2025-02-22'),
    ('The Wire',            'T. Holt',    NULL,       23.50,  15.00,  270,  TRUE,   'Megan',   NULL,    '2025-03-30'),
    ('Ghost Protocol',      'U. Khan',    'Mystery',  19.99,  NULL,   300,  TRUE,   'Safiya',  NULL,    '2025-04-08'),
    ('Stone Garden',        'V. Park',    NULL,       26.99,  NULL,   220,  TRUE,   'River',   NULL,    '2025-01-15');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM library_books;
-- Expected: 20 rows

SELECT COUNT(*) FROM menu_items;
-- Expected: 20 rows
```

## Exercises

You are a data analyst at Bean & Leaf, a coffee shop chain. The operations manager, **Kwame**, needs an audit of missing data before the monthly supplier review.

Using the `menu_items` table, complete the tasks below.

### Task 1: Audit Missing Data Counts

Write a single query that counts the number of NULLs in `cost_price`, `supplier_name`, and `category`. Use the `COUNT(*) - COUNT(column)` pattern to produce a summary row showing how many gaps exist in each column.

### Task 2: Menu Pricing with Missing Cost

For every menu item, show the item name, sell price, cost price, and a `display_cost` column that shows the cost price if known, or the text `'Cost not recorded'` if it is NULL. Use COALESCE.

### Task 3: Uncategorised Items

Find all menu items that have no category assigned. Show the item name, sell price, and stock quantity. How many items are uncategorised?

### Task 4: Low-Stock Items with No Supplier

Find all items with fewer than 20 units in stock where the supplier name is also NULL. These are the urgent procurement blind spots. Show the item name, stock quantity, and sell price.

## Key Concepts Covered
- **NULL means unknown:** It is not zero, not an empty string - it is the complete absence of a value
- **IS NULL / IS NOT NULL:** The only correct way to check for missing values - never use `= NULL` or `<> NULL`
- **COALESCE:** Returns the first non-NULL value from a list - essential for calculations, reports, and fallback displays
- **NULLIF:** Returns NULL when two values are equal - primarily used to prevent division-by-zero errors
- **COUNT(*) vs COUNT(column):** COUNT(*) counts all rows; COUNT(column) counts only non-NULL values - getting the wrong one silently distorts your reporting
- **AVG ignores NULLs:** Use COALESCE(column, 0) if you want NULLs treated as zero in averages

---

[← Day 7: Project - Freight & Logistics Performance Report](../day-07/) | [Day 9: String & Numeric Functions →](../day-09/)
