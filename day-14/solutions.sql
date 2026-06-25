-- ============================================================
-- DAY 14 SOLUTIONS: Fleet Intelligence Pipeline
-- ============================================================


-- ===========================================================
-- PHASE 1: Build the Schema
-- ===========================================================

-- Schema creation (CREATE TABLE statements) is in setup.sql.
-- Run setup.sql first to create the three tables and load all data.


-- ===========================================================
-- PHASE 2: Explore the Data
-- ===========================================================

-- Question 1: How many readings do we have?
SELECT
    COUNT(*) AS total_readings
FROM sensor_readings;

-- Question 2: How many vehicles are reporting?
SELECT
    COUNT(DISTINCT vehicle_id) AS vehicles_reporting
FROM sensor_readings;

-- Question 3: What period does the data cover?
SELECT
    MIN(reading_timestamp) AS earliest_reading,
    MAX(reading_timestamp) AS latest_reading
FROM sensor_readings;

-- Question 4: How many error-code readings are there?
SELECT
    COUNT(*) AS error_readings
FROM sensor_readings
WHERE reading_value = -999;

-- Dig deeper: check sensor-type label consistency
SELECT
    sensor_type,
    COUNT(*) AS reading_count
FROM sensor_readings
GROUP BY sensor_type
ORDER BY sensor_type;

-- Dig deeper: usable vs problem readings by sensor status
SELECT
    sensor_status,
    COUNT(*)                          AS reading_count,
    COUNT(reading_value)              AS has_value,
    COUNT(*) - COUNT(reading_value)   AS missing_value
FROM sensor_readings
GROUP BY sensor_status
ORDER BY reading_count DESC;


-- ===========================================================
-- PHASE 3: Clean the Data
-- ===========================================================

-- Step 1: Fix inconsistent sensor-type labels
-- Preview the problem labels first
SELECT
    DISTINCT sensor_type
FROM sensor_readings
WHERE sensor_type != LOWER(sensor_type)
ORDER BY sensor_type;

-- Standardise all sensor-type labels to lowercase with underscores
UPDATE sensor_readings
SET sensor_type = LOWER(REPLACE(sensor_type, ' ', '_'))
WHERE sensor_type != LOWER(REPLACE(sensor_type, ' ', '_'));

-- Verify: five clean labels
SELECT
    DISTINCT sensor_type
FROM sensor_readings
ORDER BY sensor_type;

-- Step 2: Handle NULL readings - check spread across the fleet
SELECT
    fv.vehicle_id,
    fv.registration,
    fv.depot_name,
    COUNT(*) FILTER (WHERE sr.reading_value IS NULL) AS null_readings,
    COUNT(*)                                          AS total_readings,
    ROUND(
        COUNT(*) FILTER (WHERE sr.reading_value IS NULL) * 100.0 / COUNT(*), 1
    ) AS null_percentage
FROM sensor_readings sr
JOIN fleet_vehicles fv
    ON fv.vehicle_id = sr.vehicle_id
GROUP BY
    fv.vehicle_id,
    fv.registration,
    fv.depot_name
HAVING
    COUNT(*) FILTER (WHERE sr.reading_value IS NULL) > 0
ORDER BY
    null_readings DESC;

-- Step 3: Replace error codes with NULL
-- Preview before changing anything
SELECT
    vehicle_id,
    sensor_type,
    reading_value,
    sensor_status
FROM sensor_readings
WHERE reading_value = -999;

-- Replace -999 error codes with NULL and mark status as 'error'
UPDATE sensor_readings
SET reading_value = NULL,
    sensor_status = 'error'
WHERE reading_value = -999;

-- Verify: zero rows remain with -999
SELECT
    COUNT(*) AS no_of_rows_with_error_codes
FROM sensor_readings
WHERE reading_value = -999;


-- ===========================================================
-- PHASE 4: Classify Readings
-- ===========================================================

-- Step 1: Classify engine-temperature readings only (learn the pattern first)
SELECT
    vehicle_id,
    sensor_type,
    reading_value,
    reading_timestamp,
    CASE
        WHEN reading_value > 105 THEN 'critical'
        WHEN reading_value >= 95 THEN 'warning'
        ELSE 'normal'
    END AS severity
FROM sensor_readings
WHERE reading_value IS NOT NULL
  AND sensor_type = 'engine_temp'
ORDER BY severity, vehicle_id;

-- Step 2: Classify all five sensors in one query
SELECT
    vehicle_id,
    sensor_type,
    reading_value,
    reading_timestamp,
    CASE
        WHEN sensor_type = 'engine_temp'   AND reading_value > 105  THEN 'critical'
        WHEN sensor_type = 'engine_temp'   AND reading_value >= 95  THEN 'warning'
        WHEN sensor_type = 'oil_pressure'  AND reading_value < 25   THEN 'critical'
        WHEN sensor_type = 'oil_pressure'  AND reading_value <= 40  THEN 'warning'
        WHEN sensor_type = 'brake_wear'    AND reading_value < 20   THEN 'critical'
        WHEN sensor_type = 'brake_wear'    AND reading_value <= 40  THEN 'warning'
        WHEN sensor_type = 'tyre_pressure'
            AND (reading_value < 28 OR reading_value > 45) THEN 'critical'
        WHEN sensor_type = 'tyre_pressure'
            AND (reading_value < 32 OR reading_value > 42) THEN 'warning'
        ELSE 'normal'
    END AS severity
FROM sensor_readings
WHERE reading_value IS NOT NULL
ORDER BY
    CASE
        WHEN sensor_type = 'engine_temp'  AND reading_value > 105 THEN 1
        WHEN sensor_type = 'oil_pressure' AND reading_value < 25  THEN 1
        WHEN sensor_type = 'brake_wear'   AND reading_value < 20  THEN 1
        ELSE 3
    END,
    vehicle_id;

-- How many readings fall into each severity category?
SELECT severity, reading_count, percentage
FROM (
    SELECT
        CASE
            WHEN sensor_type = 'engine_temp'  AND reading_value > 105  THEN 'critical'
            WHEN sensor_type = 'engine_temp'  AND reading_value >= 95  THEN 'warning'
            WHEN sensor_type = 'oil_pressure' AND reading_value < 25   THEN 'critical'
            WHEN sensor_type = 'oil_pressure' AND reading_value <= 40  THEN 'warning'
            WHEN sensor_type = 'brake_wear'   AND reading_value < 20   THEN 'critical'
            WHEN sensor_type = 'brake_wear'   AND reading_value <= 40  THEN 'warning'
            WHEN sensor_type = 'tyre_pressure'
                AND (reading_value < 28 OR reading_value > 45) THEN 'critical'
            WHEN sensor_type = 'tyre_pressure'
                AND (reading_value < 32 OR reading_value > 42) THEN 'warning'
            ELSE 'normal'
        END AS severity,
        COUNT(*) AS reading_count,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
    FROM sensor_readings
    WHERE reading_value IS NOT NULL
    GROUP BY 1
) counts
ORDER BY reading_count;


-- ===========================================================
-- PHASE 5: Daily Summaries
-- ===========================================================

-- Step 1: Collapse hourly readings into daily rows
SELECT
    vehicle_id,
    sensor_type,
    DATE(reading_timestamp) AS reading_date,
    COUNT(*) AS readings_count
FROM sensor_readings
WHERE reading_value IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY vehicle_id, sensor_type, reading_date;

-- Step 2: Add daily averages, highs, and lows
SELECT
    vehicle_id,
    sensor_type,
    DATE(reading_timestamp) AS reading_date,
    ROUND(AVG(reading_value), 2) AS daily_avg,  -- NEW
    MAX(reading_value)           AS daily_max,  -- NEW
    MIN(reading_value)           AS daily_min,  -- NEW
    COUNT(*)                     AS readings_count
FROM sensor_readings
WHERE reading_value IS NOT NULL
GROUP BY vehicle_id, sensor_type, DATE(reading_timestamp)
ORDER BY vehicle_id, sensor_type, reading_date;

-- Step 3: Fleet-wide average per sensor per day (baseline for comparison)
SELECT
    sensor_type,
    DATE(reading_timestamp) AS reading_date,
    ROUND(AVG(reading_value), 2) AS fleet_avg
FROM sensor_readings
WHERE reading_value IS NOT NULL
GROUP BY sensor_type, DATE(reading_timestamp)
ORDER BY sensor_type, reading_date;

-- Step 4: Compare each vehicle to the fleet average (correlated subquery)
SELECT
    ds.vehicle_id,
    ds.sensor_type,
    ds.reading_date,
    ds.daily_avg,
    ds.daily_max,
    ds.daily_min,
    ds.readings_count,
    ROUND(ds.daily_avg - (
        SELECT AVG(sr2.reading_value)
        FROM sensor_readings sr2
        WHERE sr2.sensor_type    = ds.sensor_type
          AND sr2.reading_value  IS NOT NULL
          AND DATE(sr2.reading_timestamp) = ds.reading_date
    ), 2) AS vs_fleet_avg
FROM (
    SELECT
        vehicle_id,
        sensor_type,
        DATE(reading_timestamp) AS reading_date,
        ROUND(AVG(reading_value), 2) AS daily_avg,
        MAX(reading_value)           AS daily_max,
        MIN(reading_value)           AS daily_min,
        COUNT(*)                     AS readings_count
    FROM sensor_readings
    WHERE reading_value IS NOT NULL
    GROUP BY vehicle_id, sensor_type, DATE(reading_timestamp)
) ds
ORDER BY ds.vehicle_id, ds.sensor_type, ds.reading_date;


-- ===========================================================
-- PHASE 6: Trend Analysis
-- ===========================================================

-- Step 1: Weekly averages per vehicle per sensor (standalone)
SELECT
    vehicle_id,
    sensor_type,
    DATE_TRUNC('week', reading_timestamp) AS week_start,
    ROUND(AVG(reading_value), 2)          AS weekly_avg,
    COUNT(*)                              AS readings_in_week
FROM sensor_readings
WHERE reading_value IS NOT NULL
GROUP BY vehicle_id, sensor_type, DATE_TRUNC('week', reading_timestamp)
ORDER BY vehicle_id, sensor_type, week_start;

-- Step 2: Wrap into CTE and add week-over-week comparison
WITH weekly_averages AS (
    SELECT
        vehicle_id,
        sensor_type AS sensor_type,
        DATE_TRUNC('week', reading_timestamp) AS week_start,
        ROUND(AVG(reading_value), 2)          AS weekly_avg,
        COUNT(*)                              AS readings_in_week
    FROM sensor_readings
    WHERE reading_value IS NOT NULL
    GROUP BY vehicle_id, sensor_type,
             DATE_TRUNC('week', reading_timestamp)
)
SELECT
    vehicle_id,
    sensor_type,
    week_start,
    weekly_avg,
    LAG(weekly_avg) OVER (
        PARTITION BY vehicle_id, sensor_type
        ORDER BY week_start
    ) AS prev_week_avg,
    weekly_avg - LAG(weekly_avg) OVER (
        PARTITION BY vehicle_id, sensor_type
        ORDER BY week_start
    ) AS week_change
FROM weekly_averages
ORDER BY vehicle_id, sensor_type, week_start;

-- Step 3: Three-CTE pipeline - flag vehicles trending toward failure
WITH weekly_averages AS (
    SELECT
        vehicle_id,
        sensor_type AS sensor_type,
        DATE_TRUNC('week', reading_timestamp) AS week_start,
        ROUND(AVG(reading_value), 2)          AS weekly_avg,
        COUNT(*)                              AS readings_in_week
    FROM sensor_readings
    WHERE reading_value IS NOT NULL
    GROUP BY vehicle_id, sensor_type,
             DATE_TRUNC('week', reading_timestamp)
),
week_over_week AS (
    SELECT
        vehicle_id,
        sensor_type,
        week_start,
        weekly_avg,
        LAG(weekly_avg) OVER (
            PARTITION BY vehicle_id, sensor_type
            ORDER BY week_start
        ) AS prev_week_avg,
        weekly_avg - LAG(weekly_avg) OVER (
            PARTITION BY vehicle_id, sensor_type
            ORDER BY week_start
        ) AS week_change
    FROM weekly_averages
),
worsening_vehicles AS (
    SELECT
        vehicle_id,
        sensor_type,
        COUNT(*) AS weeks_tracked,
        COUNT(*) FILTER (WHERE
            (sensor_type = 'engine_temp'    AND week_change > 0)
            OR (sensor_type = 'oil_pressure'  AND week_change < 0)
            OR (sensor_type = 'brake_wear'    AND week_change < 0)
            OR (sensor_type = 'tyre_pressure' AND ABS(week_change) > 5)
        ) AS worsening_weeks,
        ROUND(AVG(week_change), 2) AS avg_weekly_change
    FROM week_over_week
    WHERE prev_week_avg IS NOT NULL
    GROUP BY vehicle_id, sensor_type
)
SELECT
    w.vehicle_id,
    fv.registration,
    fv.vehicle_type,
    fv.depot_name,
    w.sensor_type,
    w.weeks_tracked,
    w.worsening_weeks,
    ROUND(w.worsening_weeks * 100.0 / w.weeks_tracked, 0) AS worsening_pct,
    w.avg_weekly_change
FROM worsening_vehicles w
JOIN fleet_vehicles fv ON fv.vehicle_id = w.vehicle_id
WHERE w.worsening_weeks >= 2
ORDER BY w.worsening_weeks DESC, w.avg_weekly_change DESC;


-- ===========================================================
-- PHASE 7: Dashboard Output - Sarah's Monday Morning Report
-- ===========================================================

-- Full pipeline: weekly_averages -> with_lag -> latest_week -> risk_scored -> final report
WITH weekly_averages AS (
    SELECT
        vehicle_id,
        sensor_type AS sensor_type,
        DATE_TRUNC('week', reading_timestamp) AS week_start,
        ROUND(AVG(reading_value), 2)          AS weekly_avg,
        COUNT(*)                              AS readings_in_week
    FROM sensor_readings
    WHERE reading_value IS NOT NULL
    GROUP BY vehicle_id, sensor_type,
             DATE_TRUNC('week', reading_timestamp)
),
with_lag AS (
    SELECT
        vehicle_id,
        sensor_type,
        week_start,
        weekly_avg AS current_reading,
        LAG(weekly_avg) OVER (
            PARTITION BY vehicle_id, sensor_type
            ORDER BY week_start
        ) AS prev_reading
    FROM weekly_averages
),
latest_week AS (
    SELECT vehicle_id, sensor_type, current_reading, prev_reading
    FROM with_lag
    WHERE week_start = (SELECT MAX(week_start) FROM weekly_averages)
),
risk_scored AS (
    SELECT
        lw.vehicle_id,
        lw.sensor_type,
        lw.current_reading,
        lw.prev_reading,
        CASE
            WHEN sensor_type = 'engine_temp'  AND current_reading > 105  THEN 'critical'
            WHEN sensor_type = 'engine_temp'  AND current_reading >= 95  THEN 'warning'
            WHEN sensor_type = 'oil_pressure' AND current_reading < 25   THEN 'critical'
            WHEN sensor_type = 'oil_pressure' AND current_reading <= 40  THEN 'warning'
            WHEN sensor_type = 'brake_wear'   AND current_reading < 20   THEN 'critical'
            WHEN sensor_type = 'brake_wear'   AND current_reading <= 40  THEN 'warning'
            WHEN sensor_type = 'tyre_pressure'
                AND (current_reading < 28 OR current_reading > 45) THEN 'critical'
            WHEN sensor_type = 'tyre_pressure'
                AND (current_reading < 32 OR current_reading > 42) THEN 'warning'
            ELSE 'normal'
        END AS severity,
        COALESCE(
            (SELECT ROUND(AVG(cost), 0)
             FROM maintenance_log ml
             WHERE ml.vehicle_id = lw.vehicle_id),
            5000
        ) AS estimated_repair_cost,
        COALESCE(
            (SELECT ROUND(AVG(downtime_hours), 0)
             FROM maintenance_log ml
             WHERE ml.vehicle_id = lw.vehicle_id),
            24
        ) AS estimated_downtime_hrs
    FROM latest_week lw
    WHERE lw.prev_reading IS NOT NULL
)
SELECT
    rs.vehicle_id,
    fv.registration,
    fv.vehicle_type,
    fv.depot_name,
    rs.sensor_type,
    rs.current_reading,
    rs.severity,
    '$' || TO_CHAR(rs.estimated_repair_cost, 'FM999,999') AS est_cost,
    rs.estimated_downtime_hrs || ' hrs'                    AS est_downtime,
    CASE rs.severity
        WHEN 'critical' THEN 'PULL FROM SERVICE'
        WHEN 'warning'  THEN 'SCHEDULE THIS WEEK'
        ELSE 'MONITOR'
    END AS action
FROM risk_scored rs
JOIN fleet_vehicles fv ON fv.vehicle_id = rs.vehicle_id
WHERE rs.severity IN ('critical', 'warning')
ORDER BY
    CASE rs.severity WHEN 'critical' THEN 1 ELSE 2 END,
    rs.estimated_repair_cost DESC;
