-- Day 19: Recursive CTEs - Exercise Script
-- Exercise table: suppliers (20 rows across 3 tiers)

DROP TABLE IF EXISTS suppliers;

-- TABLE: suppliers
-- A supply chain where Tier 1 suppliers source from Tier 2, who source from
-- Tier 3. parent_supplier_id points to the supplier they supply to (their
-- parent in the chain); a NULL parent means a Tier 1 (direct) supplier.
CREATE TABLE suppliers (
    supplier_id        SERIAL PRIMARY KEY,
    supplier_name      VARCHAR(100)  NOT NULL,
    product            VARCHAR(100)  NOT NULL,
    parent_supplier_id INTEGER       REFERENCES suppliers(supplier_id),
    country            VARCHAR(60)   NOT NULL,
    annual_cost        NUMERIC(12,2) NOT NULL,
    lead_time_days     INTEGER       NOT NULL
);

-- ============================================
-- INSERT: 20 suppliers across 3 tiers, two product lines
-- ============================================

-- Tier 1: Direct suppliers (no parent)
INSERT INTO suppliers (supplier_name, product, parent_supplier_id, country, annual_cost, lead_time_days) VALUES
('Darcy Electronics', 'Smartphone Display', NULL, 'South Korea', 2400000.00, 14),
('Caleb Components', 'Smartphone Battery', NULL, 'Japan', 1800000.00, 21),
('Millie Motors', 'EV Battery Pack', NULL, 'Germany', 5200000.00, 28),
('Taiwo Steel', 'EV Chassis Frame', NULL, 'Brazil', 3100000.00, 35);

-- Tier 2: Sub-suppliers (parent = Tier 1)
INSERT INTO suppliers (supplier_name, product, parent_supplier_id, country, annual_cost, lead_time_days) VALUES
('Kehinde Glass', 'Display Glass Panel', 1, 'China', 850000.00, 10),
('Reeves Chemicals', 'LCD Chemical Coating', 1, 'Taiwan', 420000.00, 7),
('Hargrove Metals', 'Battery Cathode', 2, 'Australia', 620000.00, 18),
('Sinclair Mining', 'Lithium Carbonate', 2, 'Chile', 980000.00, 25),
('Beck Cells', 'Battery Cell Module', 3, 'Poland', 1900000.00, 14),
('Torres Wiring', 'Wiring Harness', 3, 'Mexico', 750000.00, 10),
('Okonjo Alloys', 'High-Strength Steel', 4, 'India', 1100000.00, 21),
('Whitmore Rubber', 'Suspension Components', 4, 'Thailand', 680000.00, 12);

-- Tier 3: Raw material suppliers (parent = Tier 2)
INSERT INTO suppliers (supplier_name, product, parent_supplier_id, country, annual_cost, lead_time_days) VALUES
('Nakano Silica', 'Silica Sand', 5, 'Vietnam', 210000.00, 8),
('Chen Minerals', 'Rare Earth Elements', 6, 'Mongolia', 380000.00, 15),
('Adler Ore', 'Nickel Ore', 7, 'Indonesia', 450000.00, 20),
('Cruz Brine', 'Lithium Brine', 8, 'Argentina', 520000.00, 30),
('Novak Cobalt', 'Cobalt Powder', 9, 'Congo', 890000.00, 22),
('Lima Copper', 'Copper Wire Stock', 10, 'Peru', 340000.00, 14),
('Desai Iron', 'Iron Ore', 11, 'India', 290000.00, 18),
('Pham Latex', 'Natural Rubber', 12, 'Vietnam', 180000.00, 10);

-- ============================================
-- EXERCISES
-- ============================================
-- You work on the data team at a manufacturer. Ifeoma, the Supply Chain
-- Director, needs the full supplier network mapped for the quarterly review.
-- Her brief:
--
--   "I need the full supplier network mapped for the quarterly review.
--    Preview the data first. Show me all my Tier 1 suppliers. Trace the
--    full chain from Tier 1 down to Tier 3. Tell me how deep each product
--    line's chain goes. And give me a monthly timeline for my review
--    schedule."
--
-- You have one table: suppliers - 20 records across 3 tiers.
-- Tier 1 suppliers have no parent (parent_supplier_id IS NULL); every other
-- supplier points back to the supplier it supplies.

-- Explore: preview the supplier data
--
-- Before writing any recursive queries, look at what you are working with.
-- Preview the first 10 rows and notice which rows have no parent (Tier 1)
-- and which point back to one of them.

-- Write your query here:


-- Task 1: Map the Direct Suppliers
--
-- Pull out the Tier 1 suppliers on their own - the direct companies the
-- business deals with face to face. These are the rows with no parent.
-- Return supplier_name, product, country and annual_cost, most expensive
-- first. No recursion yet - this is just the anchor on its own.
-- Expected: 4 rows (Millie Motors $5.2m, Taiwo Steel $3.1m,
-- Darcy Electronics $2.4m, Caleb Components $1.8m).

-- Write your query here:


-- Task 2: Trace the Full Chain, Tier by Tier
--
-- Write a recursive CTE that returns every supplier across all three tiers,
-- with a tier column labelling which level each one sits in. The anchor
-- grabs the Tier 1 suppliers and starts a tier counter at 1; the recursive
-- member finds everyone whose parent points at a supplier already found and
-- adds 1 to the tier each level deeper. Return tier, supplier_name, product,
-- country and annual_cost, ordered by tier then annual_cost descending.
-- Expected: 20 rows - 4 at Tier 1, 8 at Tier 2, 8 at Tier 3.

-- Write your query here:


-- Task 3: Ifeoma's Final Reports (Capstone)
--
-- 3A. How deep does each chain run? Extend the recursive CTE so every row
--     remembers which Tier 1 supplier it ultimately traces back to (the
--     anchor captures the Tier 1 name, the recursive member carries it down
--     unchanged). Group by that root supplier and return the deepest tier and
--     the total number of suppliers in each chain.
--     Expected: 4 rows - every chain runs 3 tiers deep with 5 suppliers each.
--
-- 3B. Build a monthly timeline for 2025 for Ifeoma's review schedule. No tree
--     this time - use the sequence pattern: start at 2025-01-01, add one month
--     each pass, and stop when you reach December. Return the report_date and
--     a formatted month label.
--     Expected: 12 rows - January through December 2025.

-- Write your queries here:
