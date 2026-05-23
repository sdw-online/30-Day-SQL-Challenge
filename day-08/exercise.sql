-- ============================================
-- DAY 8 EXERCISE: menu_items for Bean & Leaf coffee shop
-- ============================================
-- A coffee shop menu with real-world NULL patterns:
--   - Items with no cost price recorded (NULL cost_price)
--   - Items with no supplier on file (NULL supplier_name)
--   - Items with no assigned category (NULL category)
--   - Low-stock items with no supplier = urgent procurement gap

DROP TABLE IF EXISTS menu_items;

CREATE TABLE menu_items (
    item_id         SERIAL PRIMARY KEY,
    item_name       VARCHAR(100)    NOT NULL,
    category        VARCHAR(50),
    sell_price      NUMERIC(6, 2)   NOT NULL,
    cost_price      NUMERIC(6, 2),
    stock_quantity  INTEGER         NOT NULL DEFAULT 0,
    supplier_name   VARCHAR(100),
    supplier_email  VARCHAR(100)
);

-- ============================================
-- INSERT: 20 menu items with intentional NULL patterns
-- ============================================
-- Pattern 1: 5 items have no cost_price (wholesale cost not recorded)
-- Pattern 2: 8 items have no supplier_name (no supplier on file)
-- Pattern 3: 4 items have no category (uncategorised)
-- Pattern 4: 3 low-stock items with no supplier = procurement blind spot

INSERT INTO menu_items
    (item_name, category, sell_price, cost_price, stock_quantity, supplier_name, supplier_email)
VALUES
    ('Espresso',            'Hot Drinks',   2.80,   1.20,   150,  'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Flat White',          'Hot Drinks',   3.50,   1.50,   120,  'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Iced Latte',          'Cold Drinks',  4.20,   1.80,   80,   'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Matcha Latte',        'Hot Drinks',   4.50,   NULL,   45,   NULL,               NULL),
    ('Croissant',           'Pastries',     3.20,   1.40,   200,  'Daily Bakes',      'hello@dailybakes.co.uk'),
    ('Banana Bread',        'Pastries',     3.80,   1.60,   65,   NULL,               NULL),
    ('Avocado Toast',       'Food',         7.50,   3.20,   30,   'FreshBox',         'supply@freshbox.co.uk'),
    ('Granola Bowl',        'Food',         6.80,   NULL,   25,   'FreshBox',         'supply@freshbox.co.uk'),
    ('Chai Latte',          'Hot Drinks',   3.90,   1.70,   90,   'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Cold Brew',           'Cold Drinks',  4.00,   1.50,   12,   NULL,               NULL),
    ('Blueberry Muffin',    'Pastries',     3.50,   NULL,   110,  NULL,               NULL),
    ('Sourdough Sandwich',  'Food',         6.50,   2.80,   40,   'FreshBox',         'supply@freshbox.co.uk'),
    ('Turmeric Latte',      NULL,           4.80,   2.10,   15,   NULL,               NULL),
    ('Protein Ball',        NULL,           2.50,   NULL,   8,    NULL,               NULL),
    ('Sparkling Water',     'Cold Drinks',  2.20,   0.80,   180,  NULL,               NULL),
    ('Oat Milk Extra',      NULL,           0.60,   0.30,   300,  'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Loyalty Card Top-up', NULL,           10.00,  NULL,   999,  NULL,               NULL),
    ('Hot Chocolate',       'Hot Drinks',   3.80,   1.60,   70,   'BeanSource Ltd',   'orders@beansource.co.uk'),
    ('Lemon Drizzle Cake',  'Pastries',     4.20,   1.90,   50,   'Daily Bakes',      'hello@dailybakes.co.uk'),
    ('Breakfast Wrap',      'Food',         5.50,   2.40,   35,   'FreshBox',         'supply@freshbox.co.uk');

-- Verify: Expected 20 rows
SELECT COUNT(*) AS total_items FROM menu_items;

-- Verify NULL distribution: Expected missing_supplier=8, missing_category=4, missing_cost=5
SELECT
    COUNT(*) - COUNT(supplier_name) AS missing_supplier,
    COUNT(*) - COUNT(category)      AS missing_category,
    COUNT(*) - COUNT(cost_price)    AS missing_cost
FROM menu_items;
