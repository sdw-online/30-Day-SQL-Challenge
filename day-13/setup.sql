-- Day 13: CTEs (Part 1) - Setup Script
-- Teaching tables: ingredients (15 rows) + recipe_steps (24 rows)
-- Exercise table: supply_chain_stages (25 rows)

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
