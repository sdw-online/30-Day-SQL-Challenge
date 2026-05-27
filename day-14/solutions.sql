-- ============================================
-- DAY 14 SOLUTIONS: Project - Fleet Intelligence Pipeline
-- ============================================

-- ============================================
-- PHASE 1: EXPLORE THE RAW DATA
-- ============================================

-- 1.1 Understand the device landscape
SELECT
    d.device_id,
    d.device_code,
    d.device_name,
    d.device_type,
    s.site_name,
    s.region,
    d.status,
    d.firmware_version
FROM devices d
JOIN sites s ON d.site_id = s.site_id
ORDER BY s.region, d.device_type;

-- 1.2 Check reading volume by device
SELECT
    d.device_code,
    d.device_type,
    d.status,
    COUNT(r.reading_id) AS reading_count,
    MIN(r.reading_timestamp) AS earliest_reading,
    MAX(r.reading_timestamp) AS latest_reading
FROM devices d
LEFT JOIN sensor_readings r ON d.device_id = r.device_id
GROUP BY d.device_code, d.device_type, d.status
ORDER BY reading_count;

-- 1.3 Identify NULL readings
SELECT
    COUNT(*) AS total_readings,
    COUNT(*) FILTER (WHERE temperature_c IS NULL) AS null_temp,
    COUNT(*) FILTER (WHERE humidity_pct IS NULL) AS null_humidity,
    COUNT(*) FILTER (WHERE power_output_kw IS NULL) AS null_power,
    COUNT(*) FILTER (WHERE voltage IS NULL) AS null_voltage,
    COUNT(*) FILTER (WHERE signal_strength_dbm IS NULL) AS null_signal,
    COUNT(*) FILTER (WHERE battery_level_pct IS NULL) AS null_battery
FROM sensor_readings;

-- 1.4 Check timezone inconsistencies
SELECT
    raw_timezone,
    COUNT(*) AS reading_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_total
FROM sensor_readings
GROUP BY raw_timezone
ORDER BY reading_count DESC;

-- 1.5 Find out-of-range readings
SELECT
    r.reading_id,
    d.device_code,
    d.device_type,
    r.reading_timestamp,
    r.temperature_c,
    r.power_output_kw
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
WHERE
    (d.device_type = 'Battery Unit' AND r.temperature_c NOT BETWEEN 10 AND 40)
    OR
    (d.device_type = 'Wind Turbine' AND r.power_output_kw < 0)
ORDER BY r.reading_timestamp;

-- ============================================
-- PHASE 2: CLEAN THE RAW DATA
-- ============================================

-- 2.1 Preview COALESCE on NULL readings
SELECT
    r.reading_id,
    d.device_code,
    r.reading_timestamp,
    r.temperature_c AS raw_temp,
    COALESCE(r.temperature_c, 0.0) AS cleaned_temp,
    r.power_output_kw AS raw_power,
    COALESCE(r.power_output_kw, 0.0) AS cleaned_power,
    r.voltage AS raw_voltage,
    COALESCE(r.voltage, 0.0) AS cleaned_voltage
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
WHERE r.temperature_c IS NULL
ORDER BY r.reading_timestamp
LIMIT 10;

-- 2.2 Average battery level per battery unit device
SELECT
    d.device_code,
    d.device_name,
    ROUND(AVG(r.battery_level_pct), 1) AS avg_battery_level,
    COUNT(*) FILTER (WHERE r.battery_level_pct IS NULL) AS null_count,
    COUNT(*) AS total_readings
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
WHERE d.device_type = 'Battery Unit'
GROUP BY d.device_code, d.device_name
ORDER BY d.device_code;

-- 2.3 Flag anomalous readings with CASE WHEN
SELECT
    r.reading_id,
    d.device_code,
    d.device_type,
    r.reading_timestamp,
    r.temperature_c,
    r.power_output_kw,
    CASE
        WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
            THEN 'NULL_DROPOUT'
        WHEN d.device_type = 'Battery Unit'
             AND r.temperature_c NOT BETWEEN 10 AND 40
            THEN 'TEMP_OUT_OF_RANGE'
        WHEN d.device_type = 'Wind Turbine'
             AND r.power_output_kw < 0
            THEN 'NEGATIVE_POWER'
        WHEN d.device_type = 'Solar Panel'
             AND r.power_output_kw IS NOT NULL
             AND r.power_output_kw > 15
            THEN 'POWER_EXCEEDS_CAPACITY'
        ELSE 'VALID'
    END AS reading_quality
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
ORDER BY r.reading_timestamp;

-- Count readings per quality category
SELECT
    CASE
        WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
            THEN 'NULL_DROPOUT'
        WHEN d.device_type = 'Battery Unit'
             AND r.temperature_c NOT BETWEEN 10 AND 40
            THEN 'TEMP_OUT_OF_RANGE'
        WHEN d.device_type = 'Wind Turbine'
             AND r.power_output_kw < 0
            THEN 'NEGATIVE_POWER'
        ELSE 'VALID'
    END AS reading_quality,
    COUNT(*) AS reading_count
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
GROUP BY
    CASE
        WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
            THEN 'NULL_DROPOUT'
        WHEN d.device_type = 'Battery Unit'
             AND r.temperature_c NOT BETWEEN 10 AND 40
            THEN 'TEMP_OUT_OF_RANGE'
        WHEN d.device_type = 'Wind Turbine'
             AND r.power_output_kw < 0
            THEN 'NEGATIVE_POWER'
        ELSE 'VALID'
    END
ORDER BY reading_count DESC;

-- 2.4 Preview timezone standardisation to UTC
SELECT
    r.reading_id,
    d.device_code,
    r.reading_timestamp AS raw_timestamp,
    r.raw_timezone,
    CASE
        WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
        WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
        ELSE r.reading_timestamp
    END AS utc_timestamp
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
WHERE r.raw_timezone IN ('BST', 'EST')
ORDER BY r.reading_timestamp
LIMIT 10;

-- 2.5 Identify which device has the EST firmware bug
SELECT
    d.device_code,
    d.device_name,
    d.firmware_version,
    s.site_name,
    COUNT(*) AS est_readings
FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
JOIN sites s ON d.site_id = s.site_id
WHERE r.raw_timezone = 'EST'
GROUP BY d.device_code, d.device_name, d.firmware_version, s.site_name;

-- ============================================
-- PHASE 3: BUILD THE CLEANING LAYER (TEMP TABLE)
-- ============================================

-- 3.1 Create cleaned_readings temp table
CREATE TEMP TABLE cleaned_readings AS
SELECT
    r.reading_id,
    r.device_id,
    d.device_code,
    d.device_name,
    d.device_type,
    s.site_name,
    s.region,

    -- Step 1: Standardise timestamp to UTC
    CASE
        WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
        WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
        ELSE r.reading_timestamp
    END AS utc_timestamp,

    -- Step 2: Extract the hour for aggregation
    DATE_TRUNC('hour',
        CASE
            WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
            WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
            ELSE r.reading_timestamp
        END
    ) AS reading_hour,

    -- Step 3: Clean temperature
    COALESCE(r.temperature_c, 0.0) AS temperature_c,

    -- Step 4: Clean humidity
    COALESCE(r.humidity_pct, 0.0) AS humidity_pct,

    -- Step 5: Clean power output
    COALESCE(r.power_output_kw, 0.0) AS power_output_kw,

    -- Step 6: Clean voltage
    COALESCE(r.voltage, 0.0) AS voltage,

    -- Step 7: Clean signal strength (-99 = no signal marker)
    COALESCE(r.signal_strength_dbm, -99) AS signal_strength_dbm,

    -- Step 8: Clean battery level (device average for Battery Units, NULL for others)
    CASE
        WHEN d.device_type = 'Battery Unit' THEN
            COALESCE(
                r.battery_level_pct,
                (SELECT ROUND(AVG(r2.battery_level_pct), 1)
                 FROM sensor_readings r2
                 WHERE r2.device_id = r.device_id
                   AND r2.battery_level_pct IS NOT NULL)
            )
        ELSE NULL
    END AS battery_level_pct,

    -- Step 9: Flag reading quality
    CASE
        WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
            THEN 'NULL_DROPOUT'
        WHEN d.device_type = 'Battery Unit'
             AND r.temperature_c IS NOT NULL
             AND r.temperature_c NOT BETWEEN 10 AND 40
            THEN 'TEMP_OUT_OF_RANGE'
        WHEN d.device_type = 'Wind Turbine'
             AND r.power_output_kw IS NOT NULL
             AND r.power_output_kw < 0
            THEN 'NEGATIVE_POWER'
        ELSE 'VALID'
    END AS reading_quality,

    -- Step 10: Keep raw timezone for audit trail
    r.raw_timezone

FROM sensor_readings r
JOIN devices d ON r.device_id = d.device_id
JOIN sites s ON d.site_id = s.site_id;

-- Verify: total cleaned readings
SELECT COUNT(*) AS total_cleaned FROM cleaned_readings;

-- Verify: quality flag distribution
SELECT
    reading_quality,
    COUNT(*) AS reading_count
FROM cleaned_readings
GROUP BY reading_quality
ORDER BY reading_count DESC;

-- 3.2 Verify timezone standardisation
SELECT
    reading_id,
    device_code,
    raw_timezone,
    utc_timestamp,
    reading_hour
FROM cleaned_readings
WHERE raw_timezone IN ('BST', 'EST')
ORDER BY utc_timestamp
LIMIT 8;

-- ============================================
-- PHASE 4: BUILD THE AGGREGATION LAYER (CTE PIPELINE)
-- ============================================

-- 4.1 Multi-step CTE pipeline: clean -> valid -> aggregate -> health score
WITH valid_readings AS (
    SELECT
        reading_id,
        device_id,
        device_code,
        device_name,
        device_type,
        site_name,
        region,
        utc_timestamp,
        reading_hour,
        temperature_c,
        humidity_pct,
        power_output_kw,
        voltage,
        signal_strength_dbm,
        battery_level_pct
    FROM cleaned_readings
    WHERE reading_quality = 'VALID'
),

hourly_aggregates AS (
    SELECT
        device_id,
        device_code,
        device_name,
        device_type,
        site_name,
        region,
        reading_hour,
        COUNT(*) AS readings_in_hour,
        ROUND(AVG(temperature_c), 2) AS avg_temp_c,
        ROUND(MIN(temperature_c), 2) AS min_temp_c,
        ROUND(MAX(temperature_c), 2) AS max_temp_c,
        ROUND(AVG(humidity_pct), 2) AS avg_humidity,
        ROUND(AVG(power_output_kw), 3) AS avg_power_kw,
        ROUND(MAX(power_output_kw), 3) AS peak_power_kw,
        ROUND(AVG(voltage), 2) AS avg_voltage,
        ROUND(AVG(signal_strength_dbm), 0) AS avg_signal_dbm,
        ROUND(AVG(battery_level_pct), 1) AS avg_battery_pct
    FROM valid_readings
    GROUP BY
        device_id, device_code, device_name, device_type,
        site_name, region, reading_hour
),

device_health AS (
    SELECT
        *,
        CASE
            WHEN avg_signal_dbm >= -40 THEN 100
            WHEN avg_signal_dbm >= -50 THEN 80
            WHEN avg_signal_dbm >= -55 THEN 60
            WHEN avg_signal_dbm >= -60 THEN 40
            ELSE 20
        END AS signal_health,

        CASE
            WHEN device_type = 'Solar Panel' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Solar Panel' AND avg_power_kw > 0
                THEN 'Generating'
            WHEN device_type = 'Battery Unit' AND avg_power_kw > 0
                THEN 'Discharging'
            WHEN device_type = 'Battery Unit' AND avg_power_kw < 0
                THEN 'Charging'
            WHEN device_type = 'Battery Unit' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Wind Turbine' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Wind Turbine' AND avg_power_kw > 0
                THEN 'Generating'
            ELSE 'Unknown'
        END AS operational_status,

        CASE
            WHEN device_type != 'Battery Unit' THEN 'N/A'
            WHEN avg_battery_pct >= 80 THEN 'Healthy'
            WHEN avg_battery_pct >= 50 THEN 'Moderate'
            WHEN avg_battery_pct >= 20 THEN 'Low'
            ELSE 'Critical'
        END AS battery_status

    FROM hourly_aggregates
)

SELECT
    device_code,
    device_type,
    site_name,
    region,
    reading_hour,
    readings_in_hour,
    avg_temp_c,
    avg_power_kw,
    peak_power_kw,
    avg_voltage,
    avg_signal_dbm,
    signal_health,
    operational_status,
    avg_battery_pct,
    battery_status
FROM device_health
ORDER BY reading_hour, device_code;

-- 4.2 Count pipeline output
WITH valid_readings AS (
    SELECT *
    FROM cleaned_readings
    WHERE reading_quality = 'VALID'
),
hourly_aggregates AS (
    SELECT
        device_code,
        device_type,
        reading_hour,
        COUNT(*) AS readings_in_hour
    FROM valid_readings
    GROUP BY device_code, device_type, reading_hour
)
SELECT
    COUNT(*) AS total_hourly_summaries,
    COUNT(DISTINCT device_code) AS devices_covered,
    MIN(reading_hour) AS earliest_hour,
    MAX(reading_hour) AS latest_hour
FROM hourly_aggregates;

-- ============================================
-- PHASE 5: BUILD THE ALERTING LAYER
-- ============================================

-- 5.1 Review alert rules
SELECT
    rule_id,
    device_type,
    metric_name,
    min_threshold,
    max_threshold,
    severity
FROM alert_rules
WHERE is_enabled = TRUE
ORDER BY device_type, metric_name;

-- 5.2 Apply alert rules to cleaned readings
WITH violations AS (
    SELECT
        cr.reading_id,
        cr.device_code,
        cr.device_name,
        cr.device_type,
        cr.site_name,
        cr.region,
        cr.utc_timestamp,
        ar.metric_name,
        ar.severity,
        ar.min_threshold,
        ar.max_threshold,

        CASE ar.metric_name
            WHEN 'temperature_c'     THEN cr.temperature_c
            WHEN 'power_output_kw'   THEN cr.power_output_kw
            WHEN 'voltage'           THEN cr.voltage
            WHEN 'battery_level_pct' THEN cr.battery_level_pct
        END AS actual_value,

        CASE
            WHEN ar.metric_name = 'temperature_c'
                 AND cr.temperature_c NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'power_output_kw'
                 AND cr.power_output_kw NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'voltage'
                 AND cr.voltage NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'battery_level_pct'
                 AND cr.battery_level_pct IS NOT NULL
                 AND cr.battery_level_pct NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            ELSE FALSE
        END AS is_violation

    FROM cleaned_readings cr
    JOIN alert_rules ar ON cr.device_type = ar.device_type
    WHERE cr.reading_quality = 'VALID'
      AND ar.is_enabled = TRUE
)

SELECT
    device_code,
    device_name,
    site_name,
    utc_timestamp,
    metric_name,
    actual_value,
    min_threshold,
    max_threshold,
    severity,
    CASE
        WHEN actual_value < min_threshold
            THEN 'Below minimum (' || CAST(min_threshold AS VARCHAR) || ')'
        WHEN actual_value > max_threshold
            THEN 'Above maximum (' || CAST(max_threshold AS VARCHAR) || ')'
    END AS violation_detail
FROM violations
WHERE is_violation = TRUE
ORDER BY severity DESC, utc_timestamp;

-- 5.3 Alert summary by device and severity
WITH violations AS (
    SELECT
        cr.device_code,
        cr.device_type,
        cr.site_name,
        ar.severity,
        CASE
            WHEN ar.metric_name = 'temperature_c'
                 AND cr.temperature_c NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'power_output_kw'
                 AND cr.power_output_kw NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'voltage'
                 AND cr.voltage NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            WHEN ar.metric_name = 'battery_level_pct'
                 AND cr.battery_level_pct IS NOT NULL
                 AND cr.battery_level_pct NOT BETWEEN ar.min_threshold AND ar.max_threshold
                THEN TRUE
            ELSE FALSE
        END AS is_violation
    FROM cleaned_readings cr
    JOIN alert_rules ar ON cr.device_type = ar.device_type
    WHERE cr.reading_quality = 'VALID'
      AND ar.is_enabled = TRUE
)
SELECT
    device_code,
    device_type,
    site_name,
    severity,
    COUNT(*) AS violation_count
FROM violations
WHERE is_violation = TRUE
GROUP BY device_code, device_type, site_name, severity
ORDER BY
    CASE severity WHEN 'Critical' THEN 1 WHEN 'Warning' THEN 2 ELSE 3 END,
    violation_count DESC;

-- ============================================
-- PHASE 6: COMPLETE PIPELINE AS ONE QUERY
-- ============================================

-- 6.1 Full pipeline: raw -> cleaned -> valid -> aggregated -> health-scored
WITH cleaned AS (
    SELECT
        r.reading_id,
        r.device_id,
        d.device_code,
        d.device_name,
        d.device_type,
        s.site_name,
        s.region,
        CASE
            WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
            WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
            ELSE r.reading_timestamp
        END AS utc_timestamp,
        DATE_TRUNC('hour',
            CASE
                WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
                WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
                ELSE r.reading_timestamp
            END
        ) AS reading_hour,
        COALESCE(r.temperature_c, 0.0) AS temperature_c,
        COALESCE(r.humidity_pct, 0.0) AS humidity_pct,
        COALESCE(r.power_output_kw, 0.0) AS power_output_kw,
        COALESCE(r.voltage, 0.0) AS voltage,
        COALESCE(r.signal_strength_dbm, -99) AS signal_strength_dbm,
        CASE
            WHEN d.device_type = 'Battery Unit' THEN
                COALESCE(
                    r.battery_level_pct,
                    (SELECT ROUND(AVG(r2.battery_level_pct), 1)
                     FROM sensor_readings r2
                     WHERE r2.device_id = r.device_id
                       AND r2.battery_level_pct IS NOT NULL)
                )
            ELSE NULL
        END AS battery_level_pct,
        CASE
            WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
                THEN 'NULL_DROPOUT'
            WHEN d.device_type = 'Battery Unit'
                 AND r.temperature_c IS NOT NULL
                 AND r.temperature_c NOT BETWEEN 10 AND 40
                THEN 'TEMP_OUT_OF_RANGE'
            WHEN d.device_type = 'Wind Turbine'
                 AND r.power_output_kw IS NOT NULL
                 AND r.power_output_kw < 0
                THEN 'NEGATIVE_POWER'
            ELSE 'VALID'
        END AS reading_quality
    FROM sensor_readings r
    JOIN devices d ON r.device_id = d.device_id
    JOIN sites s ON d.site_id = s.site_id
),

valid_only AS (
    SELECT * FROM cleaned
    WHERE reading_quality = 'VALID'
),

hourly_agg AS (
    SELECT
        device_id,
        device_code,
        device_name,
        device_type,
        site_name,
        region,
        reading_hour,
        COUNT(*) AS readings_in_hour,
        ROUND(AVG(temperature_c), 2) AS avg_temp_c,
        ROUND(MIN(temperature_c), 2) AS min_temp_c,
        ROUND(MAX(temperature_c), 2) AS max_temp_c,
        ROUND(AVG(humidity_pct), 2) AS avg_humidity,
        ROUND(AVG(power_output_kw), 3) AS avg_power_kw,
        ROUND(MAX(power_output_kw), 3) AS peak_power_kw,
        ROUND(SUM(power_output_kw), 3) AS total_power_kw,
        ROUND(AVG(voltage), 2) AS avg_voltage,
        ROUND(AVG(signal_strength_dbm), 0) AS avg_signal_dbm,
        ROUND(AVG(battery_level_pct), 1) AS avg_battery_pct
    FROM valid_only
    GROUP BY
        device_id, device_code, device_name, device_type,
        site_name, region, reading_hour
),

health_scored AS (
    SELECT
        *,
        CASE
            WHEN avg_signal_dbm >= -40 THEN 100
            WHEN avg_signal_dbm >= -50 THEN 80
            WHEN avg_signal_dbm >= -55 THEN 60
            WHEN avg_signal_dbm >= -60 THEN 40
            ELSE 20
        END AS signal_health,

        CASE
            WHEN device_type = 'Solar Panel' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Solar Panel' AND avg_power_kw > 0
                THEN 'Generating'
            WHEN device_type = 'Battery Unit' AND avg_power_kw > 0
                THEN 'Discharging'
            WHEN device_type = 'Battery Unit' AND avg_power_kw < 0
                THEN 'Charging'
            WHEN device_type = 'Battery Unit' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Wind Turbine' AND avg_power_kw = 0
                THEN 'Idle'
            WHEN device_type = 'Wind Turbine' AND avg_power_kw > 0
                THEN 'Generating'
            ELSE 'Unknown'
        END AS operational_status,

        CASE
            WHEN device_type != 'Battery Unit' THEN 'N/A'
            WHEN avg_battery_pct >= 80 THEN 'Healthy'
            WHEN avg_battery_pct >= 50 THEN 'Moderate'
            WHEN avg_battery_pct >= 20 THEN 'Low'
            ELSE 'Critical'
        END AS battery_status,

        CASE
            WHEN avg_signal_dbm >= -40 AND readings_in_hour >= 1 THEN 'Good'
            WHEN avg_signal_dbm >= -50 AND readings_in_hour >= 1 THEN 'Fair'
            WHEN avg_signal_dbm >= -55 THEN 'Poor'
            ELSE 'Critical'
        END AS overall_health

    FROM hourly_agg
)

SELECT
    device_code,
    device_type,
    site_name,
    region,
    TO_CHAR(reading_hour, 'YYYY-MM-DD HH24:00') AS hour_label,
    readings_in_hour,
    avg_temp_c,
    avg_power_kw,
    peak_power_kw,
    total_power_kw,
    avg_voltage,
    signal_health,
    operational_status,
    avg_battery_pct,
    battery_status,
    overall_health
FROM health_scored
ORDER BY reading_hour, site_name, device_code;

-- 6.2 Pipeline metrics summary
SELECT
    'Total raw readings' AS metric,
    COUNT(*)::TEXT AS value
FROM sensor_readings

UNION ALL

SELECT
    'NULL dropout readings',
    COUNT(*)::TEXT
FROM cleaned_readings
WHERE reading_quality = 'NULL_DROPOUT'

UNION ALL

SELECT
    'Anomalous readings (temp/power)',
    COUNT(*)::TEXT
FROM cleaned_readings
WHERE reading_quality IN ('TEMP_OUT_OF_RANGE', 'NEGATIVE_POWER')

UNION ALL

SELECT
    'Valid readings used in pipeline',
    COUNT(*)::TEXT
FROM cleaned_readings
WHERE reading_quality = 'VALID'

UNION ALL

SELECT
    'Timezone corrections applied',
    COUNT(*)::TEXT
FROM cleaned_readings
WHERE raw_timezone IN ('BST', 'EST')

UNION ALL

SELECT
    'Devices with EST firmware bug',
    COUNT(DISTINCT device_code)::TEXT
FROM cleaned_readings
WHERE raw_timezone = 'EST';

-- ============================================
-- PHASE 7: REGIONAL AND FLEET ANALYSIS
-- ============================================

-- 7.1 Power generation by region
WITH valid_readings AS (
    SELECT *
    FROM cleaned_readings
    WHERE reading_quality = 'VALID'
)
SELECT
    region,
    device_type,
    COUNT(DISTINCT device_code) AS device_count,
    ROUND(SUM(power_output_kw), 2) AS total_power_kw,
    ROUND(AVG(power_output_kw), 3) AS avg_power_per_reading,
    ROUND(MAX(power_output_kw), 3) AS peak_power_kw
FROM valid_readings
WHERE power_output_kw > 0
GROUP BY region, device_type
ORDER BY total_power_kw DESC;

-- 7.2 Device downtime analysis
SELECT
    cr.device_code,
    cr.device_name,
    cr.device_type,
    cr.site_name,
    COUNT(*) FILTER (WHERE cr.reading_quality = 'NULL_DROPOUT') AS dropout_count,
    COUNT(*) AS total_readings,
    ROUND(
        COUNT(*) FILTER (WHERE cr.reading_quality = 'NULL_DROPOUT') * 100.0
        / COUNT(*),
        1
    ) AS dropout_pct
FROM cleaned_readings cr
GROUP BY cr.device_code, cr.device_name, cr.device_type, cr.site_name
HAVING COUNT(*) FILTER (WHERE cr.reading_quality = 'NULL_DROPOUT') > 0
ORDER BY dropout_pct DESC;

-- 7.3 Signal strength by site per day
SELECT
    cr.site_name,
    cr.region,
    DATE_TRUNC('day', cr.utc_timestamp)::DATE AS reading_date,
    ROUND(AVG(cr.signal_strength_dbm), 1) AS avg_signal,
    CASE
        WHEN AVG(cr.signal_strength_dbm) >= -40 THEN 'Excellent'
        WHEN AVG(cr.signal_strength_dbm) >= -50 THEN 'Good'
        WHEN AVG(cr.signal_strength_dbm) >= -55 THEN 'Fair'
        WHEN AVG(cr.signal_strength_dbm) >= -60 THEN 'Poor'
        ELSE 'Critical'
    END AS signal_category
FROM cleaned_readings cr
WHERE cr.reading_quality = 'VALID'
GROUP BY cr.site_name, cr.region, DATE_TRUNC('day', cr.utc_timestamp)::DATE
ORDER BY cr.site_name, reading_date;

-- ============================================
-- PHASE 8: DASHBOARD-READY OUTPUT
-- ============================================

-- 8.1 Fleet overview scorecard
SELECT
    'Fleet Overview' AS report_section,
    COUNT(DISTINCT device_code) AS total_devices,
    COUNT(DISTINCT device_code) FILTER (
        WHERE device_code IN (
            SELECT device_code FROM devices WHERE status = 'Online'
        )
    ) AS online_devices,
    COUNT(DISTINCT site_name) AS active_sites,
    SUM(CASE WHEN reading_quality = 'VALID' THEN 1 ELSE 0 END) AS valid_readings,
    SUM(CASE WHEN reading_quality = 'NULL_DROPOUT' THEN 1 ELSE 0 END) AS dropout_readings,
    ROUND(
        SUM(CASE WHEN reading_quality = 'VALID' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        1
    ) AS data_quality_pct
FROM cleaned_readings;

-- 8.2 Power generation summary by device type
SELECT
    device_type,
    COUNT(DISTINCT device_code) AS device_count,
    ROUND(SUM(
        CASE WHEN power_output_kw > 0 THEN power_output_kw ELSE 0 END
    ), 2) AS total_generation_kw,
    ROUND(AVG(
        CASE WHEN power_output_kw > 0 THEN power_output_kw END
    ), 3) AS avg_output_per_reading,
    ROUND(MAX(power_output_kw), 3) AS peak_output_kw,
    COUNT(*) FILTER (WHERE reading_quality = 'NULL_DROPOUT') AS dropout_count
FROM cleaned_readings
GROUP BY device_type
ORDER BY total_generation_kw DESC;

-- 8.3 Data quality report with actionable recommendations
SELECT
    device_code,
    device_name,
    device_type,
    site_name,
    COUNT(*) AS total_readings,
    COUNT(*) FILTER (WHERE reading_quality = 'VALID') AS valid_count,
    COUNT(*) FILTER (WHERE reading_quality = 'NULL_DROPOUT') AS dropout_count,
    COUNT(*) FILTER (WHERE reading_quality IN ('TEMP_OUT_OF_RANGE', 'NEGATIVE_POWER')) AS anomaly_count,
    ROUND(
        COUNT(*) FILTER (WHERE reading_quality = 'VALID') * 100.0 / COUNT(*),
        1
    ) AS quality_pct,
    CASE
        WHEN COUNT(*) FILTER (WHERE reading_quality = 'VALID') * 100.0 / COUNT(*) >= 90
            THEN 'Acceptable'
        WHEN COUNT(*) FILTER (WHERE reading_quality = 'VALID') * 100.0 / COUNT(*) >= 75
            THEN 'Review needed'
        ELSE 'Action required'
    END AS quality_verdict
FROM cleaned_readings
GROUP BY device_code, device_name, device_type, site_name
ORDER BY quality_pct ASC;

-- ============================================
-- PHASE 9: RECOMMENDATIONS
-- ============================================

-- 9.1 Confirm the EST firmware bug device
SELECT device_code, device_name, firmware_version, status
FROM devices
WHERE device_code = 'DEV-BU-015';

-- 9.2 Check the offline device's recent activity
SELECT
    reading_id,
    reading_timestamp,
    temperature_c,
    power_output_kw,
    signal_strength_dbm
FROM sensor_readings
WHERE device_id = 14
ORDER BY reading_timestamp DESC;

-- 9.3 Add a UNIQUE constraint to prevent duplicate readings
ALTER TABLE sensor_readings
ADD CONSTRAINT unique_device_reading
UNIQUE (device_id, reading_timestamp);

-- 9.4 Create a view for dashboard consumption
CREATE OR REPLACE VIEW v_hourly_device_health AS
WITH cleaned AS (
    SELECT
        r.reading_id,
        r.device_id,
        d.device_code,
        d.device_name,
        d.device_type,
        s.site_name,
        s.region,
        CASE
            WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
            WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
            ELSE r.reading_timestamp
        END AS utc_timestamp,
        DATE_TRUNC('hour',
            CASE
                WHEN r.raw_timezone = 'BST' THEN r.reading_timestamp - INTERVAL '1 hour'
                WHEN r.raw_timezone = 'EST' THEN r.reading_timestamp + INTERVAL '5 hours'
                ELSE r.reading_timestamp
            END
        ) AS reading_hour,
        COALESCE(r.temperature_c, 0.0) AS temperature_c,
        COALESCE(r.humidity_pct, 0.0) AS humidity_pct,
        COALESCE(r.power_output_kw, 0.0) AS power_output_kw,
        COALESCE(r.voltage, 0.0) AS voltage,
        COALESCE(r.signal_strength_dbm, -99) AS signal_strength_dbm,
        CASE
            WHEN d.device_type = 'Battery Unit' THEN
                COALESCE(r.battery_level_pct,
                    (SELECT ROUND(AVG(r2.battery_level_pct), 1)
                     FROM sensor_readings r2
                     WHERE r2.device_id = r.device_id
                       AND r2.battery_level_pct IS NOT NULL))
            ELSE NULL
        END AS battery_level_pct,
        CASE
            WHEN r.temperature_c IS NULL AND r.power_output_kw IS NULL
                THEN 'NULL_DROPOUT'
            WHEN d.device_type = 'Battery Unit'
                 AND r.temperature_c IS NOT NULL
                 AND r.temperature_c NOT BETWEEN 10 AND 40
                THEN 'TEMP_OUT_OF_RANGE'
            WHEN d.device_type = 'Wind Turbine'
                 AND r.power_output_kw IS NOT NULL
                 AND r.power_output_kw < 0
                THEN 'NEGATIVE_POWER'
            ELSE 'VALID'
        END AS reading_quality
    FROM sensor_readings r
    JOIN devices d ON r.device_id = d.device_id
    JOIN sites s ON d.site_id = s.site_id
),
valid_only AS (
    SELECT * FROM cleaned WHERE reading_quality = 'VALID'
),
hourly_agg AS (
    SELECT
        device_code, device_name, device_type, site_name, region, reading_hour,
        COUNT(*) AS readings_in_hour,
        ROUND(AVG(temperature_c), 2) AS avg_temp_c,
        ROUND(AVG(power_output_kw), 3) AS avg_power_kw,
        ROUND(MAX(power_output_kw), 3) AS peak_power_kw,
        ROUND(SUM(power_output_kw), 3) AS total_power_kw,
        ROUND(AVG(voltage), 2) AS avg_voltage,
        ROUND(AVG(signal_strength_dbm), 0) AS avg_signal_dbm,
        ROUND(AVG(battery_level_pct), 1) AS avg_battery_pct
    FROM valid_only
    GROUP BY device_code, device_name, device_type, site_name, region, reading_hour
)
SELECT
    device_code,
    device_type,
    site_name,
    region,
    TO_CHAR(reading_hour, 'YYYY-MM-DD HH24:00') AS hour_label,
    readings_in_hour,
    avg_temp_c,
    avg_power_kw,
    peak_power_kw,
    total_power_kw,
    avg_voltage,
    avg_signal_dbm,
    avg_battery_pct
FROM hourly_agg
ORDER BY reading_hour, site_name, device_code;
