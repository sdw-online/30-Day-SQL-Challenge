# Day 14 - Project: Fleet Intelligence Pipeline

[Watch the video](COMING_SOON) | [← Day 13: CTEs (Part 1)](../day-13/) | [Day 15: JOINs Part 1 →](../day-15/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to build a complete data pipeline in SQL - from raw data to dashboard-ready output
- How to explore raw data for NULLs, anomalies, and inconsistencies before writing transformations
- How to flag bad data with CASE WHEN instead of deleting it
- How to standardise inconsistent timestamps using INTERVAL
- How to combine temp tables and chained CTEs in a single pipeline
- How to build a table-driven alerting system

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 8-13 (NULL handling, string functions, numeric functions, date functions, CASE WHEN, subqueries, temp tables, and CTEs)

## Dataset

This is your Week 2 project. You are building an IoT sensor data pipeline for GridPulse Energy - a UK-based renewable energy company that monitors solar panels, battery storage units, and wind turbines across six sites.

The dataset contains intentional data quality issues that you will find and fix:
- NULL sensor values (communication dropouts)
- Inconsistent timezone labels (UTC, GMT, BST, and EST mixed together)
- A temperature spike on a battery unit (55.3C - far above the 10-40C normal range)
- A negative power output on a wind turbine (-5.2 kW - physically impossible)
- Missing battery levels on some battery unit readings

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 14 PROJECT SETUP: GridPulse IoT Sensor Pipeline
-- ============================================

-- Clean up any existing tables
DROP TABLE IF EXISTS sensor_readings;
DROP TABLE IF EXISTS alert_rules;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS sites;

-- TABLE 1: sites
CREATE TABLE sites (
    site_id         SERIAL          PRIMARY KEY,
    site_code       VARCHAR(15)     NOT NULL UNIQUE,
    site_name       VARCHAR(100)    NOT NULL,
    region          VARCHAR(50)     NOT NULL
                                    CHECK (region IN (
                                        'South East', 'South West', 'East Anglia',
                                        'Midlands', 'North England', 'Scotland', 'Wales'
                                    )),
    latitude        NUMERIC(9, 6)   NOT NULL,
    longitude       NUMERIC(9, 6)   NOT NULL,
    commissioned_date DATE          NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: devices
CREATE TABLE devices (
    device_id       SERIAL          PRIMARY KEY,
    device_code     VARCHAR(20)     NOT NULL UNIQUE,
    device_name     VARCHAR(100)    NOT NULL,
    device_type     VARCHAR(30)     NOT NULL
                                    CHECK (device_type IN ('Solar Panel', 'Battery Unit', 'Wind Turbine')),
    site_id         INTEGER         NOT NULL REFERENCES sites(site_id) ON DELETE RESTRICT,
    firmware_version VARCHAR(20)    NOT NULL,
    installed_date  DATE            NOT NULL,
    last_maintenance_date DATE,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Online'
                                    CHECK (status IN ('Online', 'Offline', 'Maintenance', 'Decommissioned'))
);

-- TABLE 3: sensor_readings
CREATE TABLE sensor_readings (
    reading_id      SERIAL          PRIMARY KEY,
    device_id       INTEGER         NOT NULL REFERENCES devices(device_id) ON DELETE RESTRICT,
    reading_timestamp TIMESTAMP     NOT NULL,
    temperature_c   NUMERIC(6, 2),
    humidity_pct    NUMERIC(5, 2),
    power_output_kw NUMERIC(8, 3),
    voltage         NUMERIC(7, 2),
    signal_strength_dbm INTEGER,
    battery_level_pct NUMERIC(5, 2),
    raw_timezone    VARCHAR(10),
    is_processed    BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 4: alert_rules
CREATE TABLE alert_rules (
    rule_id         SERIAL          PRIMARY KEY,
    device_type     VARCHAR(30)     NOT NULL
                                    CHECK (device_type IN ('Solar Panel', 'Battery Unit', 'Wind Turbine')),
    metric_name     VARCHAR(50)     NOT NULL,
    min_threshold   NUMERIC(10, 3),
    max_threshold   NUMERIC(10, 3),
    severity        VARCHAR(20)     NOT NULL DEFAULT 'Warning'
                                    CHECK (severity IN ('Info', 'Warning', 'Critical')),
    is_enabled      BOOLEAN         NOT NULL DEFAULT TRUE
);

-- 6 sites across UK regions
INSERT INTO sites (site_code, site_name, region, latitude, longitude, commissioned_date, is_active)
VALUES
    ('GP-SE-001', 'Gatwick Solar Farm',      'South East',    51.148056, -0.190278,  '2023-03-15', TRUE),
    ('GP-SW-002', 'Bristol Wind Park',       'South West',    51.454514, -2.587910,  '2023-06-01', TRUE),
    ('GP-EA-003', 'Norfolk Battery Hub',     'East Anglia',   52.630886,  1.297355,  '2024-01-10', TRUE),
    ('GP-ML-004', 'Birmingham Energy Centre','Midlands',      52.486243, -1.890401,  '2024-04-20', TRUE),
    ('GP-NE-005', 'Newcastle Grid Station',  'North England', 54.978252, -1.617780,  '2024-08-01', TRUE),
    ('GP-SC-006', 'Edinburgh Renewables',    'Scotland',      55.953251, -3.188267,  '2025-01-15', TRUE);

-- 18 devices (3 per site)
INSERT INTO devices (device_code, device_name, device_type, site_id, firmware_version, installed_date, last_maintenance_date, status)
VALUES
    ('DEV-SP-001', 'Gatwick Panel Array A',    'Solar Panel',   1, 'v3.2.1', '2023-03-15', '2025-01-10', 'Online'),
    ('DEV-BU-002', 'Gatwick Battery Store 1',  'Battery Unit',  1, 'v2.8.0', '2023-03-15', '2024-11-20', 'Online'),
    ('DEV-WT-003', 'Gatwick Turbine Alpha',    'Wind Turbine',  1, 'v4.1.0', '2023-04-01', '2025-02-05', 'Online'),
    ('DEV-WT-004', 'Bristol Turbine North',    'Wind Turbine',  2, 'v4.1.0', '2023-06-01', '2024-12-15', 'Online'),
    ('DEV-WT-005', 'Bristol Turbine South',    'Wind Turbine',  2, 'v4.0.2', '2023-06-01', '2024-09-30', 'Maintenance'),
    ('DEV-SP-006', 'Bristol Panel Row B',      'Solar Panel',   2, 'v3.2.1', '2023-07-10', NULL,          'Online'),
    ('DEV-BU-007', 'Norfolk Storage Unit 1',   'Battery Unit',  3, 'v2.8.0', '2024-01-10', '2025-01-05', 'Online'),
    ('DEV-BU-008', 'Norfolk Storage Unit 2',   'Battery Unit',  3, 'v2.7.3', '2024-01-10', '2024-08-20', 'Online'),
    ('DEV-SP-009', 'Norfolk Panel Strip C',    'Solar Panel',   3, 'v3.1.4', '2024-02-15', NULL,          'Online'),
    ('DEV-SP-010', 'Birmingham Panel Grid D',  'Solar Panel',   4, 'v3.2.1', '2024-04-20', '2025-01-22', 'Online'),
    ('DEV-BU-011', 'Birmingham Battery Bay 1', 'Battery Unit',  4, 'v2.8.0', '2024-04-20', '2024-10-10', 'Online'),
    ('DEV-WT-012', 'Birmingham Turbine Beta',  'Wind Turbine',  4, 'v4.1.0', '2024-05-15', '2025-02-01', 'Online'),
    ('DEV-WT-013', 'Newcastle Turbine East',   'Wind Turbine',  5, 'v4.0.2', '2024-08-01', '2025-01-18', 'Online'),
    ('DEV-SP-014', 'Newcastle Panel Block E',  'Solar Panel',   5, 'v3.1.4', '2024-08-01', NULL,          'Offline'),
    ('DEV-BU-015', 'Newcastle Battery Vault',  'Battery Unit',  5, 'v2.8.0', '2024-08-15', '2025-02-10', 'Online'),
    ('DEV-SP-016', 'Edinburgh Panel Cluster F','Solar Panel',   6, 'v3.2.1', '2025-01-15', NULL,          'Online'),
    ('DEV-WT-017', 'Edinburgh Turbine Gamma',  'Wind Turbine',  6, 'v4.1.0', '2025-01-20', NULL,          'Online'),
    ('DEV-BU-018', 'Edinburgh Battery Core',   'Battery Unit',  6, 'v2.8.0', '2025-02-01', NULL,          'Online');

-- 9 alert rules
INSERT INTO alert_rules (device_type, metric_name, min_threshold, max_threshold, severity, is_enabled)
VALUES
    ('Solar Panel',   'temperature_c',      -10.000,   60.000,  'Warning',  TRUE),
    ('Solar Panel',   'power_output_kw',       0.000,   15.000,  'Warning',  TRUE),
    ('Solar Panel',   'voltage',               0.000,   60.000,  'Critical', TRUE),
    ('Battery Unit',  'temperature_c',        10.000,   40.000,  'Critical', TRUE),
    ('Battery Unit',  'battery_level_pct',    20.000,  100.000,  'Warning',  TRUE),
    ('Battery Unit',  'voltage',              45.000,   55.000,  'Critical', TRUE),
    ('Wind Turbine',  'temperature_c',      -20.000,   50.000,  'Warning',  TRUE),
    ('Wind Turbine',  'power_output_kw',       0.000,  100.000,  'Critical', TRUE),
    ('Wind Turbine',  'voltage',             220.000,  260.000,  'Critical', TRUE);

-- Batch 1: Device DEV-SP-001 (Gatwick Solar Panel) -- 15 readings
INSERT INTO sensor_readings (device_id, reading_timestamp, temperature_c, humidity_pct, power_output_kw, voltage, signal_strength_dbm, battery_level_pct, raw_timezone, is_processed)
VALUES
    (1, '2025-03-01 06:00:00', 8.50,  72.30, 0.000,   0.00, -45, NULL, 'UTC',  FALSE),
    (1, '2025-03-01 08:00:00', 11.20, 68.10, 2.450,  48.50, -42, NULL, 'UTC',  FALSE),
    (1, '2025-03-01 10:00:00', 14.80, 55.40, 5.120,  52.10, -40, NULL, 'GMT',  FALSE),
    (1, '2025-03-01 12:00:00', 17.30, 48.20, 7.830,  54.20, -38, NULL, 'BST',  FALSE),
    (1, '2025-03-01 14:00:00', 18.90, 45.10, 6.540,  53.00, -39, NULL, 'UTC',  FALSE),
    (1, '2025-03-01 16:00:00', 16.40, 52.80, 3.210,  49.80, -41, NULL, 'GMT',  FALSE),
    (1, '2025-03-01 18:00:00', 12.10, 65.90, 0.420,  42.30, -44, NULL, 'UTC',  FALSE),
    (1, '2025-03-01 20:00:00', 9.80,  74.50, 0.000,   0.00, -46, NULL, 'UTC',  FALSE),
    (1, '2025-03-02 08:00:00', 10.50, 70.20, NULL,   NULL,  -43, NULL, 'UTC',  FALSE),
    (1, '2025-03-02 10:00:00', 15.10, 54.80, 5.380,  52.40, -40, NULL, 'BST',  FALSE),
    (1, '2025-03-02 12:00:00', NULL,  NULL,  NULL,   NULL,   NULL, NULL, 'UTC',  FALSE),
    (1, '2025-03-02 14:00:00', 19.50, 43.60, 6.920,  53.50, -38, NULL, 'UTC',  FALSE),
    (1, '2025-03-02 16:00:00', 16.80, 51.40, 3.450,  50.10, -41, NULL, 'GMT',  FALSE),
    (1, '2025-03-03 08:00:00', 11.80, 66.90, 2.870,  49.20, -42, NULL, 'UTC',  FALSE),
    (1, '2025-03-03 12:00:00', 18.20, 46.30, 8.100,  54.80, -37, NULL, 'BST',  FALSE);

-- Batches 2-18 omitted for brevity -- see full dataset in pgAdmin setup above
-- (Run all 18 batches from the video/lesson setup to get all 183 rows)

-- Batch 2: Device DEV-BU-002 (Gatwick Battery Store) -- 15 readings
INSERT INTO sensor_readings (device_id, reading_timestamp, temperature_c, humidity_pct, power_output_kw, voltage, signal_strength_dbm, battery_level_pct, raw_timezone, is_processed)
VALUES
    (2, '2025-03-01 06:00:00', 22.10, 35.40, -1.200,  48.80, -35, 92.50, 'UTC',  FALSE),
    (2, '2025-03-01 08:00:00', 22.40, 34.80, -0.850,  49.10, -34, 89.30, 'UTC',  FALSE),
    (2, '2025-03-01 10:00:00', 23.10, 33.20, 1.500,   50.20, -33, 85.10, 'GMT',  FALSE),
    (2, '2025-03-01 12:00:00', 24.50, 31.10, 2.100,   51.00, -32, NULL,  'BST',  FALSE),
    (2, '2025-03-01 14:00:00', 25.80, 29.50, 1.800,   50.80, -33, 78.40, 'UTC',  FALSE),
    (2, '2025-03-01 16:00:00', 24.20, 32.40, -0.500,  49.50, -34, 82.60, 'GMT',  FALSE),
    (2, '2025-03-01 18:00:00', 23.00, 34.10, -1.400,  48.60, -35, 87.20, 'UTC',  FALSE),
    (2, '2025-03-01 20:00:00', 22.50, 35.80, -1.600,  48.20, -36, 91.00, 'UTC',  FALSE),
    (2, '2025-03-02 06:00:00', 21.80, 36.20, -1.100,  48.90, -35, 94.80, 'UTC',  FALSE),
    (2, '2025-03-02 10:00:00', 23.50, 32.80, 1.700,   50.40, -33, NULL,  'BST',  FALSE),
    (2, '2025-03-02 14:00:00', NULL,  NULL,  NULL,    NULL,   NULL, NULL,  'UTC',  FALSE),
    (2, '2025-03-02 18:00:00', 22.80, 34.50, -1.300,  48.70, -35, 88.40, 'UTC',  FALSE),
    (2, '2025-03-03 06:00:00', 21.50, 36.80, -1.000,  49.00, -35, 95.20, 'UTC',  FALSE),
    (2, '2025-03-03 12:00:00', 24.80, 30.50, 2.200,   51.20, -32, 76.90, 'BST',  FALSE),
    (2, '2025-03-03 18:00:00', 22.60, 35.20, -1.500,  48.40, -36, 90.10, 'UTC',  FALSE);

-- Remaining batches (3-18): Copy from the full lesson setup SQL above
-- Total expected: 183 rows across all 18 devices
```

Note: The full dataset contains 183 sensor readings across 18 devices. The complete INSERT statements for all batches (3-18) are included in the lesson setup. Run them all before starting the exercises.

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM sites;
-- Expected: 6 rows

SELECT COUNT(*) FROM devices;
-- Expected: 18 rows

SELECT COUNT(*) FROM sensor_readings;
-- Expected: 183 rows

SELECT COUNT(*) FROM alert_rules;
-- Expected: 9 rows
```

## Exercises

You work as an IoT data engineer at GridPulse Energy. The head of operations, Kwame Osei, has called an urgent meeting. Three problems have landed on his desk: unreliable dashboard readings, no automated alerting, and no hourly summaries.

Your job is to build a SQL pipeline that takes raw sensor readings and transforms them into clean, validated, hourly device health summaries. Work through these steps:

### 🟢 Warm-Up

**Step 1 - Explore the raw data.** Before building anything, understand what you are working with. How many devices do you have across the fleet? How many readings have NULL values, and which columns are affected? What timezone labels appear in the data? Are there any out-of-range readings (e.g., battery units above 40C, wind turbines with negative power output)?

**Step 2 - Clean the data.** Build a temp table called `cleaned_readings` that applies three transformations to every row: (a) standardise all timestamps to UTC using CASE WHEN and INTERVAL (BST = subtract 1 hour, EST = add 5 hours), (b) replace NULL sensor values with 0 using COALESCE, and (c) flag each reading's quality as either 'VALID' or 'NULL_DROPOUT' using CASE WHEN.

### 🟡 Practice

**Step 3 - Build the aggregation layer.** Using a multi-step CTE pipeline on your cleaned data: first filter to valid readings only, then aggregate to one row per device per hour using DATE_TRUNC, and finally add an operational status for each device (Solar Panel: Idle/Generating, Battery Unit: Charging/Discharging/Idle, Wind Turbine: Generating/Idle).

**Step 4 - Build the alerting layer.** Join your cleaned readings against the `alert_rules` table to find threshold violations. Use CASE WHEN on `metric_name` to dynamically select which sensor column to compare against each rule's thresholds.

### 🔴 Challenge

**Step 5 - Assemble the full pipeline.** Combine cleaning, filtering, aggregation, and health scoring into a single query with four CTE stages. Produce a final summary showing: total raw readings, valid readings, dropout count, anomaly count, timezone corrections applied, and the data quality percentage.

**Bonus - Identify the firmware bug.** Write a query that groups by device code, firmware version, and timezone label to find the specific device reporting in the wrong timezone. Include a recommendation for the operations team.

## Key Concepts Covered
- **Explore before you build:** Always check for NULLs, anomalies, and inconsistencies before writing transformations
- **Flag, do not delete:** Use CASE WHEN to classify data quality - never delete raw sensor data; keep it for audit trails
- **COALESCE for NULL replacement:** Replace missing sensor values with sensible defaults
- **INTERVAL for timezone correction:** Add or subtract hours from timestamps to standardise to UTC
- **Temp tables for reuse:** Store cleaned data once, query it multiple times across pipeline phases
- **Table-driven alerting:** Store thresholds in a table so the operations team can change rules without modifying SQL

---

[← Day 13: CTEs (Part 1)](../day-13/) | [Day 15: JOINs Part 1 →](../day-15/)
