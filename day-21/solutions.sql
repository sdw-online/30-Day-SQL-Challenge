-- ============================================================
-- DAY 21 SOLUTIONS: Project - Recruitment Analytics
-- ============================================================
-- You are Julian Marsden's analyst. An applicant tracking system has dumped
-- three raw tables into the database and you are turning them into something
-- the business can actually query.
--
-- The pipeline has three layers:
--   RAW    (bronze) - landed as-is, never cleaned. Provided by exercise.sql.
--   SILVER (3NF)    - audited, cleaned, deduped, normalised. You build it.
--   GOLD   (star)   - denormalised for analytics. You build it.
--
-- Run exercise.sql first to land the raw layer, then work through the phases
-- below in order. Each phase depends on the one before it.


-- ============================================================
-- PHASE 1: AUDIT THE RAW LAYER
-- ============================================================
-- Auditing is not exploring. Exploring looks for insights; auditing looks for
-- issues. We audit the raw layer but we never clean it - the landed extract
-- stays faithful to the source so we can always re-derive from it.


-- ------------------------------------------------------------
-- Problem 1: a list crammed into one cell
-- ------------------------------------------------------------
-- First look at the postings. required_skills holds several skills in a single
-- cell, separated by semicolons. That is a first normal form violation.
SELECT
    job_id,
    department,
    cost_centre,
    required_skills
FROM raw_job_postings
LIMIT 8;

-- How bad is it? Split the cell on the semicolon and measure the longest list.
-- Answer: 8 skills in a single cell.
SELECT
    MAX(ARRAY_LENGTH(STRING_TO_ARRAY(required_skills, ';'), 1)) AS max_no_of_skills_found_in_a_cell
FROM raw_job_postings;


-- ------------------------------------------------------------
-- Problem 2: department and cost centre repeat on every row
-- ------------------------------------------------------------
-- cost_centre depends on the department, not on the job. That is a transitive
-- dependency, and it is why departments becomes its own table in the silver
-- layer. Once the casing is cleaned up there are only 3 real pairs.
SELECT
    COUNT(DISTINCT
        (LOWER(TRIM(department)),
         LOWER(TRIM(cost_centre)))) AS no_of_unique_dept_cost_centre_pairs
FROM raw_job_postings;


-- ------------------------------------------------------------
-- Problem 3: candidate details repeat on every application
-- ------------------------------------------------------------
-- candidate_name and source_channel describe the candidate, not the
-- application, so they repeat on every row that person ever filed.
SELECT
    candidate_name,
    candidate_email,
    COUNT(*) AS no_of_applications_made
FROM raw_applications
GROUP BY 1, 2
HAVING COUNT(*) > 1
ORDER BY 3 DESC;

-- Quantify the repetition: how many rows describe a candidate we have already
-- seen? Answer: 6,047 rows.
SELECT
    COUNT(*) FILTER (WHERE candidate_email IS NOT NULL) - COUNT(DISTINCT candidate_email) AS no_of_repeated_rows
FROM raw_applications;


-- ------------------------------------------------------------
-- Problem 4: one department, typed a dozen ways
-- ------------------------------------------------------------
-- There should be 3 departments. There are 18 spellings of them.
SELECT
    COUNT(DISTINCT department) AS no_of_distinct_department_values
FROM raw_job_postings;

-- Look at what they actually are - Engineering, engineering, ENGINEERING, and
-- a leading space on Analytics. The same three departments, typed sloppily.
SELECT
    department,
    COUNT(*) AS postings
FROM raw_job_postings
GROUP BY department
ORDER BY department;


-- ------------------------------------------------------------
-- Problem 5: skill names that do not match the taxonomy
-- ------------------------------------------------------------
-- A taxonomy is the official list of names - the only spellings that count.
-- Ours is the 60 rows in raw_skills. Anything not on that list is a typo, not
-- a new skill.
SELECT *
FROM raw_skills;

-- How many odd spellings are in the postings? Answer: 28.
SELECT
    COUNT(*) AS no_of_odd_skills
FROM
    (SELECT DISTINCT TRIM(skill)
     FROM raw_job_postings,
          STRING_TO_TABLE(required_skills, ';') AS skill
     WHERE TRIM(skill) NOT IN (SELECT skill_name
                               FROM raw_skills)) AS odd;

-- And what are they? Mostly padding and casing, plus one real abbreviation -
-- ML, which means Machine Learning.
SELECT DISTINCT
    TRIM(skill) AS odd_skill
FROM raw_job_postings,
     STRING_TO_TABLE(required_skills, ';') AS skill
WHERE TRIM(skill) NOT IN (SELECT skill_name FROM raw_skills);


-- ------------------------------------------------------------
-- Problem 6: applications with no email
-- ------------------------------------------------------------
-- 1,691 rows. If we cannot see an email we cannot tell who the person is, so
-- these rows can never become candidates.
SELECT
    COUNT(*) AS no_of_applications_with_no_email
FROM raw_applications
WHERE candidate_email IS NULL;


-- ------------------------------------------------------------
-- Problem 7: the same person applied twice
-- ------------------------------------------------------------
-- 740 candidate-and-job pairs appear more than once. Note the NOT NULL filter:
-- without it every null-email row collapses into one group and inflates the
-- count. This counts pairs, not surplus rows.
SELECT
    COUNT(*) AS no_of_duplicate_person_job_pairs
FROM
    (SELECT candidate_email, job_id
     FROM raw_applications
     WHERE candidate_email IS NOT NULL
     GROUP BY 1, 2
     HAVING COUNT(*) > 1) AS dupes;

-- Confirm it by looking at the pairs themselves.
SELECT
    candidate_email,
    job_id,
    COUNT(*) AS times
FROM raw_applications
WHERE candidate_email IS NOT NULL
GROUP BY candidate_email, job_id
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- Problem 8: decisions dated before the application
-- ------------------------------------------------------------
-- 1,223 rows where a decision was recorded before the person applied. That is
-- not possible, so the decided_date is the value we cannot trust.
SELECT
    COUNT(*) AS no_of_impossible_dates
FROM raw_applications
WHERE decided_date < applied_date;


-- ------------------------------------------------------------
-- Problem 9: applications pointing at jobs that do not exist
-- ------------------------------------------------------------
-- 843 orphans - rows whose job_id is not in the postings at all.
SELECT
    COUNT(*) AS no_of_orphan_records
FROM raw_applications a
WHERE NOT EXISTS (SELECT 1
                  FROM raw_job_postings j
                  WHERE j.job_id = a.job_id);

-- What do the orphans look like? Every one carries the same sentinel job_id,
-- 9999 - a value the source system writes on purpose when the real job is gone.
SELECT *
FROM raw_applications a
LEFT JOIN raw_job_postings j
    ON a.job_id = j.job_id
WHERE j.job_id IS NULL;


-- ============================================================
-- PHASE 2: DESIGN THE MODEL
-- ============================================================
-- No SQL in this phase. You sketch the model before you build it, because the
-- SQL in Phase 3 and Phase 4 is only the drawing typed out.
--
-- The decisions you are making:
--   * Fact or dimension? An application is the measurable event, so it is the
--     fact. Jobs, candidates and skills describe it, so they are dimensions.
--   * Grain. One row per application. Everything else follows from that.
--   * Cardinality. One department has many jobs. One job has zero or many
--     applications - a role posted this morning has none yet. One candidate has
--     many applications. Jobs and skills are many-to-many in BOTH directions,
--     and that is the pair that needs a bridge.
--   * Denormalise or snowflake? The star folds department back into dim_job as
--     text. Snowflaking would keep departments as its own table hanging off the
--     dimension. We fold, because BI tools pay for every extra join.


-- ============================================================
-- PHASE 3: CLEAN AND NORMALISE - THE SILVER LAYER (3NF)
-- ============================================================
-- Every issue found in Phase 1 is fixed here, as part of building the table it
-- belongs to. We never go back and edit the raw layer.


-- ------------------------------------------------------------
-- 3.1 departments - standardise the casing, lift out the transitive dependency
-- ------------------------------------------------------------
-- Build the SELECT first and watch it shrink. Raw gives 18 departments.
SELECT DISTINCT
    department,
    cost_centre
FROM raw_job_postings;

-- TRIM strips the leading and trailing spaces.
SELECT DISTINCT
    TRIM(department),
    cost_centre
FROM raw_job_postings;

-- INITCAP puts them all into the same casing. Now there are 3.
SELECT DISTINCT
    INITCAP(TRIM(department)),
    cost_centre
FROM raw_job_postings;

CREATE TABLE IF NOT EXISTS departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(40) UNIQUE NOT NULL,
    cost_centre     VARCHAR(20) NOT NULL
);

-- ORDER BY 1, 2 matters. SERIAL hands out ids in the order the rows arrive, so
-- without it the department_ids would shuffle every time you rebuilt the table.
INSERT INTO departments (department_name, cost_centre)
SELECT DISTINCT INITCAP(TRIM(department)), cost_centre
FROM raw_job_postings
ORDER BY 1, 2;

-- Expected: 3 rows.
SELECT * FROM departments;


-- ------------------------------------------------------------
-- 3.2 skills - the taxonomy, lifted as it is
-- ------------------------------------------------------------
-- raw_skills is reference data and it is already clean, so this one is a copy
-- with a surrogate key bolted on.
SELECT skill_name, skill_category
FROM raw_skills;

CREATE TABLE IF NOT EXISTS skills (
    skill_id       SERIAL PRIMARY KEY,
    skill_name     VARCHAR(40) UNIQUE NOT NULL,
    skill_category VARCHAR(30) NOT NULL
);

INSERT INTO skills (skill_name, skill_category)
SELECT skill_name, skill_category
FROM raw_skills;

-- Expected: 60 rows.
SELECT COUNT(*) AS skills_loaded FROM skills;


-- ------------------------------------------------------------
-- 3.3 jobs - one row per posting, department replaced by its key
-- ------------------------------------------------------------
SELECT
    job_id,
    title,
    department,
    location,
    seniority
FROM raw_job_postings;

-- Join on the CLEANED department name, not the raw one. INITCAP(TRIM(...)) is
-- exactly what went into departments, so the dirty spellings still resolve.
SELECT r.job_id,
       r.title AS job_title,
       d.department_id,
       r.location,
       r.seniority,
       r.posted_date,
       r.salary_budget_min,
       r.salary_budget_max
FROM raw_job_postings r
INNER JOIN departments d
    ON INITCAP(TRIM(r.department)) = d.department_name;

CREATE TABLE IF NOT EXISTS jobs (
    job_id            INTEGER PRIMARY KEY,
    job_title         VARCHAR(60) NOT NULL,
    department_id     INTEGER NOT NULL REFERENCES departments(department_id),
    location          VARCHAR(40) NOT NULL,
    seniority         VARCHAR(20) NOT NULL,
    posted_date       DATE NOT NULL,
    salary_budget_min INTEGER NOT NULL,
    salary_budget_max INTEGER NOT NULL
);

INSERT INTO jobs
SELECT r.job_id,
       r.title AS job_title,
       d.department_id, r.location, r.seniority,
       r.posted_date, r.salary_budget_min, r.salary_budget_max
FROM raw_job_postings r
INNER JOIN departments d ON INITCAP(TRIM(r.department)) = d.department_name;

-- Expected: 500 rows. Nothing was dropped - every posting matched a department.
SELECT COUNT(*) AS jobs_loaded FROM jobs;


-- ------------------------------------------------------------
-- 3.4 job_skills - the 1NF split, and the whole point of the project
-- ------------------------------------------------------------
-- This is where the many-to-many comes out of hiding. The semicolon cell goes
-- in, one row per job-and-skill pair comes out.
SELECT
    job_id,
    required_skills
FROM raw_job_postings;

-- STRING_TO_TABLE explodes the cell into rows. TRIM cleans the padding.
SELECT
    r.job_id,
    TRIM(raw_skill) AS skill
FROM raw_job_postings r,
     STRING_TO_TABLE(r.required_skills, ';') AS raw_skill;

-- Match each token to the taxonomy. LOWER on both sides makes the join
-- case-insensitive, so python and Python both land on the same skill_id.
SELECT r.job_id, s.skill_id
FROM raw_job_postings r,
     STRING_TO_TABLE(r.required_skills, ';') AS raw_skill
INNER JOIN skills s
    ON LOWER(s.skill_name) = LOWER(TRIM(raw_skill));

CREATE TABLE IF NOT EXISTS job_skills (
    job_id   INTEGER NOT NULL REFERENCES jobs(job_id),
    skill_id INTEGER NOT NULL REFERENCES skills(skill_id),
    PRIMARY KEY (job_id, skill_id)
);

-- The CASE handles the one real abbreviation. DISTINCT absorbs any within-cell
-- duplicates the mangling produced, which the composite primary key would
-- otherwise reject.
INSERT INTO job_skills
SELECT DISTINCT r.job_id, s.skill_id
FROM raw_job_postings r,
     STRING_TO_TABLE(r.required_skills, ';') AS raw_skill
INNER JOIN skills s ON LOWER(s.skill_name) = CASE LOWER(TRIM(raw_skill))
    WHEN 'ml' THEN 'machine learning'
    ELSE LOWER(TRIM(raw_skill)) END;

-- Expected: 2,210 rows.
SELECT COUNT(*) AS job_skill_pairs FROM job_skills;


-- ------------------------------------------------------------
-- 3.5 candidates - one row per person
-- ------------------------------------------------------------
SELECT
    candidate_name,
    candidate_email,
    source_channel
FROM raw_applications;

-- Drop the rows we cannot identify. No email, no person.
SELECT
    candidate_name,
    candidate_email,
    source_channel
FROM raw_applications
WHERE candidate_email IS NOT NULL;

-- DISTINCT collapses the repetition found in Problem 3.
SELECT DISTINCT
    candidate_name,
    candidate_email,
    source_channel
FROM raw_applications
WHERE candidate_email IS NOT NULL;

-- The constraints are the cleaning rules, written down. NOT NULL on all three
-- columns says a row without a name, an email or a source channel is not a
-- candidate. UNIQUE on the email says the email IS the person.
CREATE TABLE IF NOT EXISTS candidates (
    candidate_id    SERIAL PRIMARY KEY,
    candidate_name  VARCHAR(60) NOT NULL,
    candidate_email VARCHAR(80) UNIQUE NOT NULL,
    source_channel  VARCHAR(20) NOT NULL
);

INSERT INTO candidates (candidate_name, candidate_email, source_channel)
SELECT DISTINCT candidate_name, candidate_email, source_channel
FROM raw_applications
WHERE candidate_email IS NOT NULL;

-- Expected: 4,232 rows.
SELECT COUNT(*) AS candidates_loaded FROM candidates;


-- ------------------------------------------------------------
-- 3.6 applications - the full clean in one pass
-- ------------------------------------------------------------
SELECT
    application_id,
    job_id,
    candidate_email,
    applied_date,
    decided_date,
    outcome
FROM raw_applications;

-- Two inner joins do two jobs at once. Joining to candidates drops the
-- null-email rows; joining to jobs drops the orphans. An inner join keeps only
-- what matched, so the dirt falls out on its own.
SELECT
    a.application_id,
    a.job_id,
    c.candidate_id,
    a.applied_date,
    a.decided_date,
    a.outcome,
    a.offer_salary
FROM raw_applications a
INNER JOIN candidates c
    ON a.candidate_email = c.candidate_email
INNER JOIN jobs j
    ON a.job_id = j.job_id;

-- Blank out the impossible dates. We know the application happened, so we keep
-- the row - we just cannot trust the decision date, so it becomes NULL. A NULL
-- is honest. A wrong date is not.
SELECT
    a.application_id,
    a.job_id,
    c.candidate_id,
    a.applied_date,
    CASE WHEN a.decided_date < a.applied_date THEN NULL
         ELSE a.decided_date END AS decided_date,
    a.outcome,
    a.offer_salary
FROM raw_applications a
INNER JOIN candidates c
    ON a.candidate_email = c.candidate_email
INNER JOIN jobs j
    ON a.job_id = j.job_id;

-- DISTINCT ON keeps the first row per candidate-and-job pair, and the ORDER BY
-- decides what first means - here the lowest application_id, so the earliest
-- application wins and the duplicate the ATS logged is dropped.
SELECT DISTINCT ON (a.candidate_email, a.job_id)
       a.application_id, a.job_id, c.candidate_id, a.applied_date,
       CASE WHEN a.decided_date < a.applied_date THEN NULL ELSE a.decided_date END AS decided_date,
       a.outcome, a.offer_salary
FROM raw_applications a
INNER JOIN candidates c
    ON a.candidate_email = c.candidate_email
INNER JOIN jobs j
    ON a.job_id = j.job_id
ORDER BY
    a.candidate_email,
    a.job_id,
    a.application_id;

-- days_to_decision is NOT stored here. It is derived from two columns we
-- already have, and 3NF does not store what it can calculate.
CREATE TABLE IF NOT EXISTS applications (
    application_id INTEGER PRIMARY KEY,
    job_id         INTEGER NOT NULL REFERENCES jobs(job_id),
    candidate_id   INTEGER NOT NULL REFERENCES candidates(candidate_id),
    applied_date   DATE NOT NULL,
    decided_date   DATE,
    outcome        VARCHAR(20) NOT NULL,
    offer_salary   INTEGER
);

INSERT INTO applications
SELECT DISTINCT ON (a.candidate_email, a.job_id)
       a.application_id, a.job_id, c.candidate_id, a.applied_date,
       CASE WHEN a.decided_date < a.applied_date THEN NULL ELSE a.decided_date END,
       a.outcome, a.offer_salary
FROM raw_applications a
INNER JOIN candidates c ON a.candidate_email = c.candidate_email
INNER JOIN jobs       j ON a.job_id = j.job_id
ORDER BY a.candidate_email, a.job_id, a.application_id;

-- Expected: 8,801 rows, down from 11,970 in raw. The gap is the dirt.
SELECT COUNT(*) AS applications_loaded FROM applications;


-- ============================================================
-- PHASE 4: DENORMALISE - THE GOLD LAYER (STAR SCHEMA)
-- ============================================================
-- Silver is modelled for integrity. Gold is modelled for reading. The same
-- data, shaped the other way: fewer joins, wider dimensions, measures
-- precomputed.


-- ------------------------------------------------------------
-- 4.1 dim_job - department folded back in
-- ------------------------------------------------------------
SELECT
    job_id,
    job_title,
    department_id
FROM jobs;

-- Join back to departments and bring the NAME across instead of the key. This
-- is the denormalisation: silver pulled department out, gold puts it back.
SELECT
    j.job_id,
    j.job_title,
    d.department_name,
    d.cost_centre,
    j.location,
    j.seniority,
    j.salary_budget_min,
    j.salary_budget_max
FROM jobs j
INNER JOIN departments d
    ON j.department_id = d.department_id;

-- Two naming points. The column is department, not department_name - in silver
-- it was the name of a row in another table, in gold it is simply an attribute
-- of the job. And the primary key is still job_id: the id is carried straight
-- across from silver, so there is no new warehouse-generated key to name here.
CREATE TABLE IF NOT EXISTS dim_job (
    job_id            INTEGER PRIMARY KEY,
    job_title         VARCHAR(60) NOT NULL,
    department        VARCHAR(40) NOT NULL,
    cost_centre       VARCHAR(20) NOT NULL,
    location          VARCHAR(40) NOT NULL,
    seniority         VARCHAR(20) NOT NULL,
    salary_budget_min INTEGER NOT NULL,
    salary_budget_max INTEGER NOT NULL
);

INSERT INTO dim_job
SELECT j.job_id, j.job_title, d.department_name, d.cost_centre,
       j.location, j.seniority, j.salary_budget_min, j.salary_budget_max
FROM jobs j
INNER JOIN departments d ON j.department_id = d.department_id;

-- Expected: 500 rows.
SELECT COUNT(*) AS dim_job_rows FROM dim_job;


-- ------------------------------------------------------------
-- 4.2 dim_skill
-- ------------------------------------------------------------
SELECT
    skill_id,
    skill_name,
    skill_category
FROM skills;

CREATE TABLE IF NOT EXISTS dim_skill (
    skill_id       INTEGER PRIMARY KEY,
    skill_name     VARCHAR(40) NOT NULL,
    skill_category VARCHAR(30) NOT NULL
);

INSERT INTO dim_skill
SELECT skill_id, skill_name, skill_category
FROM skills;

-- Expected: 60 rows.
SELECT COUNT(*) AS dim_skill_rows FROM dim_skill;


-- ------------------------------------------------------------
-- 4.3 dim_candidate - the email stays behind
-- ------------------------------------------------------------
SELECT
    candidate_id,
    candidate_name,
    candidate_email,
    source_channel
FROM candidates;

-- candidate_email is deliberately NOT carried into the star. It identified the
-- person in silver; nobody analyses hiring by email address.
CREATE TABLE IF NOT EXISTS dim_candidate (
    candidate_id   INTEGER PRIMARY KEY,
    candidate_name VARCHAR(60) NOT NULL,
    source_channel VARCHAR(20) NOT NULL
);

INSERT INTO dim_candidate
SELECT candidate_id, candidate_name, source_channel
FROM candidates;

-- Expected: 4,232 rows.
SELECT COUNT(*) AS dim_candidate_rows FROM dim_candidate;


-- ------------------------------------------------------------
-- 4.4 bridge_job_skill - the junction, carried forward
-- ------------------------------------------------------------
SELECT
    job_id,
    skill_id
FROM job_skills;

-- The bridge is not invented at the star. It is the silver junction, pointed at
-- the two dimensions instead of the two silver tables. Two keys and no measures
-- - a bridge carries nothing but the relationship it resolves.
CREATE TABLE IF NOT EXISTS bridge_job_skill (
    job_id   INTEGER NOT NULL REFERENCES dim_job(job_id),
    skill_id INTEGER NOT NULL REFERENCES dim_skill(skill_id),
    PRIMARY KEY (job_id, skill_id)
);

INSERT INTO bridge_job_skill
SELECT job_id, skill_id
FROM job_skills;

-- Expected: 2,210 rows.
SELECT COUNT(*) AS bridge_rows FROM bridge_job_skill;


-- ------------------------------------------------------------
-- 4.5 fact_applications - the measurable event
-- ------------------------------------------------------------
SELECT
    application_id,
    job_id,
    candidate_id,
    applied_date,
    decided_date,
    outcome,
    offer_salary
FROM applications;

-- Precompute the measure. Silver refused to store this because it is derived.
-- Gold stores it precisely because otherwise every analyst recalculates it on
-- every query.
SELECT
    application_id,
    applied_date,
    decided_date,
    (decided_date - applied_date) AS days_to_decision
FROM applications;

-- outcome is a degenerate dimension - a descriptive attribute that lives on the
-- fact because it has no other attributes worth a table of its own.
CREATE TABLE IF NOT EXISTS fact_applications (
    application_id   INTEGER PRIMARY KEY,
    job_id           INTEGER NOT NULL REFERENCES dim_job(job_id),
    candidate_id     INTEGER NOT NULL REFERENCES dim_candidate(candidate_id),
    applied_date     DATE NOT NULL,
    decided_date     DATE,
    days_to_decision INTEGER,
    outcome          VARCHAR(20) NOT NULL,
    offer_salary     INTEGER
);

INSERT INTO fact_applications
SELECT application_id, job_id, candidate_id, applied_date, decided_date,
       (decided_date - applied_date) AS days_to_decision,
       outcome, offer_salary
FROM applications;

-- Expected: 8,801 rows, 2,431 of them with a NULL days_to_decision - the
-- applications still in progress plus the impossible dates blanked in Phase 3.
SELECT
    COUNT(*)                                         AS fact_rows,
    COUNT(*) FILTER (WHERE days_to_decision IS NULL) AS undecided_or_blanked
FROM fact_applications;


-- ============================================================
-- PHASE 5: ANSWER JULIAN'S QUESTIONS
-- ============================================================


-- ------------------------------------------------------------
-- 5.1 Which skills are we really hiring for?
-- ------------------------------------------------------------
-- You cannot answer this from dim_job, because skills are not columns on a job.
-- The bridge is the only route. COUNT(DISTINCT job_id) counts roles, not rows.
--
-- Expected: SQL 476, Python 317, Excel 154, Airflow 120, Power BI 106, AWS 90.
-- SQL is in 476 of 500 roles - 95% of everything we hire for. So the question
-- is not SQL or Python: SQL is the baseline, Python is the specialist split.
SELECT
    s.skill_name,
    COUNT(DISTINCT b.job_id) AS roles_requiring
FROM bridge_job_skill b
INNER JOIN dim_skill s
    ON b.skill_id = s.skill_id
GROUP BY s.skill_name
ORDER BY roles_requiring DESC
LIMIT 6;


-- ------------------------------------------------------------
-- 5.2 Which skills is nobody hiring for?
-- ------------------------------------------------------------
-- The anti-join from Day 15. LEFT JOIN keeps every skill whether it matched or
-- not; the IS NULL then keeps only the ones that found no match. A plain INNER
-- JOIN here would make these eight vanish silently, and Julian would never know
-- he has skills on the books that no current role wants.
--
-- Expected 8 rows: Elasticsearch, Flink, GraphQL, Great Expectations, Hadoop,
-- Hive, Qlik, REST APIs.
SELECT s.skill_name
FROM dim_skill s
LEFT JOIN bridge_job_skill b
    ON s.skill_id = b.skill_id
WHERE b.skill_id IS NULL
ORDER BY s.skill_name;


-- ------------------------------------------------------------
-- 5.3 Why does Data Science cost the most?
-- ------------------------------------------------------------
-- The plain star: the fact joined to one dimension, no bridge in sight. This is
-- what the whole pipeline was for. A two-table join answers a question the raw
-- export could not answer at all.
--
-- Expected: Data Science 58 hires, 44 days, 91,267. Engineering 98 hires,
-- 41 days, 85,561. Analytics 146 hires, 30 days, 50,555. The hunch was right -
-- Data Science costs more AND takes longer.
SELECT
    j.department,
    COUNT(*) AS hires,
    ROUND(AVG(f.days_to_decision)) AS avg_days,
    ROUND(AVG(f.offer_salary)) AS avg_offer
FROM fact_applications f
INNER JOIN dim_job j
    ON f.job_id = j.job_id
WHERE f.outcome = 'Hired'
GROUP BY j.department
ORDER BY avg_offer DESC;
