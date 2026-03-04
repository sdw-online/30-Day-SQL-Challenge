# Day 28 - EXPLAIN & Indexing

[Watch the video](COMING_SOON) | [← Day 27: CREATE FUNCTION (UDFs)](../day-27/) | [Day 29: PostgreSQL Pro Tips & Shortcuts →](../day-29/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to use EXPLAIN and EXPLAIN ANALYSE to read PostgreSQL query execution plans
- The difference between Seq Scan, Index Scan, and Index Only Scan
- How to create B-tree, hash, GIN, and composite indexes
- Anti-patterns that silently break index usage (functions on columns, type mismatches, SELECT *, leading wildcards)
- When NOT to create indexes and why foreign key columns should always be indexed

## Prerequisites
- Complete Day 27
- PostgreSQL 15 or later recommended (`SELECT version();` to check)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS search_logs;
DROP TABLE IF EXISTS watch_events;
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS subscribers;
DROP TABLE IF EXISTS genres;

-- TABLE 1: genres
CREATE TABLE genres (
    genre_id    SERIAL PRIMARY KEY,
    genre_name  VARCHAR(40)  NOT NULL UNIQUE
);

-- TABLE 2: content
CREATE TABLE content (
    content_id      SERIAL PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    genre_id        INTEGER         NOT NULL REFERENCES genres(genre_id),
    content_type    VARCHAR(10)     NOT NULL CHECK (content_type IN ('Film', 'Series')),
    release_date    DATE            NOT NULL,
    rating          NUMERIC(3,1)    NOT NULL CHECK (rating BETWEEN 1.0 AND 10.0),
    duration_mins   INTEGER         NOT NULL,
    description     TEXT
);

-- TABLE 3: subscribers
CREATE TABLE subscribers (
    subscriber_id   SERIAL PRIMARY KEY,
    email           VARCHAR(200)    NOT NULL,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    plan_type       VARCHAR(20)     NOT NULL CHECK (plan_type IN ('Free', 'Basic', 'Standard', 'Premium')),
    signup_date     DATE            NOT NULL,
    region          VARCHAR(60)     NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 4: watch_events
CREATE TABLE watch_events (
    event_id            SERIAL PRIMARY KEY,
    subscriber_id       INTEGER         NOT NULL REFERENCES subscribers(subscriber_id),
    content_id          INTEGER         NOT NULL REFERENCES content(content_id),
    watch_date          DATE            NOT NULL,
    watch_timestamp     TIMESTAMP       NOT NULL,
    duration_watched    INTEGER         NOT NULL,
    completion_pct      NUMERIC(5,2)    NOT NULL CHECK (completion_pct BETWEEN 0 AND 100),
    device_type         VARCHAR(20)     NOT NULL CHECK (device_type IN ('Mobile', 'Tablet', 'Desktop', 'Smart TV', 'Console'))
);

-- TABLE 5: search_logs
CREATE TABLE search_logs (
    search_id       SERIAL PRIMARY KEY,
    subscriber_id   INTEGER         NOT NULL REFERENCES subscribers(subscriber_id),
    search_term     VARCHAR(200)    NOT NULL,
    search_timestamp TIMESTAMP      NOT NULL,
    results_count   INTEGER         NOT NULL DEFAULT 0
);
```

</details>

**Important:** This day requires a Python script to generate the content, subscribers, watch events, and search logs data (800 + 2,000 + 25,000 + 8,000 rows). See the video or the setup guide for the full `day_28_seed.py` script. The large dataset is essential - you need enough rows to see real differences between sequential scans and index scans in EXPLAIN output.

### Verify Your Setup

```sql
SELECT COUNT(*) FROM genres;
-- Expected: 12 rows

SELECT COUNT(*) FROM content;
-- Expected: 800 rows

SELECT COUNT(*) FROM subscribers;
-- Expected: 2,000 rows

SELECT COUNT(*) FROM watch_events;
-- Expected: 25,000 rows

SELECT COUNT(*) FROM search_logs;
-- Expected: 8,000 rows
```

## Exercises

You are a data engineer at Helios Streaming, a growing UK-based video streaming platform. Dashboard queries that used to return in milliseconds are now taking seconds as the platform has grown. Your manager Callum sends you a message on Monday morning:

> "The five slowest queries on the dashboard need fixing before Friday. Diagnose each one, create the right index, and prove the improvement with before-and-after numbers."

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Run `EXPLAIN SELECT * FROM watch_events WHERE subscriber_id = 42;` (without ANALYSE). What type of scan does PostgreSQL plan to use? What is the estimated cost and estimated row count?

**Q2:** Now run `EXPLAIN ANALYSE SELECT * FROM watch_events WHERE subscriber_id = 42;`. How many rows were actually scanned, and how many were kept? What does "Rows Removed by Filter" tell you about the efficiency of this query?

### 🟡 Practice

**Q3:** Create an index on `watch_events.subscriber_id` and re-run the same EXPLAIN ANALYSE from Q2. What type of scan does PostgreSQL use now? How does the actual execution time compare to the unindexed version?

**Q4:** The "Continue Watching" feature runs this query: `SELECT w.watch_date, c.title, w.completion_pct FROM watch_events w JOIN content c ON w.content_id = c.content_id WHERE w.subscriber_id = 150 ORDER BY w.watch_date DESC LIMIT 20;`. Create a composite index that eliminates both the sequential scan and the sort step in a single index. Prove it with EXPLAIN ANALYSE.

**Q5:** The content team joins `watch_events` to `content` on `content_id` - a foreign key column. Check whether an index exists on this column. If not, create one and explain why foreign key columns should always be indexed.

### 🔴 Challenge

**Q6:** The BI team wrote this query: `SELECT * FROM subscribers WHERE EXTRACT(YEAR FROM signup_date) = 2025;`. Create an index on `signup_date`, then run EXPLAIN ANALYSE. Does PostgreSQL use the index? Explain why not, then rewrite the WHERE clause so that it can use the index. Show the before-and-after plans.

**Q7:** Create a partial index on `watch_events` that only covers rows where `completion_pct >= 90` (completed views). Then write a query that benefits from this index and prove with EXPLAIN ANALYSE that PostgreSQL uses it. Explain when partial indexes are more efficient than full indexes.

## Key Concepts Covered
- **EXPLAIN vs EXPLAIN ANALYSE:** EXPLAIN shows the estimated plan; EXPLAIN ANALYSE actually runs the query and shows real execution times alongside the estimates
- **Plan nodes:** Seq Scan (full table read), Index Scan (shortcut via index), Index Only Scan (answered entirely from the index), Hash Join, Nested Loop, Merge Join
- **B-tree indexes:** The default and most versatile type - covers equality, ranges, sorting, and prefix LIKE matching
- **Composite indexes and the leftmost prefix rule:** A composite index on (A, B, C) helps queries on A, A+B, or A+B+C, but not B alone or C alone
- **Anti-patterns:** Wrapping indexed columns in functions, type mismatches, SELECT *, and leading wildcards all silently bypass indexes
- **Foreign key indexes:** PostgreSQL does NOT create indexes on foreign key columns automatically - always add them yourself

---

[← Day 27: CREATE FUNCTION (UDFs)](../day-27/) | [Day 29: PostgreSQL Pro Tips & Shortcuts →](../day-29/)
