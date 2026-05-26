-- ============================================
-- DAY 13 SOLUTIONS: CTEs (Part 1)
-- ============================================

-- Task 1: Preview the data
SELECT COUNT(*)                    AS total_records FROM supply_chain_stages;
SELECT COUNT(DISTINCT product_name) AS total_products FROM supply_chain_stages;
SELECT COUNT(DISTINCT stage_name)   AS unique_stages FROM supply_chain_stages;
SELECT COUNT(DISTINCT location)     AS unique_locations FROM supply_chain_stages;

-- Task 2: Total cost per processing stage
WITH stage_costs AS (
    SELECT
        stage_name,
        SUM(cost) AS total_cost
    FROM supply_chain_stages
    GROUP BY stage_name
)
SELECT stage_name, total_cost
FROM stage_costs
ORDER BY total_cost DESC;

-- Task 3: Product-level summary
WITH product_summary AS (
    SELECT
        product_name,
        SUM(cost)           AS total_cost,
        SUM(duration_days)  AS total_days,
        COUNT(*)            AS stage_count
    FROM supply_chain_stages
    GROUP BY product_name
)
SELECT product_name, total_cost, total_days, stage_count
FROM product_summary
ORDER BY total_cost DESC;

-- Task 4: Find bottleneck stages (above-average cost per day)
WITH cost_per_day AS (
    SELECT
        stage_id,
        product_name,
        stage_name,
        location,
        cost,
        duration_days,
        ROUND(cost / duration_days, 2) AS cost_per_day
    FROM supply_chain_stages
),
avg_cost_per_day AS (
    SELECT ROUND(AVG(cost_per_day), 2) AS overall_avg
    FROM cost_per_day
)
SELECT
    cpd.product_name,
    cpd.stage_name,
    cpd.location,
    cpd.cost,
    cpd.duration_days,
    cpd.cost_per_day,
    acpd.overall_avg
FROM cost_per_day cpd
CROSS JOIN avg_cost_per_day acpd
WHERE cpd.cost_per_day > acpd.overall_avg
ORDER BY cpd.cost_per_day DESC;
