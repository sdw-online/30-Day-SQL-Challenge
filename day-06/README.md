# Day 6 - PRIMARY KEY, FOREIGN KEY & Constraints

[Watch the video](COMING_SOON) | [← Day 5: INSERT, UPDATE & DELETE](../day-05/) | [Day 7: Project - Freight & Logistics Performance Report →](../day-07/)

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

Today you are building a **multi-table schema** for an online music streaming platform called **TuneVault**. This is a UK-based service with subscribers, artists, albums, tracks, and playlists.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS playlist_tracks;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS streams;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS subscribers;

-- TABLE 1: subscribers
CREATE TABLE subscribers (
    subscriber_id   SERIAL          PRIMARY KEY,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    plan            VARCHAR(20)     NOT NULL DEFAULT 'free'
                                    CHECK (plan IN ('free', 'premium', 'family')),
    signup_date     DATE            NOT NULL DEFAULT CURRENT_DATE,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    country         VARCHAR(50)     NOT NULL DEFAULT 'United Kingdom'
);

-- TABLE 2: artists
CREATE TABLE artists (
    artist_id       SERIAL          PRIMARY KEY,
    artist_name     VARCHAR(100)    NOT NULL UNIQUE,
    genre           VARCHAR(50)     NOT NULL,
    country         VARCHAR(50)     NOT NULL,
    formed_year     INTEGER         CHECK (formed_year >= 1900 AND formed_year <= 2025),
    is_verified     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 3: albums
CREATE TABLE albums (
    album_id        SERIAL          PRIMARY KEY,
    album_title     VARCHAR(200)    NOT NULL,
    artist_id       INTEGER         NOT NULL
                                    REFERENCES artists(artist_id)
                                    ON DELETE CASCADE,
    release_date    DATE            NOT NULL,
    total_tracks    INTEGER         NOT NULL CHECK (total_tracks > 0),
    UNIQUE (artist_id, album_title)
);

-- TABLE 4: tracks
CREATE TABLE tracks (
    track_id        SERIAL          PRIMARY KEY,
    track_title     VARCHAR(200)    NOT NULL,
    album_id        INTEGER         NOT NULL
                                    REFERENCES albums(album_id)
                                    ON DELETE CASCADE,
    track_number    INTEGER         NOT NULL CHECK (track_number > 0),
    duration_secs   INTEGER         NOT NULL CHECK (duration_secs > 0 AND duration_secs < 7200),
    is_explicit     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 5: streams
CREATE TABLE streams (
    stream_id       SERIAL          PRIMARY KEY,
    subscriber_id   INTEGER
                    REFERENCES subscribers(subscriber_id)
                    ON DELETE SET NULL,
    track_id        INTEGER         NOT NULL
                    REFERENCES tracks(track_id)
                    ON DELETE CASCADE,
    streamed_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    duration_secs   INTEGER         NOT NULL CHECK (duration_secs >= 0)
);

-- TABLE 6: playlists
CREATE TABLE playlists (
    playlist_id     SERIAL          PRIMARY KEY,
    playlist_name   VARCHAR(100)    NOT NULL,
    subscriber_id   INTEGER         NOT NULL
                    REFERENCES subscribers(subscriber_id)
                    ON DELETE CASCADE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    is_public       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 7: playlist_tracks (junction table)
CREATE TABLE playlist_tracks (
    playlist_id     INTEGER         NOT NULL
                    REFERENCES playlists(playlist_id)
                    ON DELETE CASCADE,
    track_id        INTEGER         NOT NULL
                    REFERENCES tracks(track_id)
                    ON DELETE CASCADE,
    added_at        TIMESTAMP       NOT NULL DEFAULT NOW(),
    position        INTEGER         NOT NULL CHECK (position > 0),
    PRIMARY KEY (playlist_id, track_id)
);
```

</details>

### Generate Sample Data

This dataset uses Python with `psycopg2` and `faker` to generate realistic data across all seven tables. Install the dependencies:

```bash
pip install psycopg2-binary faker
```

Save the data generation script from the setup guide as `day_06_seed.py`, update your PostgreSQL credentials, and run it with `python day_06_seed.py`.

The script populates:
- **subscribers** (25 rows)
- **artists** (10 rows)
- **albums** (~20 rows)
- **tracks** (~60 rows)
- **streams** (200 rows)
- **playlists** (15 rows)
- **playlist_tracks** (~45 rows)

### Verify Your Setup

```sql
SELECT COUNT(*) FROM subscribers;
-- Expected: 25

SELECT COUNT(*) FROM artists;
-- Expected: 10

SELECT COUNT(*) FROM albums;
-- Expected: ~20 (varies based on random generation)

SELECT COUNT(*) FROM tracks;
-- Expected: ~60 (varies based on random generation)

SELECT COUNT(*) FROM streams;
-- Expected: 200

SELECT COUNT(*) FROM playlists;
-- Expected: 15

SELECT COUNT(*) FROM playlist_tracks;
-- Expected: ~45 (varies based on random generation)
```

## Exercises

You are a data engineer at a UK-based fintech startup called **NovaPay**. They process payments for online merchants. The company is growing fast - 150 merchants, tens of thousands of transactions per month, and a team of 40 people.

The problem? The current database has no constraints. Tables were created quickly during the MVP phase, and now the data quality problems are piling up: duplicate merchant records causing double billing, transactions referencing merchants that were deleted months ago, negative transaction amounts in financial reports, and employees with no department assignment breaking the org chart dashboard.

The Head of Engineering has asked you to redesign the schema with proper constraints.

Using the concepts from today's lesson, complete these tasks:

### 🟢 Warm-Up

**Q1:** Create a `novapay_merchants` table with: `merchant_id` as an auto-incrementing primary key, `merchant_name` (required, max 100 characters), `contact_email` (required and unique), `category` (must be one of 'retail', 'hospitality', 'saas', or 'marketplace'), `monthly_volume_limit` (must be greater than zero), `onboarded_date` (defaults to today), and `is_active` (defaults to TRUE).

**Q2:** Insert two valid merchants into your `novapay_merchants` table - one with category 'retail' and one with category 'saas'. Then SELECT all rows to confirm they were inserted correctly.

### 🟡 Practice

**Q3:** Create a `novapay_transactions` table with a foreign key linking to merchants, a CHECK constraint ensuring the amount is greater than zero, currency restricted to 'GBP', 'EUR', or 'USD', status restricted to 'pending', 'completed', 'failed', or 'refunded', and ON DELETE CASCADE.

**Q4:** Create a `novapay_employees` table with CHECK constraints on department (must be 'engineering', 'operations', 'compliance', or 'sales'), role level (must be 'junior', 'mid', 'senior', 'lead', or 'head'), and salary (must be between 25,000 and 250,000). Include a required `start_date` with no default.

**Q5:** Test your constraints by attempting these inserts. Each one should fail - verify that the database rejects them and understand why:
- Insert a merchant with a duplicate email
- Insert a merchant with category 'crypto'
- Insert a transaction with a negative amount
- Insert a transaction referencing a non-existent merchant (merchant_id 999)

### 🔴 Challenge

**Q6:** Delete a merchant that has transactions and verify that the CASCADE action automatically removes all their associated transactions. Count the transactions before and after the delete to prove it worked.

**Q7:** NovaPay's compliance team wants a single ALTER TABLE statement that adds a UNIQUE constraint on the combination of `merchant_id` and `currency` in the `novapay_transactions` table - so that each merchant can only have one pending transaction per currency at a time. Write the ALTER TABLE statement. Then test it by inserting two transactions with the same merchant and currency to confirm the constraint rejects the duplicate.

## Key Concepts Covered
- **PRIMARY KEY**: Uniquely identifies every row - no duplicates, no NULLs, and SERIAL handles auto-incrementing
- **FOREIGN KEY**: Links tables and prevents orphan records - every reference must point to a real parent row
- **NOT NULL, UNIQUE, CHECK, DEFAULT**: Each solves a specific data quality problem - missing values, duplicates, invalid entries, and verbose inserts
- **Composite keys**: Primary keys made of multiple columns, commonly used in junction tables for many-to-many relationships
- **CASCADE, SET NULL, RESTRICT**: Control what happens when referenced data is deleted - delete children, preserve children, or block the operation entirely

---

[← Day 5: INSERT, UPDATE & DELETE](../day-05/) | [Day 7: Project - Freight & Logistics Performance Report →](../day-07/)
