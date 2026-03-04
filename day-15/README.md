# Day 15 - JOINs Part 1: INNER, LEFT, RIGHT & FULL OUTER

[Watch the video](COMING_SOON) | [← Day 14: Project: IoT Sensor Data Pipeline](../day-14/) | [Day 16: CROSS JOIN & Self Joins →](../day-16/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- Why real databases split data across multiple tables (normalisation)
- INNER JOIN - returns only rows that match in both tables
- LEFT JOIN - keeps all rows from the left table, fills NULLs where no match
- RIGHT JOIN - the mirror image of LEFT JOIN (and why most people just use LEFT JOIN)
- FULL OUTER JOIN - returns all rows from both tables, NULLs on either side
- The anti-join pattern (LEFT JOIN + WHERE IS NULL) for finding missing relationships
- How to join three or more tables and choose the right JOIN type at each step

## Prerequisites
- Complete Days 1-14
- Comfortable with SELECT, WHERE, GROUP BY, aggregate functions, NULL handling, string/date functions, CASE WHEN, subqueries, temp tables, and CTEs

## Dataset

Today uses data from a UK logistics company that tracks customers, drivers, vehicles, shipments, and shipment events. The schema is deliberately designed with orphan records and NULL foreign keys so you can see exactly how each JOIN type behaves.

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- ============================================
-- DAY 15 SETUP: UK logistics company data
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS shipment_events;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS customers;

-- TABLE 1: customers
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    company_name    VARCHAR(150)    NOT NULL,
    contact_name    VARCHAR(100)    NOT NULL,
    contact_email   VARCHAR(150)    NOT NULL,
    region          VARCHAR(50)     NOT NULL,
    signup_date     DATE            NOT NULL,
    account_type    VARCHAR(30)     NOT NULL DEFAULT 'standard'
);

-- TABLE 2: drivers
CREATE TABLE drivers (
    driver_id       SERIAL PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    licence_type    VARCHAR(20)     NOT NULL,
    home_depot      VARCHAR(50)     NOT NULL,
    hire_date       DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 3: vehicles
CREATE TABLE vehicles (
    vehicle_id      SERIAL PRIMARY KEY,
    registration    VARCHAR(20)     NOT NULL,
    vehicle_type    VARCHAR(50)     NOT NULL,
    max_weight_kg   NUMERIC(8, 2)  NOT NULL,
    driver_id       INTEGER         REFERENCES drivers(driver_id),
    last_service    DATE
);

-- TABLE 4: shipments
CREATE TABLE shipments (
    shipment_id     SERIAL PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customers(customer_id),
    driver_id       INTEGER         REFERENCES drivers(driver_id),
    origin_city     VARCHAR(80)     NOT NULL,
    dest_city       VARCHAR(80)     NOT NULL,
    weight_kg       NUMERIC(8, 2)  NOT NULL,
    quoted_price    NUMERIC(10, 2) NOT NULL,
    created_date    DATE            NOT NULL,
    status          VARCHAR(30)     NOT NULL DEFAULT 'pending'
);

-- TABLE 5: shipment_events
CREATE TABLE shipment_events (
    event_id        SERIAL PRIMARY KEY,
    shipment_id     INTEGER         NOT NULL REFERENCES shipments(shipment_id),
    event_type      VARCHAR(50)     NOT NULL,
    event_timestamp TIMESTAMP       NOT NULL,
    location        VARCHAR(100),
    notes           TEXT
);

-- 15 customers (customers 13-15 have NO shipments -- intentional for LEFT JOIN demos)
INSERT INTO customers
    (company_name, contact_name, contact_email, region, signup_date, account_type)
VALUES
    ('Apex Manufacturing',      'Isla Thornton',     'isla.t@apexmfg.co.uk',       'North West',     '2023-04-10', 'premium'),
    ('Brightfield Retail',      'Kwame Mensah',      'kwame.m@brightfield.co.uk',   'London',         '2023-07-22', 'standard'),
    ('Clearview Optics',        'Freya Lindqvist',   'freya.l@clearview.co.uk',     'South East',     '2023-09-15', 'premium'),
    ('Drummond & Partners',     'Callum Reid',       'callum.r@drummond.co.uk',     'Scotland',       '2024-01-08', 'standard'),
    ('Ember Health',            'Priya Ranganathan', 'priya.r@emberhealth.co.uk',   'West Midlands',  '2024-03-20', 'premium'),
    ('Foxglove Interiors',      'Sienna Marchetti',  'sienna.m@foxglove.co.uk',     'South West',     '2024-05-14', 'standard'),
    ('Granite Construction',    'Euan MacLeod',      'euan.m@granite.co.uk',        'Scotland',       '2024-06-30', 'premium'),
    ('Horizon Pharma',          'Amara Okafor',      'amara.o@horizonpharma.co.uk', 'London',         '2024-08-12', 'premium'),
    ('Ironbridge Textiles',     'Ravi Chadha',       'ravi.c@ironbridge.co.uk',     'West Midlands',  '2024-09-25', 'standard'),
    ('Juniper Foods',           'Nia Evans',         'nia.e@juniperfoods.co.uk',    'Wales',          '2024-11-05', 'standard'),
    ('Kelvin Logistics',        'Idris Osei',        'idris.o@kelvinlog.co.uk',     'North West',     '2025-01-10', 'premium'),
    ('Lakeshore Media',         'Mei Tanaka',        'mei.t@lakeshoremedia.co.uk',  'London',         '2025-02-18', 'standard'),
    ('Moorland Crafts',         'Quinn Gallagher',   'quinn.g@moorland.co.uk',      'Wales',          '2025-03-05', 'standard'),
    ('Northgate Solar',         'Arjun Desai',       'arjun.d@northgatesolar.co.uk','South East',     '2025-04-01', 'premium'),
    ('Osprey Analytics',        'Sage Mwangi',       'sage.m@osprey.co.uk',         'Scotland',       '2025-04-15', 'standard');

-- 10 drivers (drivers 9-10 have NO shipments -- intentional for RIGHT JOIN demos)
INSERT INTO drivers
    (full_name, licence_type, home_depot, hire_date, is_active)
VALUES
    ('Liam Brennan',        'HGV Class 1',  'Manchester',   '2022-03-15', TRUE),
    ('Safiya Abdi',         'HGV Class 2',  'London',       '2022-08-01', TRUE),
    ('Finn O''Sullivan',    'HGV Class 1',  'Birmingham',   '2023-01-20', TRUE),
    ('Zara Hussain',        'LGV',          'Bristol',      '2023-05-10', TRUE),
    ('Marcus Webb',         'HGV Class 2',  'Edinburgh',    '2023-09-01', TRUE),
    ('Leila Akter',         'HGV Class 1',  'Manchester',   '2024-02-14', TRUE),
    ('Jordan Price',        'LGV',          'Cardiff',      '2024-06-01', TRUE),
    ('Kenji Nakamura',      'HGV Class 2',  'London',       '2024-10-15', TRUE),
    ('River Okonkwo',       'HGV Class 1',  'Edinburgh',    '2025-01-08', TRUE),
    ('Aisha Begum',         'LGV',          'Bristol',      '2025-03-01', FALSE);

-- 12 vehicles (vehicles 11-12 have NULL driver_id -- unassigned)
INSERT INTO vehicles
    (registration, vehicle_type, max_weight_kg, driver_id, last_service)
VALUES
    ('MN22 XKR',    '7.5t Box Van',        7500.00,   1, '2025-01-15'),
    ('LN21 FGH',    '18t Rigid',          18000.00,   2, '2025-02-01'),
    ('BM23 TYP',    '3.5t Luton Van',      3500.00,   3, '2024-12-10'),
    ('BS22 WQR',    '3.5t Sprinter Van',   3500.00,   4, '2025-03-05'),
    ('ED24 PNR',    '26t Rigid',          26000.00,   5, '2024-11-20'),
    ('MN23 JKL',    '18t Curtainsider',   18000.00,   6, '2025-01-28'),
    ('CF24 ASD',    '3.5t Luton Van',      3500.00,   7, '2025-02-18'),
    ('LN24 VBN',    '7.5t Box Van',        7500.00,   8, '2025-03-12'),
    ('ED25 GHJ',    '44t Artic',          44000.00,   9, '2025-04-01'),
    ('BS25 QWE',    '7.5t Refrigerated',   7500.00,  10, '2025-03-20'),
    ('MN25 RTY',    '18t Flatbed',        18000.00, NULL, '2024-10-05'),
    ('LN25 UIO',    '3.5t Sprinter Van',   3500.00, NULL, NULL);

-- 30 shipments (shipments 28-30 have NULL driver_id -- unassigned)
INSERT INTO shipments
    (customer_id, driver_id, origin_city, dest_city, weight_kg, quoted_price, created_date, status)
VALUES
    (1,  1, 'Manchester',   'London',       2500.00,  480.00, '2024-03-10', 'delivered'),
    (1,  1, 'Manchester',   'Birmingham',   1800.00,  320.00, '2024-06-15', 'delivered'),
    (1,  6, 'Manchester',   'Edinburgh',    3200.00,  650.00, '2025-01-20', 'delivered'),
    (2,  2, 'London',       'Bristol',      1200.00,  280.00, '2024-04-22', 'delivered'),
    (2,  2, 'London',       'Cardiff',       950.00,  220.00, '2024-09-05', 'delivered'),
    (3,  3, 'Reading',      'London',        450.00,  150.00, '2024-05-18', 'delivered'),
    (3,  3, 'Guildford',    'Manchester',   1100.00,  310.00, '2024-10-30', 'delivered'),
    (3,  8, 'London',       'Edinburgh',    2800.00,  590.00, '2025-02-10', 'in_transit'),
    (4,  5, 'Edinburgh',    'Glasgow',       600.00,  120.00, '2024-07-14', 'delivered'),
    (4,  5, 'Edinburgh',    'Aberdeen',      850.00,  190.00, '2025-03-08', 'delivered'),
    (5,  3, 'Birmingham',   'London',       1500.00,  350.00, '2024-08-20', 'delivered'),
    (5,  6, 'Birmingham',   'Manchester',   2200.00,  420.00, '2025-01-05', 'delivered'),
    (6,  4, 'Bristol',      'London',        300.00,   95.00, '2024-09-12', 'delivered'),
    (6,  4, 'Exeter',       'Birmingham',    750.00,  180.00, '2025-02-28', 'delivered'),
    (7,  5, 'Edinburgh',    'London',       5500.00,  890.00, '2024-10-01', 'delivered'),
    (7,  5, 'Glasgow',      'Manchester',   4200.00,  720.00, '2025-03-15', 'in_transit'),
    (8,  2, 'London',       'Manchester',   1800.00,  380.00, '2024-11-10', 'delivered'),
    (8,  8, 'London',       'Birmingham',   2100.00,  410.00, '2025-03-22', 'delivered'),
    (9,  3, 'Birmingham',   'Bristol',       900.00,  200.00, '2024-12-05', 'delivered'),
    (9,  6, 'Birmingham',   'London',       1600.00,  340.00, '2025-04-01', 'in_transit'),
    (10, 7, 'Cardiff',      'London',        400.00,  130.00, '2025-01-15', 'delivered'),
    (10, 7, 'Swansea',      'Bristol',       550.00,  145.00, '2025-03-28', 'delivered'),
    (11, 1, 'Manchester',   'London',       3000.00,  560.00, '2025-02-05', 'delivered'),
    (11, 6, 'Manchester',   'Edinburgh',    2700.00,  510.00, '2025-04-10', 'in_transit'),
    (12, 2, 'London',       'Bristol',      1100.00,  260.00, '2025-03-01', 'delivered'),
    (12, 8, 'London',       'Glasgow',      1900.00,  430.00, '2025-04-15', 'pending'),
    (1,  1, 'Manchester',   'Cardiff',      2000.00,  390.00, '2025-04-18', 'cancelled'),
    (5, NULL, 'Birmingham', 'Edinburgh',    3100.00,  620.00, '2025-04-20', 'pending'),
    (8, NULL, 'London',     'Manchester',   1400.00,  310.00, '2025-04-22', 'pending'),
    (11, NULL,'Manchester',  'Bristol',      2500.00,  470.00, '2025-04-25', 'pending');

-- 45 shipment events
INSERT INTO shipment_events
    (shipment_id, event_type, event_timestamp, location, notes)
VALUES
    (1, 'picked_up',   '2024-03-10 08:30:00', 'Manchester Depot',  NULL),
    (1, 'in_transit',  '2024-03-10 14:00:00', 'M6 Northbound',     'Traffic delay near Birmingham'),
    (1, 'delivered',   '2024-03-11 09:15:00', 'London Warehouse',  'Signed by R. Patel'),
    (2, 'picked_up',   '2024-06-15 07:45:00', 'Manchester Depot',  NULL),
    (2, 'in_transit',  '2024-06-15 11:30:00', 'M6 Southbound',     NULL),
    (2, 'delivered',   '2024-06-15 15:00:00', 'Birmingham Hub',    'Left at reception'),
    (3, 'picked_up',   '2025-01-20 09:00:00', 'Manchester Depot',  NULL),
    (3, 'in_transit',  '2025-01-20 16:00:00', 'M6/A74 Northbound', 'Overnight stop at Carlisle'),
    (3, 'delivered',   '2025-01-21 11:30:00', 'Edinburgh Depot',   'Signed by depot manager'),
    (4, 'picked_up',   '2024-04-22 08:00:00', 'London Depot',      NULL),
    (4, 'in_transit',  '2024-04-22 12:30:00', 'M4 Westbound',      NULL),
    (4, 'delivered',   '2024-04-22 16:45:00', 'Bristol Depot',     'Signed by warehouse team'),
    (6, 'picked_up',   '2024-05-18 07:30:00', 'Reading Office',    'Small parcel collection'),
    (6, 'in_transit',  '2024-05-18 09:00:00', 'M4 Eastbound',      NULL),
    (6, 'delivered',   '2024-05-18 11:00:00', 'London Depot',      'Same-day delivery'),
    (9, 'picked_up',   '2024-07-14 08:15:00', 'Edinburgh Depot',   NULL),
    (9, 'in_transit',  '2024-07-14 09:30:00', 'M8 Westbound',      NULL),
    (9, 'delivered',   '2024-07-14 10:45:00', 'Glasgow Depot',     'Express delivery'),
    (11, 'picked_up',  '2024-08-20 09:00:00', 'Birmingham Hub',    NULL),
    (11, 'in_transit', '2024-08-20 13:00:00', 'M40 Southbound',    NULL),
    (11, 'delivered',  '2024-08-20 16:30:00', 'London Warehouse',  'Signed by reception'),
    (15, 'picked_up',  '2024-10-01 06:30:00', 'Edinburgh Depot',   'Heavy load - 5.5t'),
    (15, 'in_transit', '2024-10-01 14:00:00', 'A1 Southbound',     'Overnight at Peterborough'),
    (15, 'delivered',  '2024-10-02 10:00:00', 'London Warehouse',  'Crane unload required'),
    (17, 'picked_up',  '2024-11-10 08:00:00', 'London Depot',      NULL),
    (17, 'in_transit', '2024-11-10 13:30:00', 'M1 Northbound',     NULL),
    (17, 'delivered',  '2024-11-11 09:00:00', 'Manchester Depot',  'Signed by L. Brennan'),
    (21, 'picked_up',  '2025-01-15 08:30:00', 'Cardiff Depot',     NULL),
    (21, 'in_transit', '2025-01-15 14:00:00', 'M4 Eastbound',      NULL),
    (21, 'delivered',  '2025-01-16 09:30:00', 'London Warehouse',  'Signed by goods-in team'),
    (23, 'picked_up',  '2025-02-05 07:45:00', 'Manchester Depot',  NULL),
    (23, 'in_transit', '2025-02-05 13:00:00', 'M6/M1 Southbound',  NULL),
    (23, 'delivered',  '2025-02-05 17:00:00', 'London Warehouse',  'Signed by security'),
    (25, 'picked_up',  '2025-03-01 09:00:00', 'London Depot',      NULL),
    (25, 'in_transit', '2025-03-01 13:30:00', 'M4 Westbound',      NULL),
    (25, 'delivered',  '2025-03-01 17:15:00', 'Bristol Depot',     'Left at loading bay'),
    (8,  'picked_up',  '2025-02-10 08:00:00', 'London Depot',      NULL),
    (8,  'in_transit', '2025-02-10 15:00:00', 'A1 Northbound',     'Expected delivery tomorrow'),
    (16, 'picked_up',  '2025-03-15 07:00:00', 'Glasgow Depot',     NULL),
    (16, 'in_transit', '2025-03-15 12:00:00', 'M74/M6 Southbound', NULL),
    (20, 'picked_up',  '2025-04-01 08:30:00', 'Birmingham Hub',    NULL),
    (20, 'in_transit', '2025-04-01 13:00:00', 'M6/M1 Southbound',  NULL),
    (27, 'picked_up',  '2025-04-18 09:00:00', 'Manchester Depot',  'Customer requested cancellation after pickup');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM customers;
-- Expected: 15 rows

SELECT COUNT(*) FROM drivers;
-- Expected: 10 rows

SELECT COUNT(*) FROM vehicles;
-- Expected: 12 rows

SELECT COUNT(*) FROM shipments;
-- Expected: 30 rows

SELECT COUNT(*) FROM shipment_events;
-- Expected: 45 rows
```

## Exercises

You are a data analyst at a UK logistics company. The Head of Operations, Sarah, has a board meeting at 3pm and needs a complete operations review covering customer activity, driver allocation, and fleet utilisation.

Using the dataset above, answer the questions below.

### 🟢 Warm-Up

**Q1:** Write an INNER JOIN between shipments and customers to show each shipment's ID, company name, destination city, and status. How many rows do you get, and why?

**Q2:** Write a LEFT JOIN between customers and shipments. Show company name, region, and shipment ID. Which customers appear with NULL shipment data, and what does that tell you?

### 🟡 Practice

**Q3:** Build a full customer revenue report that includes every single customer - even those who have not shipped yet. Show company name, region, total shipments, total revenue, and average shipment value. Customers with no shipments should show 0 instead of NULL.

**Q4:** Find all shipments that are sitting without a driver assigned. Show the shipment details alongside the customer's company name. How much total revenue is at risk from these unassigned shipments?

**Q5:** Build a fleet reconciliation report using FULL OUTER JOIN between drivers and vehicles. For each row, show the driver name, vehicle registration, vehicle type, and an assignment status of "Matched", "Driver without vehicle", or "Vehicle without driver".

### 🔴 Challenge

**Q6:** Use the anti-join pattern (LEFT JOIN + WHERE IS NULL) to find all customers who signed up but have never placed a single shipment. Show their company name, region, and signup date. Which year did they all sign up in?

**Q7:** Build a comprehensive operations dashboard in a single query. Use a CTE to first calculate each driver's total shipments, total revenue, and average shipment weight. Then join this to the drivers and vehicles tables using a combination of LEFT JOIN and FULL OUTER JOIN to show: every driver (with or without shipments), their assigned vehicle, their shipment stats, and a workload classification of "Heavy" (5+ shipments), "Normal" (2-4 shipments), "Light" (1 shipment), or "Idle" (no shipments).

## Key Concepts Covered
- **Normalisation:** Splitting data across tables so each fact is stored once - JOINs bring them back together
- **INNER JOIN:** Returns only matching rows - no match means the row vanishes silently
- **LEFT JOIN:** Preserves all rows from the left table - NULLs fill in where no match exists on the right
- **Anti-join pattern:** LEFT JOIN + WHERE IS NULL - the safest way to find rows with no match (better than NOT IN)
- **FULL OUTER JOIN:** Returns all rows from both tables - NULLs on either side where no match exists
- **COUNT(column) vs COUNT(*):** With LEFT JOINs, always use COUNT(column) to avoid miscounting NULL rows as 1

---

[← Day 14: Project: IoT Sensor Data Pipeline](../day-14/) | [Day 16: CROSS JOIN & Self Joins →](../day-16/)
