-- ============================================
-- DAY 9 SOLUTIONS: String & Numeric Functions
-- ============================================

-- Task 1: Audit spacing issues
SELECT
    repair_id,
    road_name,
    LENGTH(road_name)        AS raw_length,
    LENGTH(TRIM(road_name))  AS trimmed_length,
    district,
    LENGTH(district)         AS district_raw,
    LENGTH(TRIM(district))   AS district_trimmed
FROM raw_road_repairs
WHERE LENGTH(road_name) != LENGTH(TRIM(road_name))
   OR LENGTH(district)  != LENGTH(TRIM(district));

-- Task 2: Clean text with TRIM and INITCAP
SELECT
    repair_ref,
    INITCAP(TRIM(road_name))  AS road_name_clean,
    UPPER(TRIM(district))     AS district_clean,
    TRIM(repair_type)         AS repair_type_clean
FROM raw_road_repairs;

-- Task 3: Cost variance with ROUND
SELECT
    repair_ref,
    TRIM(road_name)                                              AS road_name,
    ROUND(actual_cost - estimated_cost, 2)                       AS cost_variance,
    ROUND((actual_cost - estimated_cost) / estimated_cost * 100, 2) AS variance_pct
FROM raw_road_repairs;

-- Task 4: Extract city code with SUBSTRING
SELECT
    repair_ref,
    SUBSTRING(repair_ref FROM 4 FOR 3) AS city_code,
    TRIM(road_name)                    AS road_name
FROM raw_road_repairs;
