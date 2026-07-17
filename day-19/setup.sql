-- Day 19: Recursive CTEs - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

-- ============================================
-- DAY 19 SETUP: Recursive CTE practice data
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS family_tree;

-- ============================================
-- TABLE 1: family_tree (teaching - descendants of one matriarch)
-- ============================================
-- Each row is one person in the family
-- parent_id references the person's parent in this family (self-referencing)
-- NULL parent_id means this is the root ancestor (Ada)
-- We track Ada's bloodline: each person points to the one parent
-- who descends from Ada (spouses who married in are not nodes here)

CREATE TABLE family_tree (
    person_id   SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    parent_id   INTEGER      REFERENCES family_tree(person_id),
    birth_year  INTEGER      NOT NULL
);

-- ============================================
-- TABLE 2: suppliers (exercise - supply chain tiers)
-- ============================================
-- Each row is one supplier in a supply chain
-- parent_supplier_id references another supplier (self-referencing)
-- NULL parent_supplier_id means this is a Tier 1 supplier (direct)
-- product is what they supply
-- country is where they are based

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
-- INSERT DATA: family_tree (20 people, 5 generations)
-- ============================================
-- Generation 0: Ada, the root ancestor (no parent)
-- Generation 1: Ada's children
-- Generation 2: grandchildren
-- Generation 3: great-grandchildren
-- Generation 4: great-great-grandchildren

-- Generation 0: the matriarch (no parent)
INSERT INTO family_tree (name, parent_id, birth_year) VALUES
('Ada', NULL, 1938);

-- Generation 1: Ada's children (parent = 1)
INSERT INTO family_tree (name, parent_id, birth_year) VALUES
('Sam',  1, 1959),
('Rosa', 1, 1962),
('Leon', 1, 1965);

-- Generation 2: grandchildren
INSERT INTO family_tree (name, parent_id, birth_year) VALUES
('Mia',   2, 1981),   -- child of Sam
('Theo',  2, 1984),   -- child of Sam
('Nadia', 3, 1983),   -- child of Rosa
('Omar',  3, 1986),   -- child of Rosa
('Priya', 3, 1989),   -- child of Rosa
('Jack',  4, 1987);   -- child of Leon

-- Generation 3: great-grandchildren
INSERT INTO family_tree (name, parent_id, birth_year) VALUES
('Ella',   5, 2003),  -- child of Mia
('Finn',   5, 2006),  -- child of Mia
('Reuben', 6, 2008),  -- child of Theo
('Zara',   7, 2004),  -- child of Nadia
('Idris',  7, 2007),  -- child of Nadia
('Yusuf',  8, 2009),  -- child of Omar
('Lily',  10, 2010);  -- child of Jack

-- Generation 4: great-great-grandchildren
INSERT INTO family_tree (name, parent_id, birth_year) VALUES
('Noah',  11, 2022),  -- child of Ella
('Amara', 14, 2023),  -- child of Zara
('Kai',   14, 2024);  -- child of Zara


-- ============================================
-- INSERT DATA: suppliers (20 rows, supply chain hierarchy)
-- ============================================
-- Tier 1: Direct suppliers (no parent) - supply finished components
-- Tier 2: Sub-suppliers (parent = Tier 1) - supply processed materials
-- Tier 3: Raw material suppliers (parent = Tier 2)
-- Two product lines: Smartphones and Electric Vehicles

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

-- Validation: Check row counts
SELECT 'family_tree' AS table_name, COUNT(*) AS row_count FROM family_tree
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers;

-- Validation: Check root nodes (rows with no parent)
SELECT 'family_tree (root)' AS hierarchy, name AS root_node
FROM family_tree WHERE parent_id IS NULL
UNION ALL
SELECT 'suppliers (Tier 1)', supplier_name
FROM suppliers WHERE parent_supplier_id IS NULL;