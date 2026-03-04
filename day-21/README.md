# Day 21 - Project: SaaS Trial-to-Paid Conversion Analysis

[Watch the video](COMING_SOON) | [← Day 20: Star Schema & Dimensional Modelling](../day-20/) | [Day 22: Window Functions Part 1 →](../day-22/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to build a complete SaaS conversion funnel analysis using JOINs, anti-joins, UNION ALL, and CTEs
- How to segment users by engagement level and correlate engagement with conversion rates
- How to calculate conversion timing, revenue analysis, and produce board-ready recommendations with SQL

## Prerequisites
- Complete Days 15-20 (JOINs Part 1 & 2, UNION/UNION ALL, normalisation, recursive CTEs, star schema)
- Comfortable with LEFT JOIN, anti-join patterns, CTEs, and aggregate functions

## Dataset

This is your **Week 3 project**. You are building a SaaS trial-to-paid conversion analysis for **ArcPlan** - a UK-based project management SaaS serving mid-market teams across Europe.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS funnel_events;
DROP TABLE IF EXISTS feature_usage;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS trials;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS plans;

-- TABLE 1: plans
CREATE TABLE plans (
    plan_id         SERIAL          PRIMARY KEY,
    plan_name       VARCHAR(50)     NOT NULL UNIQUE,
    plan_tier       VARCHAR(20)     NOT NULL
                                    CHECK (plan_tier IN ('Free', 'Starter', 'Professional', 'Enterprise')),
    monthly_price   NUMERIC(8, 2)   NOT NULL DEFAULT 0.00,
    annual_price    NUMERIC(8, 2)   NOT NULL DEFAULT 0.00,
    max_users       INTEGER         NOT NULL,
    max_projects    INTEGER         NOT NULL,
    has_api_access  BOOLEAN         NOT NULL DEFAULT FALSE,
    has_sso         BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: users
CREATE TABLE users (
    user_id         SERIAL          PRIMARY KEY,
    email           VARCHAR(200)    NOT NULL UNIQUE,
    full_name       VARCHAR(150)    NOT NULL,
    signup_date     DATE            NOT NULL,
    signup_source   VARCHAR(50)     NOT NULL
                                    CHECK (signup_source IN (
                                        'Organic Search', 'Google Ads', 'LinkedIn',
                                        'Referral', 'Product Hunt', 'Direct'
                                    )),
    company_name    VARCHAR(150),
    company_size    VARCHAR(30)
                                    CHECK (company_size IN (
                                        '1-10', '11-50', '51-200', '201-500', '500+'
                                    )),
    country         VARCHAR(50)     NOT NULL DEFAULT 'United Kingdom',
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 3: trials
CREATE TABLE trials (
    trial_id        SERIAL          PRIMARY KEY,
    user_id         INTEGER         NOT NULL UNIQUE
                                    REFERENCES users(user_id)
                                    ON DELETE RESTRICT,
    plan_id         INTEGER         NOT NULL
                                    REFERENCES plans(plan_id)
                                    ON DELETE RESTRICT,
    trial_start     DATE            NOT NULL,
    trial_end       DATE            NOT NULL,
    activated_date  DATE,
    trial_status    VARCHAR(20)     NOT NULL DEFAULT 'Active'
                                    CHECK (trial_status IN ('Active', 'Converted', 'Expired', 'Cancelled')),
    CONSTRAINT chk_trial_dates CHECK (trial_end > trial_start)
);

-- TABLE 4: feature_usage
CREATE TABLE feature_usage (
    usage_id        SERIAL          PRIMARY KEY,
    user_id         INTEGER         NOT NULL
                                    REFERENCES users(user_id)
                                    ON DELETE RESTRICT,
    feature_name    VARCHAR(80)     NOT NULL
                                    CHECK (feature_name IN (
                                        'Project Board', 'Task Assignment', 'Gantt Chart',
                                        'Time Tracking', 'API Integration', 'Team Chat',
                                        'File Sharing', 'Reporting Dashboard', 'Automations',
                                        'Custom Fields'
                                    )),
    usage_date      DATE            NOT NULL,
    usage_count     INTEGER         NOT NULL DEFAULT 1
                                    CHECK (usage_count > 0)
);

-- TABLE 5: subscriptions
CREATE TABLE subscriptions (
    subscription_id SERIAL          PRIMARY KEY,
    user_id         INTEGER         NOT NULL
                                    REFERENCES users(user_id)
                                    ON DELETE RESTRICT,
    plan_id         INTEGER         NOT NULL
                                    REFERENCES plans(plan_id)
                                    ON DELETE RESTRICT,
    start_date      DATE            NOT NULL,
    cancelled_date  DATE,
    billing_cycle   VARCHAR(10)     NOT NULL
                                    CHECK (billing_cycle IN ('Monthly', 'Annual')),
    mrr             NUMERIC(8, 2)   NOT NULL
                                    CHECK (mrr >= 0),
    CONSTRAINT chk_cancel_after_start CHECK (cancelled_date IS NULL OR cancelled_date > start_date)
);

-- TABLE 6: funnel_events
CREATE TABLE funnel_events (
    event_id        SERIAL          PRIMARY KEY,
    user_id         INTEGER         NOT NULL
                                    REFERENCES users(user_id)
                                    ON DELETE RESTRICT,
    event_stage     VARCHAR(30)     NOT NULL
                                    CHECK (event_stage IN (
                                        'Signup', 'Trial Started', 'Activated',
                                        'Engaged', 'Converted', 'Churned'
                                    )),
    event_date      DATE            NOT NULL,
    event_metadata  VARCHAR(200)
);

-- PLANS (4 tiers)
INSERT INTO plans (plan_name, plan_tier, monthly_price, annual_price, max_users, max_projects, has_api_access, has_sso, is_active)
VALUES
    ('Free',          'Free',          0.00,     0.00,    3,   2,  FALSE, FALSE, TRUE),
    ('Starter',       'Starter',      29.00,   290.00,   10,  10,  FALSE, FALSE, TRUE),
    ('Professional',  'Professional', 79.00,   790.00,   50,  50,  TRUE,  FALSE, TRUE),
    ('Enterprise',    'Enterprise',  199.00,  1990.00, 9999, 9999, TRUE,  TRUE,  TRUE);

-- USERS (40 signups across Q1 2025)
INSERT INTO users (email, full_name, signup_date, signup_source, company_name, company_size, country, is_active)
VALUES
    ('isla.reid@novahq.co.uk',        'Isla Reid',        '2025-01-03', 'Organic Search',  'NovaHQ',              '11-50',   'United Kingdom', TRUE),
    ('ravi.anand@synctool.de',         'Ravi Anand',       '2025-01-05', 'Google Ads',      'SyncTool GmbH',       '51-200',  'Germany',        TRUE),
    ('freya.cole@brightspark.io',      'Freya Cole',       '2025-01-07', 'Product Hunt',    'BrightSpark',         '1-10',    'United Kingdom', TRUE),
    ('kwame.mensah@logicflow.com',     'Kwame Mensah',     '2025-01-08', 'Referral',        'LogicFlow',           '11-50',   'Ghana',          TRUE),
    ('sienna.marsh@tideway.co.uk',     'Sienna Marsh',     '2025-01-10', 'LinkedIn',        'TideWay Solutions',   '51-200',  'United Kingdom', TRUE),
    ('arjun.kapoor@datanest.in',       'Arjun Kapoor',     '2025-01-12', 'Google Ads',      'DataNest',            '201-500', 'India',          TRUE),
    ('nia.okafor@cloudpeak.ng',        'Nia Okafor',       '2025-01-14', 'Organic Search',  'CloudPeak',           '11-50',   'Nigeria',        TRUE),
    ('finn.larsen@buildrite.dk',       'Finn Larsen',      '2025-01-16', 'Direct',          'BuildRite ApS',       '51-200',  'Denmark',        TRUE),
    ('mei.chen@orbitcore.sg',          'Mei Chen',         '2025-01-18', 'Referral',        'OrbitCore',           '201-500', 'Singapore',      TRUE),
    ('callum.wynne@stratosys.co.uk',   'Callum Wynne',     '2025-01-20', 'Organic Search',  'StratoSys',           '11-50',   'United Kingdom', TRUE),
    ('priya.sharma@vaultedge.in',      'Priya Sharma',     '2025-01-22', 'Google Ads',      'VaultEdge',           '500+',    'India',          TRUE),
    ('idris.bello@pulsenet.ng',        'Idris Bello',      '2025-01-24', 'LinkedIn',        'PulseNet',            '11-50',   'Nigeria',        FALSE),
    ('safiya.hassan@moonbeam.ae',      'Safiya Hassan',    '2025-01-26', 'Product Hunt',    'Moonbeam Tech',       '1-10',    'UAE',            TRUE),
    ('euan.campbell@gridlock.co.uk',   'Euan Campbell',    '2025-01-28', 'Direct',          'Gridlock Digital',    '51-200',  'United Kingdom', TRUE),
    ('yuki.tanaka@kaizenlabs.jp',      'Yuki Tanaka',      '2025-02-01', 'Organic Search',  'Kaizen Labs',         '201-500', 'Japan',          TRUE),
    ('aisha.diallo@springboard.sn',    'Aisha Diallo',     '2025-02-03', 'Referral',        'Springboard',         '1-10',    'Senegal',        TRUE),
    ('mateo.silva@rundeck.cl',         'Mateo Silva',      '2025-02-05', 'Google Ads',      'RunDeck SpA',         '51-200',  'Chile',          TRUE),
    ('sage.novak@clearpath.ca',        'Sage Novak',       '2025-02-07', 'LinkedIn',        'ClearPath',           '11-50',   'Canada',         TRUE),
    ('wei.zhang@nexusware.cn',         'Wei Zhang',        '2025-02-09', 'Direct',          'NexusWare',           '500+',    'China',          TRUE),
    ('river.kelly@flywheel.com.au',    'River Kelly',      '2025-02-11', 'Product Hunt',    'Flywheel Studio',     '1-10',    'Australia',      TRUE),
    ('jamal.osei@keystonedata.gh',     'Jamal Osei',       '2025-02-13', 'Organic Search',  'Keystone Data',       '11-50',   'Ghana',          TRUE),
    ('quinn.brady@talonops.ie',        'Quinn Brady',      '2025-02-15', 'Referral',        'TalonOps',            '51-200',  'Ireland',        TRUE),
    ('phoenix.rowe@crestline.co.uk',   'Phoenix Rowe',     '2025-02-17', 'Google Ads',      'Crestline UK',        '201-500', 'United Kingdom', TRUE),
    ('leila.amiri@basecamphr.se',      'Leila Amiri',      '2025-02-19', 'LinkedIn',        'BaseCamp HR',         '11-50',   'Sweden',         TRUE),
    ('omar.farah@tidalsys.ke',         'Omar Farah',       '2025-02-21', 'Organic Search',  'TidalSys',            '51-200',  'Kenya',          TRUE),
    ('zara.hussain@sparkgrid.co.uk',   'Zara Hussain',     '2025-02-23', 'Google Ads',      'SparkGrid',           '500+',    'United Kingdom', TRUE),
    ('lucas.petrov@alpinecode.bg',     'Lucas Petrov',     '2025-02-25', 'Direct',          'AlpineCode',          '1-10',    'Bulgaria',       TRUE),
    ('maya.ndung@atlashub.co.ke',      'Maya Ndung''u',    '2025-02-27', 'Referral',        'AtlasHub',            '11-50',   'Kenya',          FALSE),
    ('nina.kowalski@forgehq.pl',       'Nina Kowalski',    '2025-03-01', 'Organic Search',  'ForgeHQ',             '51-200',  'Poland',         TRUE),
    ('liam.oconnor@slateworks.ie',     'Liam O''Connor',   '2025-03-03', 'Product Hunt',    'SlateWorks',          '11-50',   'Ireland',        TRUE),
    ('amara.toure@beaconai.sn',        'Amara Toure',      '2025-03-05', 'Google Ads',      'BeaconAI',            '201-500', 'Senegal',        TRUE),
    ('kenji.ito@blueshift.jp',         'Kenji Ito',        '2025-03-07', 'Referral',        'BlueShift',           '51-200',  'Japan',          TRUE),
    ('jordan.abebe@solarcrest.et',     'Jordan Abebe',     '2025-03-09', 'LinkedIn',        'SolarCrest',          '1-10',    'Ethiopia',       TRUE),
    ('tara.brennan@mapleleaf.ca',      'Tara Brennan',     '2025-03-11', 'Direct',          'MapleLeaf Tech',      '11-50',   'Canada',         TRUE),
    ('casey.blake@ionworks.co.uk',     'Casey Blake',       '2025-03-13', 'Organic Search',  'IonWorks',            '51-200',  'United Kingdom', TRUE),
    ('riley.voss@pixelcraft.de',       'Riley Voss',       '2025-03-15', 'Google Ads',      'PixelCraft GmbH',     '201-500', 'Germany',        TRUE),
    ('nadia.volkov@quantumleap.ru',    'Nadia Volkov',     '2025-03-17', 'LinkedIn',        'QuantumLeap',         '500+',    'Russia',         TRUE),
    ('marcus.grant@terravault.co.uk',  'Marcus Grant',     '2025-03-19', 'Referral',        'TerraVault',          '11-50',   'United Kingdom', TRUE),
    ('aiko.sato@nimblestack.jp',       'Aiko Sato',        '2025-03-21', 'Product Hunt',    'NimbleStack',         '1-10',    'Japan',          TRUE),
    ('taylor.wright@edgepoint.co.nz',  'Taylor Wright',    '2025-03-23', 'Organic Search',  'EdgePoint',           '51-200',  'New Zealand',    TRUE);

-- TRIALS (35 of 40 users started a trial)
INSERT INTO trials (user_id, plan_id, trial_start, trial_end, activated_date, trial_status)
VALUES
    (1,  3, '2025-01-03', '2025-01-17', '2025-01-03', 'Converted'),
    (2,  3, '2025-01-06', '2025-01-20', '2025-01-07', 'Converted'),
    (3,  2, '2025-01-07', '2025-01-21', '2025-01-08', 'Converted'),
    (4,  3, '2025-01-09', '2025-01-23', '2025-01-09', 'Converted'),
    (5,  4, '2025-01-10', '2025-01-24', '2025-01-11', 'Converted'),
    (6,  4, '2025-01-13', '2025-01-27', '2025-01-14', 'Converted'),
    (7,  2, '2025-01-15', '2025-01-29', '2025-01-17', 'Expired'),
    (8,  3, '2025-01-16', '2025-01-30', '2025-01-16', 'Converted'),
    (9,  4, '2025-01-19', '2025-02-02', '2025-01-20', 'Converted'),
    (10, 2, '2025-01-21', '2025-02-04', NULL,          'Expired'),
    (11, 4, '2025-01-23', '2025-02-06', '2025-01-24', 'Converted'),
    (13, 2, '2025-01-27', '2025-02-10', '2025-01-30', 'Expired'),
    (14, 3, '2025-01-28', '2025-02-11', '2025-01-28', 'Converted'),
    (15, 3, '2025-02-01', '2025-02-15', '2025-02-02', 'Converted'),
    (16, 2, '2025-02-04', '2025-02-18', '2025-02-06', 'Expired'),
    (17, 3, '2025-02-05', '2025-02-19', '2025-02-05', 'Converted'),
    (18, 2, '2025-02-08', '2025-02-22', '2025-02-10', 'Cancelled'),
    (19, 4, '2025-02-10', '2025-02-24', '2025-02-11', 'Converted'),
    (20, 2, '2025-02-12', '2025-02-26', '2025-02-14', 'Expired'),
    (21, 3, '2025-02-14', '2025-02-28', '2025-02-14', 'Converted'),
    (22, 3, '2025-02-15', '2025-03-01', '2025-02-16', 'Converted'),
    (23, 4, '2025-02-18', '2025-03-04', '2025-02-19', 'Converted'),
    (24, 2, '2025-02-20', '2025-03-06', '2025-02-23', 'Expired'),
    (25, 3, '2025-02-22', '2025-03-08', '2025-02-22', 'Converted'),
    (26, 4, '2025-02-24', '2025-03-10', '2025-02-25', 'Converted'),
    (27, 2, '2025-02-26', '2025-03-12', NULL,          'Expired'),
    (29, 3, '2025-03-02', '2025-03-16', '2025-03-02', 'Converted'),
    (30, 2, '2025-03-04', '2025-03-18', '2025-03-05', 'Active'),
    (31, 4, '2025-03-06', '2025-03-20', '2025-03-07', 'Converted'),
    (32, 3, '2025-03-08', '2025-03-22', '2025-03-08', 'Active'),
    (33, 2, '2025-03-11', '2025-03-25', NULL,          'Cancelled'),
    (35, 2, '2025-03-12', '2025-03-26', '2025-03-14', 'Active'),
    (36, 3, '2025-03-16', '2025-03-30', '2025-03-17', 'Active'),
    (39, 2, '2025-03-20', '2025-04-03', NULL,          'Active'),
    (33, 2, '2025-03-11', '2025-03-25', NULL,          'Cancelled');
```

**Note:** The last trial row for user 33 (Jordan) is a duplicate - the setup file includes it to match the original dataset. If you receive a duplicate key error on user_id 33, remove the last row and re-run. The correct total is **35 trials**.

Now run the remaining inserts. Due to the size of the feature_usage, subscriptions, and funnel_events data, please copy them directly from the [setup file in the course repository](https://github.com/sdw-online/claude-ai-agents/blob/main/media-team/projects/courses/30-day-sql-challenge/day-21/21-setup.md).

The key inserts are:
- **feature_usage** - 147 rows of engagement data
- **subscriptions** - 20 paid conversion records
- **funnel_events** - 167 funnel tracking records

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM plans;
-- Expected: 4 rows

SELECT COUNT(*) FROM users;
-- Expected: 40 rows

SELECT COUNT(*) FROM trials;
-- Expected: 35 rows

SELECT COUNT(*) FROM subscriptions;
-- Expected: 20 rows

SELECT COUNT(*) FROM funnel_events;
-- Expected: 167 rows
```

## Exercises

You are a growth analyst at ArcPlan, a UK-based project management SaaS. The VP of Growth, Kwame, has called a Q1 review meeting. He has dropped three big questions on your desk - and you need to answer all of them with SQL before the meeting.

The context: 40 users signed up, but only 20 became paid subscribers. Kwame wants to know where the other 50% went.

Your job is to build a complete SaaS conversion funnel analysis across eight phases. This is a guided project - work through each step in order.

### 🟢 Warm-Up

**Q1: Explore the Data**

Understand the shape of your data before building any funnel. Which signup channels brought in the most users? What is the breakdown of trial statuses? How many trial users actually activated (logged in at least once)?

**Q2: Map the Full Funnel**

Use LEFT JOINs to connect users to trials to subscriptions. Then use the anti-join pattern (LEFT JOIN + WHERE IS NULL) to find users who signed up but never started a trial. Build the complete user journey with a multi-table JOIN.

### 🟡 Practice

**Q3: Analyse Drop-Offs by Stage**

Build the funnel counts using a CTE - how many users reached each stage (Signup, Trial Started, Activated, Converted)? Then present the same data in a dashboard-friendly UNION ALL format with one row per funnel stage. Identify the biggest absolute drop-off point.

**Q4: Analyse Conversion Timing**

Calculate how many days it takes from trial start to paid subscription for each converted user. Then group by plan to answer Kwame's question: do Enterprise trials convert faster or slower than Starter trials?

**Q5: Segment by Engagement**

Classify users as Power Users (6+ features), Regular Users (3-5 features), or Casual Users (1-2 features) based on feature usage during trial. Calculate the conversion rate for each engagement level. Use a FULL OUTER JOIN to compare which features Power Users touch that Casual Users do not.

### 🔴 Challenge

**Q6: Revenue Analysis & Recommendations**

Calculate MRR (Monthly Recurring Revenue) by plan and billing cycle. Identify which churned customers left and estimate the potential revenue from non-converters if they had converted. Based on your analysis, write four actionable recommendations for Kwame - your SQL should support each recommendation with data.

**Q7: Master Pipeline Query**

Build a single "master pipeline" query using three chained CTEs - one to assemble the data (all LEFT JOINs), one to calculate engagement metrics (aggregation), and one to classify business outcomes. This is how production analytics pipelines are structured.

## Key Concepts Covered
- **Funnel analysis with LEFT JOINs** - preserving drop-offs that INNER JOIN would hide
- **Anti-join pattern** - LEFT JOIN + WHERE IS NULL to find what is missing
- **UNION ALL for dashboard reporting** - stacking stage counts into a single result set
- **Engagement segmentation** - classifying users by feature depth to predict conversion
- **Chained CTEs** - building modular, testable analytics pipelines (assemble, calculate, classify)
- **Business interpretation** - translating raw SQL output into actionable recommendations

---

[← Day 20: Star Schema & Dimensional Modelling](../day-20/) | [Day 22: Window Functions Part 1 →](../day-22/)
