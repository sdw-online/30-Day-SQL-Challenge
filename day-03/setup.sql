-- Day 03: ORDER BY & LIMIT - Setup Script
-- Run this in pgAdmin to create today's tables

-- Drop table if it already exists (safe to re-run)
DROP TABLE IF EXISTS online_orders;

-- Create the online_orders table
CREATE TABLE online_orders (
    order_id        SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100)   NOT NULL,
    email           VARCHAR(150)   NOT NULL,
    product_name    VARCHAR(100)   NOT NULL,
    category        VARCHAR(50)    NOT NULL,
    order_amount    NUMERIC(10, 2) NOT NULL,
    order_date      DATE           NOT NULL,
    region          VARCHAR(50)    NOT NULL,
    is_member       BOOLEAN        NOT NULL DEFAULT FALSE
);

-- Insert 30 orders
INSERT INTO online_orders (customer_name, email, product_name, category, order_amount, order_date, region, is_member)
VALUES
    ('Amara Osei',      'amara.osei@gmail.com',        'Wireless Headphones',     'Electronics',    89.99,  '2025-01-05', 'London',          TRUE),
    ('Callum Fraser',   'callum.fraser@outlook.com',   'Running Shoes',           'Sportswear',    124.50,  '2025-01-08', 'Scotland',        FALSE),
    ('Priya Sharma',    'priya.sharma@gmail.com',       'Yoga Mat',               'Sportswear',     34.99,  '2025-01-10', 'London',          TRUE),
    ('Finn McCarthy',   'finn.mccarthy@yahoo.co.uk',   'Coffee Machine',          'Kitchen',       219.00,  '2025-01-12', 'Wales',           FALSE),
    ('Isla Nguyen',     'isla.nguyen@hotmail.com',      'Desk Lamp',              'Home Office',    47.50,  '2025-01-14', 'North West',      TRUE),
    ('Ravi Kapoor',     'ravi.kapoor@gmail.com',        'Bluetooth Speaker',      'Electronics',    65.00,  '2025-01-15', 'West Midlands',   FALSE),
    ('Sienna Clarke',   'sienna.clarke@shopstream.com', 'Standing Desk',          'Home Office',   349.99,  '2025-01-18', 'London',          TRUE),
    ('Euan Campbell',   'euan.campbell@gmail.com',      'Trail Boots',            'Sportswear',    159.00,  '2025-01-20', 'Scotland',        TRUE),
    ('Nia Reeves',      'nia.reeves@outlook.com',       'Air Fryer',              'Kitchen',       129.99,  '2025-01-22', 'Wales',           FALSE),
    ('Mateo Silva',     'mateo.silva@gmail.com',        'Laptop Stand',           'Home Office',    59.99,  '2025-01-25', 'South East',      TRUE),
    ('Freya Anderson',  'freya.anderson@yahoo.co.uk',   'Protein Powder',         'Sportswear',     42.00,  '2025-01-28', 'North East',      FALSE),
    ('Arjun Patel',     'arjun.patel@shopstream.com',   'Monitor 27 inch',        'Electronics',   329.00,  '2025-02-01', 'London',          TRUE),
    ('Yuki Tanaka',     'yuki.tanaka@gmail.com',        'Blender Pro',            'Kitchen',        89.00,  '2025-02-03', 'East Midlands',   FALSE),
    ('Safiya Hassan',   'safiya.hassan@outlook.com',    'Wireless Mouse',         'Electronics',    29.99,  '2025-02-05', 'North West',      TRUE),
    ('Quinn Byrne',     'quinn.byrne@hotmail.com',      'Resistance Bands',       'Sportswear',     18.50,  '2025-02-07', 'Wales',           FALSE),
    ('Wei Zhang',       'wei.zhang@gmail.com',          'Mechanical Keyboard',    'Electronics',   149.00,  '2025-02-10', 'London',          TRUE),
    ('Idris Okafor',    'idris.okafor@yahoo.co.uk',    'Slow Cooker',            'Kitchen',        74.99,  '2025-02-12', 'West Midlands',   FALSE),
    ('Leila Hussain',   'leila.hussain@shopstream.com', 'Ergonomic Chair',        'Home Office',   499.00,  '2025-02-14', 'South East',      TRUE),
    ('Sage Kowalski',   'sage.kowalski@gmail.com',      'Dumbbells Set',          'Sportswear',     95.00,  '2025-02-16', 'Scotland',        TRUE),
    ('Kwame Mensah',    'kwame.mensah@outlook.com',     'Webcam HD',              'Electronics',    79.99,  '2025-02-18', 'North East',      FALSE),
    ('Mei Lin',         'mei.lin@gmail.com',            'Toaster Oven',           'Kitchen',        64.50,  '2025-02-20', 'East Midlands',   TRUE),
    ('Jordan Ellis',    'jordan.ellis@hotmail.com',     'Laptop Backpack',        'Home Office',    55.00,  '2025-02-22', 'London',          FALSE),
    ('Zara Ibrahim',    'zara.ibrahim@gmail.com',       'Smart Watch',            'Electronics',   199.99,  '2025-02-25', 'North West',      TRUE),
    ('River Chen',      'river.chen@shopstream.com',    'Kettlebell 16kg',        'Sportswear',     45.00,  '2025-02-28', 'Wales',           FALSE),
    ('Phoenix Taylor',  'phoenix.taylor@yahoo.co.uk',   'Electric Kettle',        'Kitchen',        39.99,  '2025-03-02', 'South East',      TRUE),
    ('Aisha Mohammed',  'aisha.mohammed@gmail.com',     'USB-C Hub',              'Electronics',    44.99,  '2025-03-05', 'West Midlands',   FALSE),
    ('Lucas Fernandez', 'lucas.fernandez@outlook.com',  'Foam Roller',            'Sportswear',     24.99,  '2025-03-08', 'Scotland',        TRUE),
    ('Nina Volkov',     'nina.volkov@hotmail.com',      'Knife Set',              'Kitchen',       189.00,  '2025-03-10', 'London',          FALSE),
    ('Jamal Williams',  'jamal.williams@gmail.com',     'Monitor Arm',            'Home Office',    69.99,  '2025-03-12', 'North East',      TRUE),
    ('Freya Mitchell',  'freya.mitchell@shopstream.com','Fitness Tracker',         'Electronics',   149.99,  '2025-03-15', 'East Midlands',   FALSE);
