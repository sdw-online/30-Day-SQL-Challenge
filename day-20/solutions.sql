-- ============================================
-- DAY 20 SOLUTIONS: Data Modelling and Star Schema
-- ============================================
-- Dataset: renewable-energy generation star schema.
-- generation_fact sits in the middle. sites, regions and time_periods are the
-- dimensions. site_region_supply is a BRIDGE - it is the only path from a site
-- to its regions, because region is deliberately NOT a column on the fact.
--
-- Run setup.sql (or exercise.sql) first.

-- ============================================
-- Task 1: Explore the Model
-- ============================================
-- Before querying a star schema, look at its shape. Count every table so you
-- know which one is the fact (the big one) and which are the dimensions (the
-- small ones). 96 generation rows against 8 sites is the giveaway.
SELECT 'sites' AS table_name, COUNT(*) AS row_count FROM sites
UNION ALL
SELECT 'regions', COUNT(*) FROM regions
UNION ALL
SELECT 'time_periods', COUNT(*) FROM time_periods
UNION ALL
SELECT 'generation_fact', COUNT(*) FROM generation_fact
UNION ALL
SELECT 'site_region_supply', COUNT(*) FROM site_region_supply;

-- Peek at the fact table. Note what is here: foreign keys and measures
-- (kwh_generated, cost_usd). No names, no descriptions. That is the point.
SELECT *
FROM generation_fact
LIMIT 10;

-- Peek at the bridge. Two columns, both keys, no measures. A bridge carries
-- nothing but the relationship it resolves.
SELECT *
FROM site_region_supply
LIMIT 10;

-- ============================================
-- Task 2: Through the Bridge
-- ============================================
-- How many sites feed each region? You cannot answer this from the fact table
-- alone - there is no region_id on generation_fact. The bridge is the only
-- route, so the join starts there.
SELECT
    r.region_name,
    COUNT(srs.site_id) AS site_count
FROM site_region_supply srs
JOIN regions r ON srs.region_id = r.region_id
GROUP BY r.region_name
ORDER BY site_count DESC;

-- Which regions does each renewable site supply? Same bridge, walked the other
-- way, with the is_renewable flag on the sites dimension doing the filtering.
-- A site appearing more than once is not a duplicate - it genuinely supplies
-- several regions.
SELECT
    s.site_name,
    r.region_name
FROM site_region_supply srs
JOIN sites s ON srs.site_id = s.site_id
JOIN regions r ON srs.region_id = r.region_id
WHERE s.is_renewable = TRUE
ORDER BY s.site_name, r.region_name;

-- ============================================
-- Task 3: Renewable vs Non-Renewable Share
-- ============================================
-- The capstone question, and the payoff of the model: a clean star query off
-- the fact plus ONE dimension. No bridge needed here, because the question is
-- about energy source, not region - and going through the bridge would
-- double-count every site that supplies more than one region.
--
-- source_totals groups the generation into two buckets. grand_total collapses
-- those buckets into a single number, and the CROSS JOIN pins that one number
-- against every row so each bucket can be expressed as a percentage.
WITH source_totals AS (
    SELECT
        CASE WHEN s.is_renewable THEN 'Renewable' ELSE 'Non-Renewable' END AS energy_source,
        SUM(gf.kwh_generated) AS total_kwh
    FROM generation_fact gf
    JOIN sites s ON gf.site_id = s.site_id
    GROUP BY CASE WHEN s.is_renewable THEN 'Renewable' ELSE 'Non-Renewable' END
),
grand_total AS (
    SELECT SUM(total_kwh) AS all_kwh
    FROM source_totals
)
SELECT
    st.energy_source,
    st.total_kwh,
    ROUND(st.total_kwh * 100.0 / gt.all_kwh, 1) AS pct_of_total
FROM source_totals st
CROSS JOIN grand_total gt
ORDER BY st.total_kwh DESC;
