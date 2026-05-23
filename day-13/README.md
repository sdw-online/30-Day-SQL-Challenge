# Day 13 - CTEs (Part 1)

[Watch the video](https://youtu.be/IijQJAfqcJc) | [← Day 12: Subqueries & Temp Tables](../day-12/) | [Day 14: Project: Fleet Intelligence Pipeline →](../day-14/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What Common Table Expressions (CTEs) are and how the WITH keyword works
- How to define multiple CTEs in a single query, separated by commas
- How to chain CTEs into multi-step pipelines where each step feeds the next
- When to use a CTE versus a subquery versus a temp table
- Naming conventions that make your CTEs self-documenting

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-12
- Comfortable with SELECT, WHERE, GROUP BY, aggregate functions, subqueries, and temp tables

## Dataset

Today uses two sets of tables:

**Teaching tables:** Cooking recipe data - 15 ingredients across 5 categories, and 24 recipe steps across 5 recipes.

**Exercise table:** Supply chain traceability data - 25 stages tracking 4 products from farm to shelf.

Run the SQL in [setup.sql](setup.sql) to create the teaching tables, or run [exercise.sql](exercise.sql) for just the exercise table.

<details>
<summary>Click to expand full setup SQL</summary>

```sql
-- ============================================
-- DAY 13 SETUP: Recipe + Supply Chain data
-- ============================================

-- Teaching tables
DROP TABLE IF EXISTS recipe_steps;
DROP TABLE IF EXISTS ingredients;

CREATE TABLE ingredients (
    ingredient_id   SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL,
    category        VARCHAR(50)  NOT NULL,
    unit_price      NUMERIC(6,2) NOT NULL,
    unit_type       VARCHAR(20)  NOT NULL
);

INSERT INTO ingredients
    (ingredient_name, category, unit_price, unit_type)
VALUES
    ('Chicken Thigh',    'protein',  6.50, 'kg'),
    ('Salmon Fillet',    'protein',  12.80, 'kg'),
    ('Tofu',             'protein',  3.20, 'kg'),
    ('Basmati Rice',     'grain',    2.40, 'kg'),
    ('Spaghetti',        'grain',    1.80, 'kg'),
    ('Sourdough Bread',  'grain',    3.50, 'piece'),
    ('Broccoli',         'produce',  2.10, 'kg'),
    ('Tomatoes',         'produce',  2.80, 'kg'),
    ('Garlic',           'produce',  0.90, 'piece'),
    ('Cheddar Cheese',   'dairy',    5.60, 'kg'),
    ('Double Cream',     'dairy',    2.40, 'litre'),
    ('Butter',           'dairy',    3.10, 'kg'),
    ('Cumin',            'spice',    4.20, 'kg'),
    ('Paprika',          'spice',    5.10, 'kg'),
    ('Black Pepper',     'spice',    6.80, 'kg');

CREATE TABLE recipe_steps (
    step_id          SERIAL PRIMARY KEY,
    recipe_id        INTEGER      NOT NULL,
    recipe_name      VARCHAR(100) NOT NULL,
    step_number      INTEGER      NOT NULL,
    step_description VARCHAR(200) NOT NULL,
    duration_minutes INTEGER      NOT NULL,
    ingredient_used  VARCHAR(100) NOT NULL
);

INSERT INTO recipe_steps
    (recipe_id, recipe_name, step_number, step_description, duration_minutes, ingredient_used)
VALUES
    (1, 'Chicken Stir Fry',      1, 'Dice the chicken thigh',         10, 'Chicken Thigh'),
    (1, 'Chicken Stir Fry',      2, 'Chop the broccoli florets',       5, 'Broccoli'),
    (1, 'Chicken Stir Fry',      3, 'Mince the garlic cloves',         3, 'Garlic'),
    (1, 'Chicken Stir Fry',      4, 'Stir fry everything together',   12, 'Cumin'),
    (1, 'Chicken Stir Fry',      5, 'Serve over basmati rice',         15, 'Basmati Rice'),
    (2, 'Salmon Pasta',          1, 'Boil the spaghetti',             12, 'Spaghetti'),
    (2, 'Salmon Pasta',          2, 'Season the salmon fillet',         5, 'Salmon Fillet'),
    (2, 'Salmon Pasta',          3, 'Pan-sear the salmon',            10, 'Black Pepper'),
    (2, 'Salmon Pasta',          4, 'Make the cream sauce',             8, 'Double Cream'),
    (2, 'Salmon Pasta',          5, 'Toss pasta with sauce',            5, 'Butter'),
    (3, 'Tomato Soup',           1, 'Dice the tomatoes',                8, 'Tomatoes'),
    (3, 'Tomato Soup',           2, 'Saute the garlic',                 5, 'Garlic'),
    (3, 'Tomato Soup',           3, 'Simmer with paprika',             20, 'Paprika'),
    (3, 'Tomato Soup',           4, 'Blend until smooth',               5, 'Double Cream'),
    (4, 'Tofu Rice Bowl',        1, 'Press and cube the tofu',         10, 'Tofu'),
    (4, 'Tofu Rice Bowl',        2, 'Cook the basmati rice',           15, 'Basmati Rice'),
    (4, 'Tofu Rice Bowl',        3, 'Season with cumin and paprika',    3, 'Cumin'),
    (4, 'Tofu Rice Bowl',        4, 'Pan-fry the tofu cubes',         10, 'Black Pepper'),
    (4, 'Tofu Rice Bowl',        5, 'Top with grated cheddar',          2, 'Cheddar Cheese'),
    (5, 'Cheesy Garlic Bread',   1, 'Slice the sourdough loaf',         5, 'Sourdough Bread'),
    (5, 'Cheesy Garlic Bread',   2, 'Mix butter with minced garlic',    5, 'Butter'),
    (5, 'Cheesy Garlic Bread',   3, 'Spread garlic butter on bread',    3, 'Garlic'),
    (5, 'Cheesy Garlic Bread',   4, 'Grate cheddar over the top',       2, 'Cheddar Cheese'),
    (5, 'Cheesy Garlic Bread',   5, 'Bake until golden',              10, 'Paprika');

-- Exercise table
DROP TABLE IF EXISTS supply_chain_stages;

CREATE TABLE supply_chain_stages (
    stage_id       SERIAL PRIMARY KEY,
    product_name   VARCHAR(100) NOT NULL,
    stage_name     VARCHAR(100) NOT NULL,
    stage_order    INTEGER      NOT NULL,
    location       VARCHAR(100) NOT NULL,
    cost           NUMERIC(8,2) NOT NULL,
    duration_days  INTEGER      NOT NULL,
    supplier_name  VARCHAR(100) NOT NULL,
    certification  VARCHAR(50)  NOT NULL
);

INSERT INTO supply_chain_stages
    (product_name, stage_name, stage_order, location, cost, duration_days, supplier_name, certification)
VALUES
    ('Organic Coffee',   'Harvesting',        1, 'Bogota',        1200.00,  14, 'Javier',   'Fair Trade'),
    ('Organic Coffee',   'Washing',           2, 'Bogota',         350.00,   3, 'Elena',    'Organic'),
    ('Organic Coffee',   'Drying',            3, 'Bogota',         280.00,   7, 'Javier',   'Organic'),
    ('Organic Coffee',   'Roasting',          4, 'Rotterdam',      900.00,   2, 'Magnus',   'ISO 9001'),
    ('Organic Coffee',   'Packaging',         5, 'Rotterdam',      420.00,   1, 'Magnus',   'ISO 9001'),
    ('Organic Coffee',   'Distribution',      6, 'London',         680.00,   5, 'Nils',     'BRC'),
    ('Dark Chocolate',   'Harvesting',        1, 'Accra',         1500.00,  21, 'Kiran',    'Fair Trade'),
    ('Dark Chocolate',   'Fermentation',      2, 'Accra',          600.00,   7, 'Kiran',    'Organic'),
    ('Dark Chocolate',   'Drying',            3, 'Accra',          320.00,   5, 'Kiran',    'Organic'),
    ('Dark Chocolate',   'Grinding',          4, 'Brussels',       750.00,   2, 'Camila',   'ISO 9001'),
    ('Dark Chocolate',   'Tempering',         5, 'Brussels',       880.00,   1, 'Camila',   'ISO 9001'),
    ('Dark Chocolate',   'Packaging',         6, 'Brussels',       390.00,   1, 'Lucia',    'BRC'),
    ('Dark Chocolate',   'Distribution',      7, 'Manchester',     720.00,   4, 'Nils',     'BRC'),
    ('Green Tea',        'Harvesting',        1, 'Kyoto',          980.00,  10, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Steaming',          2, 'Kyoto',          450.00,   1, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Rolling',           3, 'Kyoto',          380.00,   2, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Drying',            4, 'Kyoto',          290.00,   3, 'Dev',      'JAS Organic'),
    ('Green Tea',        'Grading',           5, 'Osaka',          520.00,   2, 'Elena',    'ISO 9001'),
    ('Green Tea',        'Packaging',         6, 'Osaka',          340.00,   1, 'Elena',    'ISO 9001'),
    ('Green Tea',        'Distribution',      7, 'Edinburgh',      610.00,   6, 'Lucia',    'BRC'),
    ('Olive Oil',        'Harvesting',        1, 'Seville',       1100.00,  12, 'Javier',   'EU Organic'),
    ('Olive Oil',        'Pressing',          2, 'Seville',        650.00,   1, 'Javier',   'EU Organic'),
    ('Olive Oil',        'Filtering',         3, 'Seville',        420.00,   2, 'Camila',   'ISO 9001'),
    ('Olive Oil',        'Bottling',          4, 'Barcelona',      380.00,   1, 'Camila',   'ISO 9001'),
    ('Olive Oil',        'Distribution',      5, 'Bristol',        590.00,   5, 'Nils',     'BRC');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM ingredients;
-- Expected: 15 rows

SELECT COUNT(*) FROM recipe_steps;
-- Expected: 24 rows

SELECT COUNT(*) FROM supply_chain_stages;
-- Expected: 25 rows
```

## Exercises

You are a data analyst working with the Head of Supply Chain Compliance, Claire Foster. She needs a traceability report that flags high-risk stages across your food supply chain.

Using the `supply_chain_stages` table, complete the tasks below.

### Task 1: Preview the Data

Write a query to explore the supply chain data. How many records are there? How many products? How many unique stages and locations?

### Task 2: Total Cost per Processing Stage

Write a CTE called `stage_costs` that calculates the total cost for each stage name across all products. In the main query, show each stage name and its total cost, sorted from most expensive to least.

### Task 3: Product-Level Summary

Write a CTE called `product_summary` that calculates each product's total cost and total duration (in days) across all stages. In the main query, show each product alongside its total cost, total days, and the number of stages it passes through.

### Task 4: Find the Bottleneck Stages

Build a two-CTE pipeline. The first CTE (`cost_per_day`) calculates the cost per day for each stage (cost / duration_days). The second CTE (`avg_cost_per_day`) calculates the overall average cost per day across all stages. In the main query, show only the stages where cost per day is above the overall average - these are the bottleneck stages Claire needs to escalate.

## Key Concepts Covered
- **WITH keyword:** Defines named temporary result sets at the top of a query, referenced like tables below
- **Multiple CTEs:** Separated by commas, not by repeating WITH - you only write WITH once
- **CTE chaining:** Later CTEs can reference earlier ones, creating a top-to-bottom pipeline
- **CTE vs subquery vs temp table:** CTEs for multi-step logic in one query, subqueries for simple one-off filters, temp tables for reuse across multiple queries
- **Naming conventions:** Use descriptive names like `stage_costs` and `product_summary` - never `temp`, `sub`, or `cte1`
- **Performance:** In modern PostgreSQL (12+), non-recursive CTEs referenced once are inlined automatically

---

[← Day 12: Subqueries & Temp Tables](../day-12/) | [Day 14: Project: Fleet Intelligence Pipeline →](../day-14/)
