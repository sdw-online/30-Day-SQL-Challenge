# Day 7 - Project: Freight & Logistics Performance Report

[Watch the video](https://youtu.be/fiBYAziNtGI) | [← Day 6: PRIMARY KEY, FOREIGN KEY & Constraints](../day-06/) | [Day 8: NULL Handling →](../day-08/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How to explore, clean, and analyse a real multi-table dataset end-to-end
- How to detect and fix mislabelled records using UPDATE with WHERE conditions
- How to find and remove duplicate entries using GROUP BY + HAVING
- How to build an executive summary with aggregated performance metrics

## Prerequisites

> **First time here?** You need PostgreSQL and pgAdmin installed.
> [Watch the setup guide](https://youtu.be/g8GwhsVPaOg) | [Start from Day 1](../day-01/)

- Complete Days 1-6
- pgAdmin open and connected to your `sql_challenge` database
- Comfortable with SELECT, WHERE, ORDER BY, LIMIT, GROUP BY, HAVING, INSERT, UPDATE, DELETE, and constraints

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS carriers;

-- TABLE 1: carriers
CREATE TABLE carriers (
    carrier_id      SERIAL          PRIMARY KEY,
    carrier_code    VARCHAR(10)     NOT NULL UNIQUE,
    carrier_name    VARCHAR(100)    NOT NULL,
    fleet_type      VARCHAR(30)     NOT NULL
                                    CHECK (fleet_type IN ('Road', 'Rail', 'Air', 'Sea')),
    fleet_size      INTEGER         NOT NULL CHECK (fleet_size > 0),
    home_region     VARCHAR(50)     NOT NULL,
    reliability_rating NUMERIC(3, 2) NOT NULL CHECK (reliability_rating >= 0 AND reliability_rating <= 5),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 2: routes
CREATE TABLE routes (
    route_id            SERIAL          PRIMARY KEY,
    route_code          VARCHAR(15)     NOT NULL UNIQUE,
    origin_city         VARCHAR(100)    NOT NULL,
    destination_city    VARCHAR(100)    NOT NULL,
    region              VARCHAR(50)     NOT NULL,
    distance_km         NUMERIC(8, 2)   NOT NULL CHECK (distance_km > 0),
    estimated_hours     NUMERIC(6, 2)   NOT NULL CHECK (estimated_hours > 0),
    route_type          VARCHAR(20)     NOT NULL DEFAULT 'Standard'
                                        CHECK (route_type IN ('Standard', 'Express', 'Economy'))
);

-- TABLE 3: shipments
CREATE TABLE shipments (
    shipment_id         SERIAL          PRIMARY KEY,
    tracking_code       VARCHAR(20)     NOT NULL,
    carrier_id          INTEGER         NOT NULL
                                        REFERENCES carriers(carrier_id)
                                        ON DELETE RESTRICT,
    route_id            INTEGER         NOT NULL
                                        REFERENCES routes(route_id)
                                        ON DELETE RESTRICT,
    shipment_date       DATE            NOT NULL,
    delivery_date       DATE,
    status              VARCHAR(20)     NOT NULL DEFAULT 'In Transit'
                                        CHECK (status IN ('Pending', 'In Transit', 'Delivered', 'Delayed', 'Cancelled')),
    weight_kg           NUMERIC(10, 2)  NOT NULL CHECK (weight_kg > 0),
    cost_gbp            NUMERIC(10, 2)  NOT NULL CHECK (cost_gbp >= 0),
    customer_name       VARCHAR(100)    NOT NULL,
    notes               TEXT
);

-- CARRIERS (8 carriers)
INSERT INTO carriers (carrier_code, carrier_name, fleet_type, fleet_size, home_region, reliability_rating, is_active)
VALUES
    ('NF-RD-001', 'NorthernFreight Road',       'Road', 120,    'North England',    4.20, TRUE),
    ('SW-RD-002', 'SwiftHaul Logistics',         'Road', 85,     'Midlands',         3.80, TRUE),
    ('XP-AR-003', 'AirExpress UK',               'Air',  30,     'South East',       4.50, TRUE),
    ('SC-RL-004', 'ScotRail Freight',             'Rail', 45,     'Scotland',         4.10, TRUE),
    ('EU-SE-005', 'EuroSea Shipping',             'Sea',  60,     'South East',       3.60, TRUE),
    ('ML-RD-006', 'MidlandLines Express',         'Road', 70,     'Midlands',         3.90, TRUE),
    ('WL-RD-007', 'WalesWay Transport',           'Road', 40,     'Wales',            3.40, FALSE),
    ('HG-RL-008', 'Highland Rail Cargo',          'Rail', 25,     'Scotland',         4.30, TRUE);

-- ROUTES (12 routes)
INSERT INTO routes (route_code, origin_city, destination_city, region, distance_km, estimated_hours, route_type)
VALUES
    ('RT-LON-MAN',  'London',       'Manchester',       'England',      330.00,     4.50,   'Standard'),
    ('RT-LON-EDI',  'London',       'Edinburgh',        'Cross-Border', 650.00,     8.00,   'Standard'),
    ('RT-BIR-LEE',  'Birmingham',   'Leeds',            'England',      190.00,     2.75,   'Express'),
    ('RT-MAN-GLA',  'Manchester',   'Glasgow',          'Cross-Border', 350.00,     5.00,   'Standard'),
    ('RT-LON-PAR',  'London',       'Paris',            'Europe',       460.00,     6.50,   'Express'),
    ('RT-EDI-ABE',  'Edinburgh',    'Aberdeen',         'Scotland',     200.00,     3.00,   'Standard'),
    ('RT-CAR-SWA',  'Cardiff',      'Swansea',          'Wales',        70.00,      1.25,   'Economy'),
    ('RT-LON-BRI',  'London',       'Bristol',          'England',      190.00,     2.50,   'Express'),
    ('RT-LEE-NEW',  'Leeds',        'Newcastle',        'England',      150.00,     2.00,   'Standard'),
    ('RT-GLA-INV',  'Glasgow',      'Inverness',        'Scotland',     280.00,     4.00,   'Standard'),
    ('RT-LON-AMS',  'London',       'Amsterdam',        'Europe',       370.00,     5.50,   'Express'),
    ('RT-BIR-MAN',  'Birmingham',   'Manchester',       'England',      140.00,     2.00,   'Economy');

-- SHIPMENTS (60 rows -- includes intentional data quality issues)
INSERT INTO shipments (tracking_code, carrier_id, route_id, shipment_date, delivery_date, status, weight_kg, cost_gbp, customer_name, notes)
VALUES
   -- Batch 1: Clean records (shipments 1-20)
    ('NF-2025-0001', 1, 1,  '2025-01-06', '2025-01-07', 'Delivered',   450.00,  320.00, 'Amara Osei',           'Standard pallet delivery'),
    ('NF-2025-0002', 2, 3,  '2025-01-07', '2025-01-07', 'Delivered',   120.50,  185.00, 'Callum Fraser',        'Express fragile goods'),
    ('NF-2025-0003', 3, 5,  '2025-01-08', '2025-01-08', 'Delivered',   85.00,   540.00, 'Priya Deshpande',      'Air freight -- urgent samples'),
    ('NF-2025-0004', 4, 6,  '2025-01-09', '2025-01-10', 'Delivered',   920.00,  275.00, 'Finn McCarthy',        'Rail bulk -- construction materials'),
    ('NF-2025-0005', 1, 2,  '2025-01-10', '2025-01-11', 'Delivered',   310.00,  410.00, 'Isla Nguyen',          'Cross-border standard'),
    ('NF-2025-0006', 5, 5,  '2025-01-13', '2025-01-15', 'Delivered',   2400.00, 890.00, 'Ravi Kapoor',          'Sea freight -- machinery parts'),
    ('NF-2025-0007', 6, 12, '2025-01-14', '2025-01-14', 'Delivered',   75.00,   95.00,  'Safiya Abdi',          'Economy local parcel'),
    ('NF-2025-0008', 1, 1,  '2025-01-15', '2025-01-16', 'Delivered',   520.00,  345.00, 'Kwame Mensah',         'Standard pallet delivery'),
    ('NF-2025-0009', 2, 8,  '2025-01-16', '2025-01-16', 'Delivered',   200.00,  255.00, 'Yuki Tanaka',          'Express -- retail stock'),
    ('NF-2025-0010', 3, 11, '2025-01-17', '2025-01-17', 'Delivered',   60.00,   620.00, 'Mateo Rodriguez',      'Air freight -- pharmaceuticals'),
    ('NF-2025-0011', 4, 10, '2025-01-20', '2025-01-21', 'Delivered',   780.00,  310.00, 'Freya Mitchell',       'Rail freight -- timber'),
    ('NF-2025-0012', 1, 9,  '2025-01-21', '2025-01-22', 'Delivered',   340.00,  220.00, 'Idris Okafor',         'Standard -- electronics'),
    ('NF-2025-0013', 6, 4,  '2025-01-22', '2025-01-23', 'Delivered',   160.00,  280.00, 'Leila Hassan',         'Cross-border standard'),
    ('NF-2025-0014', 2, 1,  '2025-01-23', '2025-01-24', 'Delivered',   410.00,  305.00, 'Euan Campbell',        'Standard pallet delivery'),
    ('NF-2025-0015', 1, 3,  '2025-01-24', '2025-01-24', 'Delivered',   95.00,   195.00, 'Nia Okonkwo',          'Express -- medical supplies'),
    ('NF-2025-0016', 5, 5,  '2025-01-27', '2025-01-29', 'Delivered',   3100.00, 1120.00,'Arjun Patel',          'Sea freight -- automotive parts'),
    ('NF-2025-0017', 8, 6,  '2025-01-28', '2025-01-29', 'Delivered',   650.00,  290.00, 'Sienna Blake',         'Rail -- perishable goods'),
    ('NF-2025-0018', 1, 2,  '2025-01-29', '2025-01-30', 'Delivered',   280.00,  395.00, 'Wei Chen',             'Cross-border standard'),
    ('NF-2025-0019', 6, 12, '2025-01-30', '2025-01-30', 'Delivered',   55.00,   80.00,  'Quinn Taylor',         'Economy local parcel'),
    ('NF-2025-0020', 3, 11, '2025-01-31', '2025-01-31', 'Delivered',   42.00,   580.00, 'River Santos',         'Air freight -- tech equipment'),

   -- Batch 2: February shipments with some delays (shipments 21-40)
    ('NF-2025-0021', 1, 1,  '2025-02-03', '2025-02-04', 'Delivered',   490.00,  330.00, 'Sage Obi',             'Standard pallet delivery'),
    ('NF-2025-0022', 2, 8,  '2025-02-04', '2025-02-05', 'Delayed',     180.00,  260.00, 'Phoenix Grant',        'Express -- delayed by weather'),
    ('NF-2025-0023', 4, 10, '2025-02-05', NULL,          'In Transit',  720.00,  330.00, 'Casey Moreau',         'Rail freight -- delayed at depot'),
    ('NF-2025-0024', 1, 4,  '2025-02-06', '2025-02-07', 'Delivered',   370.00,  350.00, 'Jordan Ellis',         'Cross-border standard'),
    ('NF-2025-0025', 5, 5,  '2025-02-07', NULL,          'In Transit',  1800.00, 780.00, 'Zara Hussain',         'Sea freight -- heavy machinery'),
    ('NF-2025-0026', 6, 7,  '2025-02-10', '2025-02-10', 'Delivered',   90.00,   65.00,  'Lucas Reid',           'Economy -- local delivery Wales'),
    ('NF-2025-0027', 1, 9,  '2025-02-11', '2025-02-12', 'Delivered',   260.00,  210.00, 'Maya Johal',           'Standard -- retail goods'),
    ('NF-2025-0028', 3, 5,  '2025-02-12', '2025-02-12', 'Delivered',   70.00,   510.00, 'Kenji Nakamura',       'Air freight -- urgent documents'),
    ('NF-2025-0029', 2, 3,  '2025-02-13', NULL,          'Delayed',     150.00,  200.00, 'Aisha Bello',          'Express -- customs hold'),
    ('NF-2025-0030', 8, 6,  '2025-02-14', '2025-02-15', 'Delivered',   580.00,  270.00, 'Liam Gallagher',       'Rail -- food supplies'),
    ('NF-2025-0031', 1, 1,  '2025-02-17', '2025-02-18', 'Delivered',   430.00,  315.00, 'Nina Kowalski',        'Standard pallet delivery'),
    ('NF-2025-0032', 6, 12, '2025-02-18', '2025-02-18', 'Delivered',   65.00,   85.00,  'Omar Diallo',          'Economy local parcel'),
    ('NF-2025-0033', 4, 4,  '2025-02-19', '2025-02-20', 'Delivered',   840.00,  340.00, 'Riley Chen',           'Rail cross-border -- steel'),
    ('NF-2025-0034', 1, 2,  '2025-02-20', NULL,          'In Transit',  295.00,  380.00, 'Priya Sharma',         'Cross-border -- delayed ferry'),
    ('NF-2025-0035', 2, 1,  '2025-02-21', '2025-02-22', 'Delivered',   375.00,  290.00, 'Jamal Wright',         'Standard pallet delivery'),

   -- Mislabelled records: status says "Delivered" but delivery_date is NULL
    ('NF-2025-0036', 5, 5,  '2025-02-24', NULL,          'Delivered',   1500.00, 650.00, 'Mei Lin',              'Sea freight -- status needs review'),
    ('NF-2025-0037', 1, 9,  '2025-02-25', NULL,          'Delivered',   220.00,  195.00, 'Callum Fraser',        'Standard -- status needs review'),
    ('NF-2025-0038', 6, 4,  '2025-02-26', NULL,          'Delivered',   140.00,  260.00, 'Isla Nguyen',          'Cross-border -- status needs review'),

   -- Mislabelled records: status says "In Transit" but delivery_date is populated
    ('NF-2025-0039', 2, 8,  '2025-02-27', '2025-02-28', 'In Transit',  190.00,  240.00, 'Amara Osei',           'Express -- actually delivered'),
    ('NF-2025-0040', 3, 11, '2025-02-28', '2025-02-28', 'In Transit',  55.00,   560.00, 'Ravi Kapoor',          'Air freight -- actually delivered'),

   -- Batch 3: March shipments (shipments 41-55)
    ('NF-2025-0041', 1, 1,  '2025-03-03', '2025-03-04', 'Delivered',   510.00,  340.00, 'Freya Mitchell',       'Standard pallet delivery'),
    ('NF-2025-0042', 4, 10, '2025-03-04', '2025-03-05', 'Delivered',   690.00,  305.00, 'Mateo Rodriguez',      'Rail freight -- building materials'),
    ('NF-2025-0043', 2, 3,  '2025-03-05', '2025-03-05', 'Delivered',   110.00,  180.00, 'Kwame Mensah',         'Express -- office equipment'),
    ('NF-2025-0044', 1, 2,  '2025-03-06', NULL,          'In Transit',  330.00,  405.00, 'Sienna Blake',         'Cross-border -- in transit'),
    ('NF-2025-0045', 5, 5,  '2025-03-07', NULL,          'Pending',     2200.00, 920.00, 'Wei Chen',             'Sea freight -- awaiting loading'),
    ('NF-2025-0046', 6, 7,  '2025-03-10', '2025-03-10', 'Delivered',   80.00,   60.00,  'Quinn Taylor',         'Economy -- local Wales delivery'),
    ('NF-2025-0047', 3, 5,  '2025-03-11', NULL,          'In Transit',  95.00,   530.00, 'Sage Obi',             'Air freight -- in transit'),
    ('NF-2025-0048', 1, 9,  '2025-03-12', '2025-03-13', 'Delivered',   285.00,  225.00, 'Idris Okafor',         'Standard -- electronics'),
    ('NF-2025-0049', 8, 6,  '2025-03-13', '2025-03-14', 'Delivered',   610.00,  280.00, 'Nia Okonkwo',          'Rail -- perishable goods'),
    ('NF-2025-0050', 2, 1,  '2025-03-14', NULL,          'Delayed',     420.00,  310.00, 'Arjun Patel',          'Standard -- vehicle breakdown'),
    ('NF-2025-0051', 1, 1,  '2025-03-17', NULL,          'Pending',     460.00,  325.00, 'Leila Hassan',         'Standard -- awaiting pickup'),
    ('NF-2025-0052', 4, 4,  '2025-03-18', NULL,          'In Transit',  750.00,  345.00, 'Euan Campbell',        'Rail cross-border -- in transit'),
    ('NF-2025-0053', 6, 12, '2025-03-19', '2025-03-19', 'Delivered',   45.00,   70.00,  'Yuki Tanaka',          'Economy local parcel'),
    ('NF-2025-0054', 1, 3,  '2025-03-20', '2025-03-20', 'Delivered',   105.00,  200.00, 'Aisha Bello',          'Express -- medical supplies'),
    ('NF-2025-0055', 3, 11, '2025-03-21', NULL,          'Cancelled',   30.00,   0.00,   'Phoenix Grant',        'Cancelled by customer'),

   -- Duplicate tracking entries (same tracking_code as earlier shipments)
    ('NF-2025-0008', 1, 1,  '2025-01-15', '2025-01-16', 'Delivered',   520.00,  345.00, 'Kwame Mensah',         'DUPLICATE -- system glitch'),
    ('NF-2025-0014', 2, 1,  '2025-01-23', '2025-01-24', 'Delivered',   410.00,  305.00, 'Euan Campbell',        'DUPLICATE -- system glitch'),
    ('NF-2025-0021', 1, 1,  '2025-02-03', '2025-02-04', 'Delivered',   490.00,  330.00, 'Sage Obi',             'DUPLICATE -- system glitch'),
    ('NF-2025-0032', 6, 12, '2025-02-18', '2025-02-18', 'Delivered',   65.00,   85.00,  'Omar Diallo',          'DUPLICATE -- system glitch'),
    ('NF-2025-0041', 1, 1,  '2025-03-03', '2025-03-04', 'Delivered',   510.00,  340.00, 'Freya Mitchell',       'DUPLICATE -- system glitch');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM carriers;
-- Expected: 8

SELECT COUNT(*) FROM routes;
-- Expected: 12

SELECT COUNT(*) FROM shipments;
-- Expected: 60
```

## Exercises

You are a logistics analyst at a UK-based freight company called **BriteLine Haulage**. They ship goods across the UK and into Europe by road, rail, air, and sea.

Your operations director, **Marcus Reid**, has a board meeting next week. He is presenting Q1 2025 performance - January through March - and he needs answers. But the warehouse team has warned that there are dodgy records in the system: shipments marked as delivered with no delivery date, and duplicate entries from a system glitch in February.

This is how real data projects work. You explore first, clean second, analyse third. Complete the following steps to build Marcus's board report:

### 🟢 Warm-Up

**Step 1 - Explore the Schema:** Query all three tables to understand what you are working with. How many carriers are there? What fleet types exist? How many shipments are in each status? Verify the foreign key relationships by joining shipments to carriers and routes.

**Step 2 - Initial Analysis (Before Cleaning):** Calculate each carrier's on-time delivery rate using COUNT with a FILTER clause. Find the monthly shipment volume using TO_CHAR to format the dates. Calculate total revenue by carrier and fleet type. Identify which routes have the highest issue rates.

### 🟡 Practice

**Step 3 - Data Cleaning (Issue 1 - Mislabelled "Delivered"):** Find all shipments where the status is 'Delivered' but delivery_date is NULL. These have been mislabelled. Update their status to 'In Transit' and append a correction note to the notes column.

**Step 4 - Data Cleaning (Issue 2 - Mislabelled "In Transit"):** Find all shipments where the status is 'In Transit' but delivery_date IS NOT NULL. These have actually been delivered. Update their status to 'Delivered' and append a correction note.

**Step 5 - Data Cleaning (Issue 3 - Duplicate Tracking Entries):** Use GROUP BY + HAVING COUNT(*) > 1 on tracking_code to find duplicates. Examine them to confirm they are genuine copies. Delete the duplicate rows (keep the originals with the lower shipment_id).

### 🔴 Challenge

**Step 6 - Final Report (Clean Data):** Re-run the key analyses on clean data: updated carrier performance, regional performance, revenue by fleet type, and monthly trends. These are the numbers Marcus takes to the board.

**Step 7 - Executive Summary:** Build an overall scorecard (total shipments, delivery rate, total revenue), flag carriers below 75% delivery rate using HAVING, and find the top 5 highest-value shipments.

**Bonus Challenge:** Add a UNIQUE constraint to the tracking_code column on the shipments table so that the system glitch that created duplicates can never happen again. Write the ALTER TABLE statement to add this constraint.

## Key Concepts Covered
- **Explore first, clean second, analyse third**: The standard workflow for any real data project
- **SELECT before UPDATE or DELETE**: Always preview what will change before modifying data
- **GROUP BY + HAVING COUNT(*) > 1**: The go-to duplicate detection pattern for any table and any column
- **FILTER clause**: PostgreSQL feature for conditional counting within an aggregate function
- **UNION ALL**: Stack results from multiple queries into one output for data quality checks
- **Enforce rules in the schema**: Constraints like UNIQUE prevent problems that queries can only discover after the fact

---

[← Day 6: PRIMARY KEY, FOREIGN KEY & Constraints](../day-06/) | [Day 8: NULL Handling →](../day-08/)
