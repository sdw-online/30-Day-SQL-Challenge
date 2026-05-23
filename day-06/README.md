# Day 6 - PRIMARY KEY, FOREIGN KEY & Constraints

[Watch the video](https://www.youtube.com/watch?v=1AdFU8Vdq-0) | [← Day 5: INSERT, UPDATE & DELETE](../day-05/) | [Day 7: Project: Freight & Logistics →](../day-07/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How PRIMARY KEY uniquely identifies every row and prevents duplicates
- How FOREIGN KEY links tables together and prevents orphan records
- How NOT NULL, UNIQUE, CHECK, and DEFAULT enforce data quality rules
- Composite keys - primary keys made of multiple columns
- CASCADE, SET NULL, and RESTRICT - controlling what happens when referenced data changes

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-5
- pgAdmin open and connected to your `sql_challenge` database
- Comfortable with SELECT, WHERE, ORDER BY, aggregates, GROUP BY, INSERT, UPDATE, DELETE

## Dataset

Today you are building a **multi-table schema** for a gym called **FitBase**. The gym has trainers, members, classes, and bookings.

Run the SQL below in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 6 SETUP: FitBase Gym Schema
-- ============================================
-- Multi-table schema with constraints for learning
-- PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT

-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS trainers;

-- Also clean up exercise tables from previous runs
DROP TABLE IF EXISTS novapay_transactions;
DROP TABLE IF EXISTS novapay_merchants;
DROP TABLE IF EXISTS novapay_employees;

-- ============================================
-- TABLE 1: trainers
-- ============================================
-- Demonstrates: PRIMARY KEY, NOT NULL, SERIAL

CREATE TABLE trainers (
    trainer_id   SERIAL       PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    speciality   VARCHAR(30)  NOT NULL
);

INSERT INTO trainers (name, speciality)
VALUES
    ('Ryan Cooper',   'Strength'),
    ('Priya Sharma',  'Yoga'),
    ('Kofi Mensah',   'HIIT');

-- ============================================
-- TABLE 2: members
-- ============================================
-- Demonstrates: PRIMARY KEY, NOT NULL, UNIQUE, CHECK, DEFAULT, nullable column (phone)

CREATE TABLE members (
    member_id       SERIAL       PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    membership_type VARCHAR(20)  NOT NULL DEFAULT 'standard'
                    CHECK (membership_type IN ('student', 'standard', 'premium'))
);

INSERT INTO members (name, email, membership_type)
VALUES
    ('Sophie Ward',   'sophie@mail.com',  'premium'),
    ('Mei Lin',       'mei@mail.com',     'standard'),
    ('Dan Foster',    'dan@mail.com',     'standard'),
    ('Aisha Obi',     'aisha@mail.com',   'premium'),
    ('Liam Brooks',   'liam@mail.com',    'student');

-- ============================================
-- TABLE 3: classes
-- ============================================
-- Demonstrates: PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK (BETWEEN and IN)

CREATE TABLE classes (
    class_id    SERIAL       PRIMARY KEY,
    class_name  VARCHAR(100) NOT NULL,
    trainer_id  INTEGER      NOT NULL
                REFERENCES trainers(trainer_id),
    capacity    INTEGER      NOT NULL CHECK (capacity BETWEEN 5 AND 30),
    difficulty  VARCHAR(20)  NOT NULL
                CHECK (difficulty IN ('beginner', 'intermediate', 'advanced'))
);

INSERT INTO classes (class_name, trainer_id, capacity, difficulty)
VALUES
    ('Morning HIIT',   3, 20, 'advanced'),
    ('Power Yoga',     2, 15, 'intermediate'),
    ('Barbell Basics', 1, 12, 'beginner'),
    ('Evening Spin',   3, 25, 'intermediate');

-- ============================================
-- TABLE 4: bookings (composite primary key)
-- ============================================
-- Demonstrates: Composite PRIMARY KEY, FOREIGN KEY, DEFAULT (timestamp)
-- NOTE: This table is created WITHOUT CASCADE initially.
-- The teleprompter drops and recreates it WITH CASCADE later in section 8.

CREATE TABLE bookings (
    member_id   INTEGER   NOT NULL
                REFERENCES members(member_id),
    class_id    INTEGER   NOT NULL
                REFERENCES classes(class_id),
    booked_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (member_id, class_id)
);

INSERT INTO bookings (member_id, class_id)
VALUES
    (1, 1),
    (1, 3),
    (2, 2),
    (4, 1),
    (3, 4);
```

</details>

### Verify Your Setup

```sql
SELECT 'trainers' AS table_name, COUNT(*) AS rows FROM trainers
UNION ALL
SELECT 'members', COUNT(*) FROM members
UNION ALL
SELECT 'classes', COUNT(*) FROM classes
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings;
```

Expected output:

| table_name | rows |
|------------|------|
| trainers   | 3    |
| members    | 5    |
| classes    | 4    |
| bookings   | 5    |

## Exercises

You are a data engineer at a UK-based fintech startup called **NovaPay**. They process payments for online merchants. The company is growing fast - 150 merchants, tens of thousands of transactions per month, and a team of 40 people.

The problem? The current database has no constraints. Tables were created quickly during the MVP phase, and now the data quality problems are piling up: duplicate merchant records causing double billing, transactions referencing merchants that were deleted months ago, negative transaction amounts in financial reports, and employees with no department assignment breaking the org chart dashboard.

The Head of Engineering has asked you to redesign the schema with proper constraints.

Using the concepts from today's lesson, complete these tasks:

### Warm-Up

**Q1:** Create a `novapay_merchants` table with: `merchant_id` as an auto-incrementing primary key, `merchant_name` (required, max 100 characters), `contact_email` (required and unique), `category` (must be one of 'retail', 'hospitality', 'saas', or 'marketplace'), `monthly_volume_limit` (must be greater than zero), `onboarded_date` (defaults to today), and `is_active` (defaults to TRUE).

**Q2:** Insert two valid merchants into your `novapay_merchants` table - one with category 'retail' and one with category 'saas'. Then SELECT all rows to confirm they were inserted correctly.

### Practice

**Q3:** Create a `novapay_transactions` table with a foreign key linking to merchants, a CHECK constraint ensuring the amount is greater than zero, currency restricted to 'GBP', 'EUR', or 'USD', status restricted to 'pending', 'completed', 'failed', or 'refunded', and ON DELETE CASCADE.

**Q4:** Create a `novapay_employees` table with CHECK constraints on department (must be 'engineering', 'operations', 'compliance', or 'sales'), role level (must be 'junior', 'mid', 'senior', 'lead', or 'head'), and salary (must be between 25,000 and 250,000). Include a required `start_date` with no default.

**Q5:** Test your constraints by attempting these inserts. Each one should fail - verify that the database rejects them and understand why:
- Insert a merchant with a duplicate email
- Insert a merchant with category 'crypto'
- Insert a transaction with a negative amount
- Insert a transaction referencing a non-existent merchant (merchant_id 999)

### Challenge

**Q6:** Delete a merchant that has transactions and verify that the CASCADE action automatically removes all their associated transactions. Count the transactions before and after the delete to prove it worked.

**Q7:** NovaPay's compliance team wants a single ALTER TABLE statement that adds a UNIQUE constraint on the combination of `merchant_id` and `currency` in the `novapay_transactions` table - so that each merchant can only have one pending transaction per currency at a time. Write the ALTER TABLE statement. Then test it by inserting two transactions with the same merchant and currency to confirm the constraint rejects the duplicate.

## Key Concepts Covered
- **PRIMARY KEY**: Uniquely identifies every row - no duplicates, no NULLs, and SERIAL handles auto-incrementing
- **FOREIGN KEY**: Links tables and prevents orphan records - every reference must point to a real parent row
- **NOT NULL, UNIQUE, CHECK, DEFAULT**: Each solves a specific data quality problem - missing values, duplicates, invalid entries, and verbose inserts
- **Composite keys**: Primary keys made of multiple columns, commonly used in junction tables for many-to-many relationships
- **CASCADE, SET NULL, RESTRICT**: Control what happens when referenced data is deleted - delete children, preserve children, or block the operation entirely

---

[← Day 5: INSERT, UPDATE & DELETE](../day-05/) | [Day 7: Project: Freight & Logistics →](../day-07/)
