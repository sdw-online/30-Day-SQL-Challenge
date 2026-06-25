<p align="center">
  <a href="https://youtu.be/afIJ4VsQYSo"><img src="../assets/banners/day-14-project-fleet.svg" width="800" alt="Day 14 - Project: Fleet Intelligence Pipeline"></a>
</p>

<p align="center">
  <a href="https://youtu.be/afIJ4VsQYSo"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-14_of_30-blue" alt="Day 14">
  <img src="https://img.shields.io/badge/Week-2-purple" alt="Week 2">
  <img src="https://img.shields.io/badge/Difficulty-Intermediate-orange" alt="Intermediate">
</p>

# Day 14 - Project: Fleet Intelligence Pipeline

[<< Day 13: CTEs (Part 1)](../day-13/) | [Day 15: JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER >>](../day-15/)

---

## What You'll Learn

- How to build a complete data pipeline in SQL - from raw data to dashboard-ready output
- How to explore raw data for NULLs, anomalies, and inconsistencies before writing transformations
- How to flag bad data with CASE WHEN instead of deleting it
- How to standardise inconsistent timestamps using INTERVAL
- How to combine temp tables and chained CTEs in a single pipeline
- How to build a table-driven alerting system

---

## Quick Setup

```sql
-- Run in pgAdmin (takes a few seconds)
\i setup.sql
```

Or open [`setup.sql`](setup.sql) and run the full script manually.

<details>
<summary>Verify your setup</summary>

```sql
-- Check your tables loaded correctly
SELECT 'fleet_vehicles' AS table_name, COUNT(*) AS row_count FROM fleet_vehicles
UNION ALL
SELECT 'sensor_readings', COUNT(*) FROM sensor_readings
UNION ALL
SELECT 'maintenance_log', COUNT(*) FROM maintenance_log;
```

You should see 20 rows in `fleet_vehicles`, 500 rows in `sensor_readings`, and 20 rows in `maintenance_log`.

</details>

---

---

<p align="center">
  <a href="https://www.youtube.com/@sdw-online?sub_confirmation=1"><img src="../assets/banners/support-creator.svg" width="800" alt="Subscribe on YouTube"></a>
</p>

## Exercises

You are an IoT data engineer at a UK-based renewable energy company. The company manages solar panels, battery storage units, and wind turbines across six sites - Edinburgh down to Gatwick.

The head of operations, **Kwame Osei**, has called an urgent meeting. Three things landed on his desk this morning:

1. **Dashboard readings are unreliable.** The monitoring team reports gaps in data, sensors reporting impossible values (a battery unit at 55 degrees?), and timestamps that don't line up across sites.
2. **No alerting system.** When a device goes out of range, nobody finds out until a field engineer spots it on-site.
3. **No hourly health summaries.** The current system shows thousands of raw rows per day. Kwame needs one row per device per hour with a health status the dashboard can actually consume.

Your task: build a SQL pipeline that takes raw sensor readings and transforms them into clean, validated, hourly device health summaries. The pipeline has four stages: Raw -> Cleaned -> Aggregated -> Alerting.

This project uses everything from Days 8-13: COALESCE, CASE WHEN, string functions, date functions, CAST, subqueries, temp tables, and CTEs. Each phase builds on the last.

### Step 1 - Explore the Raw Data

Start with two exploration queries. First, join `devices` to `sites` to map every device to its physical location, region, status, and firmware version. Second, count readings per device using a `LEFT JOIN` (so devices with zero readings still appear) and find the earliest and latest reading timestamp per device. You should see 18 devices across 6 sites - 6 Solar Panels, 6 Battery Units, 6 Wind Turbines. One device is `Offline`, one is in `Maintenance`. Make a note of which ones.

### Step 2 - Audit Data Quality

Run three audit queries before touching anything. Check how many readings have NULL values across each sensor column (`temperature_c`, `humidity_pct`, `power_output_kw`, `voltage`, `signal_strength_dbm`, `battery_level_pct`). Check how readings are split across timezones (`raw_timezone`) - you should find readings in UTC, BST, and EST. Find out-of-range readings: Battery Units where temperature is outside 10-40 degrees, and Wind Turbines where `power_output_kw` is negative. These are your three categories of bad data.

### Step 3 - Flag and Clean the Data

Write a `CASE WHEN` expression that classifies every reading as one of four quality labels: `NULL_DROPOUT` (both temperature and power are NULL), `TEMP_OUT_OF_RANGE` (Battery Unit outside 10-40 degrees), `NEGATIVE_POWER` (Wind Turbine with negative output), or `VALID`. Do not delete anything - flag it. Then write the timezone correction: BST readings subtract 1 hour to get UTC; EST readings add 5 hours. Preview both transformations with a SELECT before you build the temp table.

### Step 4 - Build the Cleaning Layer (Temp Table)

Create a temp table called `cleaned_readings` that combines all transformations from Step 3 into one place. It should: standardise every timestamp to UTC, extract the reading hour with `DATE_TRUNC('hour', ...)`, clean NULLs with `COALESCE` (use `0.0` for numeric sensors, `-99` for signal strength), impute NULL battery readings for Battery Units with that device's own average (use a correlated subquery), and attach the quality flag. Join `sensor_readings` to `devices` and `sites` so every row carries device type, site name, and region. Verify: `SELECT COUNT(*) FROM cleaned_readings` - it should match your total raw reading count.

### Step 5 - Build the Aggregation Layer (CTE Pipeline)

Using `cleaned_readings` as your base, write a three-step CTE pipeline. CTE 1 (`valid_readings`): filter to `reading_quality = 'VALID'` only. CTE 2 (`hourly_aggregates`): group by `device_id`, `device_code`, `device_type`, `site_name`, `region`, and `reading_hour` - aggregate average, min, and max temperature; average and peak power; average voltage; average signal strength; average battery level. CTE 3 (`device_health`): add three computed columns - a `signal_health` score (100/80/60/40/20 based on signal dBm thresholds), an `operational_status` label (Idle / Generating / Charging / Discharging / Unknown based on device type and power output), and a `battery_status` label (Healthy / Moderate / Low / Critical / N/A). The final SELECT should order by `reading_hour` then `device_code`.

### Step 6 - Build the Alerting Layer

The `alert_rules` table defines thresholds per device type and metric. Start by querying it to understand what rules exist and which are enabled (`is_enabled = TRUE`). Then write a CTE called `violations` that joins `cleaned_readings` to `alert_rules` on `device_type`, extracts the actual sensor value for each rule's `metric_name` using `CASE`, and flags whether that value falls outside `min_threshold` and `max_threshold`. Filter to valid readings and enabled rules only. The outer query returns one row per violation with a `violation_detail` column explaining whether the value was below minimum or above maximum. Finish with an alert summary: count violations by `device_code`, `severity`, and `site_name`, ordered by severity.

### Step 7 - Assemble the Full Pipeline in One Query

Combine everything into a single CTE chain - no temp table required. The chain: `cleaned` (raw -> standardised timestamps + COALESCE + quality flags) -> `valid_only` (filter to VALID) -> `hourly_agg` (aggregate per device per hour) -> `health_scored` (add signal health, operational status, battery status, and an `overall_health` label). Output one row per device per hour. This is the query that would power Kwame's dashboard.

### Step 8 - Validate and Recommend

Run three final checks. A fleet overview scorecard: total devices, online devices, active sites, valid readings, dropout readings, and an overall data quality percentage. A power generation summary by device type: total kW generated, average output per reading, peak output, dropout count. A data quality report per device: valid count, dropout count, anomaly count, quality percentage, and a `quality_verdict` of Acceptable / Review needed / Action required. Close with a recommendations query that identifies the device with the EST firmware bug and confirms which device is fully offline.

### Solutions

Finished? Check your answers: [`solutions.sql`](solutions.sql)

---

## Key Concepts

- **Explore first, clean second, analyse third**: The standard workflow for any real data project - never build a pipeline on data you haven't audited
- **Flag, don't delete**: CASE WHEN quality labels preserve bad rows for investigation and audit trails rather than silently dropping them
- **Temp tables for multi-phase pipelines**: Store intermediate results when you need to reference the same cleaned dataset across multiple later queries
- **Chained CTEs for readability**: Each CTE does one job; the chain reads like a sequence of named steps rather than nested subqueries
- **Table-driven alerting**: Storing thresholds in a separate table (alert_rules) means you update rules without touching pipeline code

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-14-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-13/">&#9664; Day 13: CTEs (Part 1)</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-15/">Day 15: JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER &#9654;</a>
</p>

---

<!-- CLIFFHANGER -->
<p align="center"><sub><b>UP NEXT</b></sub></p>
<p align="center"><a href="https://www.youtube.com/watch?v=wtBxs_iDLo4"><img src="https://img.youtube.com/vi/wtBxs_iDLo4/maxresdefault.jpg" width="480" alt="Day 15 - JOINs Part 1"/></a></p>
<p align="center"><b>Day 15 &nbsp;&middot;&nbsp; JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER</b></p>
<p align="center"><i>JOINs look easy until they silently drop your data.</i></p>
<!-- /CLIFFHANGER -->
