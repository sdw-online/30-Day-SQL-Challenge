-- ============================================
-- DAY 8 SOLUTIONS: NULL Handling
-- ============================================

-- Task 1: Audit missing data counts
SELECT
    COUNT(*) - COUNT(cost_price)     AS missing_cost_price,
    COUNT(*) - COUNT(supplier_name)  AS missing_supplier_name,
    COUNT(*) - COUNT(category)       AS missing_category
FROM menu_items;

-- Task 2: Menu pricing with COALESCE for missing cost
SELECT
    item_name,
    sell_price,
    cost_price,
    COALESCE(cost_price::TEXT, 'Cost not recorded') AS display_cost
FROM menu_items;

-- Task 3: Uncategorised items
SELECT item_name, sell_price, stock_quantity
FROM menu_items
WHERE category IS NULL;

-- Task 4: Low-stock items with no supplier
SELECT item_name, stock_quantity, sell_price
FROM menu_items
WHERE stock_quantity < 20
  AND supplier_name IS NULL;
