-- ============================================
-- DAY 7 SOLUTIONS: Project - Freight & Logistics
-- ============================================

-- Step 1: Explore the data
SELECT COUNT(*) FROM depots;
SELECT COUNT(*) FROM vehicles;
SELECT COUNT(*) FROM shipments;
SELECT status, COUNT(*) FROM shipments GROUP BY status;

-- Step 2: Find mislabelled "delivered" (delivered but no delivery_date)
SELECT *
FROM shipments
WHERE status = 'delivered' AND delivery_date IS NULL;

-- Step 3: Fix mislabelled "delivered" -> "pending"
UPDATE shipments
SET status = 'pending'
WHERE status = 'delivered' AND delivery_date IS NULL;

-- Step 4: Find mislabelled "in_transit" (in_transit but has delivery_date)
SELECT *
FROM shipments
WHERE status = 'in_transit' AND delivery_date IS NOT NULL;

-- Step 5: Fix mislabelled "in_transit" -> "delivered"
UPDATE shipments
SET status = 'delivered'
WHERE status = 'in_transit' AND delivery_date IS NOT NULL;

-- Step 6: Find duplicate tracking codes
SELECT tracking_code, COUNT(*)
FROM shipments
GROUP BY tracking_code
HAVING COUNT(*) > 1;

-- Step 7: Remove duplicates (higher shipment_id = migration copy)
DELETE FROM shipments
WHERE shipment_id IN (
    SELECT MAX(shipment_id)
    FROM shipments
    GROUP BY tracking_code
    HAVING COUNT(*) > 1
);

-- Step 8: Executive summary
-- Total shipments by status
SELECT status, COUNT(*) AS shipment_count
FROM shipments
GROUP BY status
ORDER BY shipment_count DESC;

-- Shipments per depot
SELECT d.depot_name, COUNT(s.shipment_id) AS shipment_count
FROM depots d
LEFT JOIN shipments s ON d.depot_id = s.origin_depot_id
GROUP BY d.depot_name
ORDER BY shipment_count DESC;

-- Total revenue by region
SELECT d.region, SUM(s.freight_charge) AS total_revenue
FROM shipments s
JOIN depots d ON s.origin_depot_id = d.depot_id
GROUP BY d.region
ORDER BY total_revenue DESC;

-- Overall delivery rate
SELECT
    ROUND(
        COUNT(CASE WHEN status = 'delivered' THEN 1 END) * 100.0 / COUNT(*), 1
    ) AS delivery_rate_pct
FROM shipments;
