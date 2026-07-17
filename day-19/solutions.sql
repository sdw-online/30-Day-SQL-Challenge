-- ============================================
-- DAY 19 SOLUTIONS: Recursive CTEs
-- ============================================

-- Explore: preview the supplier data
-- The first four rows have no parent - those are the Tier 1 suppliers.
-- Every row after them points back to one of those first four.
SELECT *
FROM suppliers
LIMIT 10;

-- ============================================
-- Task 1: Map the Direct Suppliers
-- ============================================
-- The Tier 1 suppliers on their own - the rows whose parent is empty.
-- No recursion yet - this is just the anchor. Expected: 4 rows.
SELECT
    supplier_name,
    product,
    country,
    annual_cost
FROM suppliers
WHERE parent_supplier_id IS NULL
ORDER BY annual_cost DESC;

-- ============================================
-- Task 2: Trace the Full Chain, Tier by Tier
-- ============================================
-- The anchor grabs the Tier 1 suppliers and starts a tier counter at 1.
-- The recursive member finds everyone whose parent points at a supplier we
-- already have, adding 1 to the tier each level deeper.
-- Expected: 20 rows - 4 at Tier 1, 8 at Tier 2, 8 at Tier 3.
WITH RECURSIVE supply_chain AS (
    -- Anchor: all Tier 1 suppliers, labelled tier 1
    SELECT
        supplier_id, supplier_name, product, parent_supplier_id,
        country, annual_cost,
        1 AS tier
    FROM suppliers
    WHERE parent_supplier_id IS NULL

    UNION ALL

    -- Recursive member: find who supplies them, one tier deeper
    SELECT
        s.supplier_id, s.supplier_name, s.product, s.parent_supplier_id,
        s.country, s.annual_cost,
        sc.tier + 1
    FROM suppliers s
    JOIN supply_chain sc ON s.parent_supplier_id = sc.supplier_id
)
SELECT
    tier,
    supplier_name,
    product,
    country,
    annual_cost
FROM supply_chain
ORDER BY tier, annual_cost DESC;

-- ============================================
-- Task 3A: How deep does each chain run? (Capstone)
-- ============================================
-- Every row remembers which Tier 1 supplier it ultimately traces back to:
-- the anchor captures the Tier 1 name, the recursive member carries it down
-- unchanged. Group by that root supplier for the deepest tier and a count.
-- Expected: 4 rows - every chain runs 3 tiers deep with 5 suppliers each.
WITH RECURSIVE supply_chain AS (
    SELECT
        supplier_id, supplier_name, product, parent_supplier_id,
        1 AS tier,
        supplier_name AS root_supplier          -- remember the Tier 1 name
    FROM suppliers
    WHERE parent_supplier_id IS NULL

    UNION ALL

    SELECT
        s.supplier_id, s.supplier_name, s.product, s.parent_supplier_id,
        sc.tier + 1,
        sc.root_supplier                         -- pass it down unchanged
    FROM suppliers s
    JOIN supply_chain sc ON s.parent_supplier_id = sc.supplier_id
)
SELECT
    root_supplier,
    MAX(tier) AS deepest_tier,
    COUNT(*) AS total_suppliers
FROM supply_chain
GROUP BY root_supplier
ORDER BY deepest_tier DESC, total_suppliers DESC;

-- ============================================
-- Task 3B: A monthly timeline for 2025 (Capstone)
-- ============================================
-- No tree this time - the sequence pattern. Start at 2025-01-01, add one
-- month each pass, and stop when the loop reaches December.
-- Expected: 12 rows - January through December 2025.
WITH RECURSIVE timeline AS (
    SELECT DATE '2025-01-01' AS report_date

    UNION ALL

    SELECT (report_date + INTERVAL '1 month')::DATE
    FROM timeline
    WHERE report_date < DATE '2025-12-01'
)
SELECT
    report_date,
    TO_CHAR(report_date, 'Month YYYY') AS report_month
FROM timeline;
