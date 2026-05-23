-- ============================================
-- DAY 11 SETUP: meal_plans table for CASE WHEN
-- ============================================

DROP TABLE IF EXISTS meal_plans;

CREATE TABLE meal_plans (
    plan_id         SERIAL PRIMARY KEY,
    person_name     VARCHAR(50),
    fitness_goal    VARCHAR(20),
    age             INTEGER,
    weight_kg       NUMERIC(4,1),
    daily_calories  INTEGER,
    preferred_diet  VARCHAR(20),
    activity_level  VARCHAR(20)
);

INSERT INTO meal_plans
    (person_name, fitness_goal, age, weight_kg, daily_calories, preferred_diet, activity_level)
VALUES
    ('Bella',    'build_muscle',   28, 68.5, 2800, 'standard',     'very_active'),
    ('Declan',   'endurance',      35, 74.2, 2600, 'standard',     'very_active'),
    ('Daphne',   'weight_loss',    42, 85.0, 1600, 'standard',     'moderate'),
    ('Felix',    'digestion',      31, 70.3, 2100, 'vegetarian',   'moderate'),
    ('Gwen',     'general_health', 55, 63.8, 1900, NULL,           'sedentary'),
    ('Harvey',   'build_muscle',   24, 82.1, 3200, 'standard',     'very_active'),
    ('Iris',     'recovery',       29, 59.4, 2000, 'pescatarian',  'active'),
    ('Aditi',    'weight_loss',    38, 91.7, 1500, 'standard',     'sedentary'),
    ('Keira',    'endurance',      26, 57.6, 2400, 'vegan',        'very_active'),
    ('Kenji',    'digestion',      47, 78.9, NULL, 'vegetarian',   'moderate'),
    ('Martha',   'general_health', 60, 66.2, 1800, NULL,           'sedentary'),
    ('Noel',     'build_muscle',   22, 76.5, 2900, 'vegetarian',   'active'),
    ('Orla',     'weight_loss',    34, 88.3, 1700, 'standard',     'moderate'),
    ('Patrick',  'endurance',      30, 72.0, 2700, 'standard',     'very_active'),
    ('Robyn',    'recovery',       41, 64.7, NULL, 'standard',     'active'),
    ('Scott',    'general_health', 52, 80.4, 2000, 'standard',     'moderate'),
    ('Trudy',    'flexibility',    27, 55.2, 1900, 'vegan',        'active'),
    ('Vikram',   'build_muscle',   33, 85.6, 3100, 'standard',     'very_active'),
    ('Wendy',    'digestion',      44, 69.1, 2200, NULL,           'moderate'),
    ('Zain',     'weight_loss',    36, 93.0, 1400, 'pescatarian',  'sedentary'),
    ('Amber',    'build_muscle',   25, 64.3, 2700, 'standard',     'very_active'),
    ('Blair',    'endurance',      32, 71.8, 2500, 'standard',     'active'),
    ('Craig',    'weight_loss',    48, 96.2, 1550, 'standard',     'sedentary'),
    ('Darcy',    'recovery',       30, 58.9, 1950, 'vegan',        'moderate'),
    ('Eve',      'digestion',      39, 62.4, 2050, 'vegetarian',   'moderate'),
    ('Faye',     'general_health', 57, 73.6, NULL, NULL,           'sedentary'),
    ('Grant',    'build_muscle',   21, 79.8, 3050, 'standard',     'very_active'),
    ('Heath',    'endurance',      28, 68.0, 2650, 'pescatarian',  'very_active'),
    ('Jade',     'weight_loss',    45, 82.7, 1650, 'standard',     'moderate'),
    ('Kurt',     'flexibility',    34, 74.1, 2000, 'standard',     'active'),
    ('Leah',     'build_muscle',   27, 61.5, 2600, 'vegetarian',   'active'),
    ('Mae',      'recovery',       36, 56.8, NULL, 'standard',     'moderate'),
    ('Nell',     'general_health', 62, 70.9, 1850, NULL,           'sedentary'),
    ('Owen',     'endurance',      29, 77.3, 2800, 'standard',     'very_active'),
    ('Pearl',    'digestion',      51, 65.0, 2150, NULL,           'moderate'),
    ('Reed',     'weight_loss',    40, 89.5, 1500, 'standard',     'sedentary'),
    ('Seth',     'build_muscle',   23, 83.2, 3150, 'standard',     'very_active'),
    ('Thea',     'flexibility',    31, 54.6, 1900, 'vegetarian',   'active'),
    ('Vince',    'recovery',       44, 76.0, 2100, 'standard',     'moderate'),
    ('Bao',      'endurance',      26, 60.2, 2450, 'vegan',        'very_active'),
    ('Chidi',    'weight_loss',    37, 94.8, 1450, 'standard',     'sedentary'),
    ('Ines',     'general_health', 49, 67.4, 1950, 'standard',     'moderate'),
    ('Koji',     'build_muscle',   30, 78.1, 2950, 'pescatarian',  'very_active'),
    ('Suki',     'digestion',      42, 63.3, NULL, 'vegan',        'active'),
    ('Trent',    'flexibility',    35, 75.5, 2000, NULL,           'active');

-- Verify: Expected 45 rows
SELECT COUNT(*) AS total_plans FROM meal_plans;
