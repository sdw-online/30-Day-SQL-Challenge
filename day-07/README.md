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

Run this SQL in pgAdmin to create today's tables. This sets up four tables for a UK freight company called **Orion Freight** - six depots, twelve drivers, ten vehicles, and 120 shipments across Q1 2025.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Clean up any existing tables
DROP TABLE IF EXISTS shipments CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS depots CASCADE;

-- TABLE 1: depots (6 rows)
CREATE TABLE depots (
    depot_id    SERIAL       PRIMARY KEY,
    depot_name  VARCHAR(50)  NOT NULL UNIQUE,
    city        VARCHAR(50)  NOT NULL,
    region      VARCHAR(30)  NOT NULL
                CHECK (region IN ('South West', 'Yorkshire', 'Scotland',
                                  'Midlands', 'Wales', 'East Anglia'))
);

INSERT INTO depots (depot_name, city, region)
VALUES
    ('Bristol Hub',       'Bristol',    'South West'),
    ('Leeds Depot',       'Leeds',      'Yorkshire'),
    ('Glasgow Terminal',  'Glasgow',    'Scotland'),
    ('Birmingham Centre', 'Birmingham', 'Midlands'),
    ('Cardiff Depot',     'Cardiff',    'Wales'),
    ('Norwich Hub',       'Norwich',    'East Anglia');

-- TABLE 2: drivers (12 rows)
CREATE TABLE drivers (
    driver_id    SERIAL       PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    licence_type VARCHAR(5)   NOT NULL
                 CHECK (licence_type IN ('B', 'C', 'C+E')),
    hire_date    DATE         NOT NULL DEFAULT CURRENT_DATE,
    depot_id     INTEGER      NOT NULL REFERENCES depots(depot_id)
);

INSERT INTO drivers (name, licence_type, hire_date, depot_id)
VALUES
    ('Tom Harris',     'C+E', '2022-03-15', 1),
    ('Priya Sharma',   'C',   '2023-01-10', 1),
    ('Carlos Rivera',  'C+E', '2021-08-22', 2),
    ('Emma Clarke',    'B',   '2024-02-01', 2),
    ('Dan Foster',     'C+E', '2022-11-30', 3),
    ('Aisha Obi',      'C',   '2023-06-14', 3),
    ('Liam Brooks',    'C+E', '2021-04-05', 4),
    ('Yuki Tanaka',    'C',   '2024-01-20', 4),
    ('Freya Knight',   'B',   '2023-09-01', 5),
    ('Marcus Chen',    'C+E', '2022-07-18', 5),
    ('Nina Petrova',   'C',   '2023-03-25', 6),
    ('James Webb',     'C+E', '2021-12-01', 6);

-- TABLE 3: vehicles (10 rows)
CREATE TABLE vehicles (
    vehicle_id    SERIAL        PRIMARY KEY,
    registration  VARCHAR(10)   NOT NULL UNIQUE,
    vehicle_type  VARCHAR(20)   NOT NULL
                  CHECK (vehicle_type IN ('van', 'truck', 'lorry')),
    max_weight_kg NUMERIC(10,2) NOT NULL CHECK (max_weight_kg > 0),
    depot_id      INTEGER       NOT NULL REFERENCES depots(depot_id)
);

INSERT INTO vehicles (registration, vehicle_type, max_weight_kg, depot_id)
VALUES
    ('BD21 KMT', 'lorry',  26000.00, 1),
    ('BD19 FWP', 'truck',  12000.00, 1),
    ('LS23 HRJ', 'van',     1200.00, 2),
    ('LS20 TNW', 'lorry',  26000.00, 2),
    ('GG22 PMR', 'truck',  12000.00, 3),
    ('GG18 BVL', 'lorry',  26000.00, 3),
    ('BV24 DKS', 'van',     1200.00, 4),
    ('CF21 JNR', 'truck',  12000.00, 5),
    ('CF23 WMB', 'lorry',  26000.00, 5),
    ('NR22 PSX', 'truck',  12000.00, 6);

-- TABLE 4: shipments (120 rows)
-- Includes deliberate data quality issues:
--   4 shipments marked 'delivered' with NULL delivery_date (9, 33, 51, 73)
--   3 shipments marked 'in_transit' with a delivery_date set (12, 37, 57)
--   5 duplicate tracking codes from system migration (116-120)

CREATE TABLE shipments (
    shipment_id      SERIAL        PRIMARY KEY,
    tracking_code    VARCHAR(20)   NOT NULL,
    depot_name       VARCHAR(50)   NOT NULL,
    vehicle_type     VARCHAR(20)   NOT NULL
                     CHECK (vehicle_type IN ('van', 'truck', 'lorry')),
    origin_city      VARCHAR(50)   NOT NULL,
    destination_city VARCHAR(50)   NOT NULL,
    region           VARCHAR(30)   NOT NULL,
    weight_kg        NUMERIC(10,2) NOT NULL CHECK (weight_kg > 0),
    cost             NUMERIC(10,2) NOT NULL CHECK (cost > 0),
    status           VARCHAR(20)   NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending', 'in_transit', 'delivered',
                                       'delayed', 'cancelled')),
    dispatch_date    DATE          NOT NULL,
    delivery_date    DATE,
    customer_name    VARCHAR(100)  NOT NULL,
    notes            TEXT
);

-- Bristol Hub shipments (1-25)
INSERT INTO shipments (tracking_code, depot_name, vehicle_type, origin_city, destination_city, region, weight_kg, cost, status, dispatch_date, delivery_date, customer_name, notes)
VALUES
('ORN-2025-0001', 'Bristol Hub', 'lorry',  'Bristol',    'London',      'South West', 18500.00, 1250.00, 'delivered',  '2025-01-06', '2025-01-07', 'Tesco Distribution',    NULL),
('ORN-2025-0002', 'Bristol Hub', 'lorry',  'Bristol',    'Southampton', 'South West', 22000.00, 1480.00, 'delivered',  '2025-01-08', '2025-01-09', 'Port Logistics UK',     NULL),
('ORN-2025-0003', 'Bristol Hub', 'truck',  'Bristol',    'Exeter',      'South West',  8500.00,  620.00, 'delivered',  '2025-01-10', '2025-01-11', 'Devon Building Supply', NULL),
('ORN-2025-0004', 'Bristol Hub', 'lorry',  'Bristol',    'Plymouth',    'South West', 19200.00, 1350.00, 'delivered',  '2025-01-13', '2025-01-14', 'SW Wholesale Ltd',      NULL),
('ORN-2025-0005', 'Bristol Hub', 'truck',  'Bristol',    'Swindon',     'South West',  9800.00,  710.00, 'delivered',  '2025-01-15', '2025-01-15', 'Nationwide Pallets',    NULL),
('ORN-2025-0006', 'Bristol Hub', 'lorry',  'Bristol',    'Reading',     'South West', 24500.00, 1620.00, 'delivered',  '2025-01-17', '2025-01-18', 'Thames Valley Foods',   NULL),
('ORN-2025-0007', 'Bristol Hub', 'truck',  'Bristol',    'Bath',        'South West',  6200.00,  380.00, 'delivered',  '2025-01-20', '2025-01-20', 'Heritage Stone Co',     NULL),
('ORN-2025-0008', 'Bristol Hub', 'lorry',  'Bristol',    'London',      'South West', 21000.00, 1400.00, 'delivered',  '2025-01-22', '2025-01-23', 'Tesco Distribution',    NULL),
('ORN-2025-0009', 'Bristol Hub', 'truck',  'Bristol',    'Gloucester',  'South West',  7400.00,  520.00, 'delivered',  '2025-01-24', NULL,          'Cotswold Timber',       'status needs review'),
('ORN-2025-0010', 'Bristol Hub', 'lorry',  'Bristol',    'Cardiff',     'South West', 16800.00, 1180.00, 'delivered',  '2025-01-27', '2025-01-28', 'Celtic Cold Chain',     NULL),
('ORN-2025-0011', 'Bristol Hub', 'lorry',  'Bristol',    'Taunton',     'South West', 20500.00, 1290.00, 'delivered',  '2025-01-29', '2025-01-30', 'Somerset Aggregates',   NULL),
('ORN-2025-0012', 'Bristol Hub', 'truck',  'Bristol',    'Cheltenham',  'South West', 10200.00,  740.00, 'in_transit', '2025-02-03', '2025-02-04', 'Regency Supplies',      'actually delivered'),
('ORN-2025-0013', 'Bristol Hub', 'lorry',  'Bristol',    'London',      'South West', 23400.00, 1550.00, 'delivered',  '2025-02-05', '2025-02-06', 'Port Logistics UK',     NULL),
('ORN-2025-0014', 'Bristol Hub', 'truck',  'Bristol',    'Exeter',      'South West',  8900.00,  640.00, 'delayed',    '2025-02-07', NULL,          'Devon Building Supply', 'driver reported road closure'),
('ORN-2025-0015', 'Bristol Hub', 'lorry',  'Bristol',    'Southampton', 'South West', 25000.00, 1700.00, 'delivered',  '2025-02-10', '2025-02-11', 'Hampshire Metals',      NULL),
('ORN-2025-0016', 'Bristol Hub', 'truck',  'Bristol',    'Swindon',     'South West',  7600.00,  530.00, 'delivered',  '2025-02-12', '2025-02-12', 'Nationwide Pallets',    NULL),
('ORN-2025-0017', 'Bristol Hub', 'lorry',  'Bristol',    'Plymouth',    'South West', 17500.00, 1220.00, 'delivered',  '2025-02-14', '2025-02-15', 'SW Wholesale Ltd',      NULL),
('ORN-2025-0018', 'Bristol Hub', 'lorry',  'Bristol',    'London',      'South West', 19800.00, 1380.00, 'delivered',  '2025-02-17', '2025-02-18', 'Tesco Distribution',    NULL),
('ORN-2025-0019', 'Bristol Hub', 'truck',  'Bristol',    'Bath',        'South West',  5800.00,  350.00, 'delivered',  '2025-02-19', '2025-02-19', 'Heritage Stone Co',     NULL),
('ORN-2025-0020', 'Bristol Hub', 'lorry',  'Bristol',    'Reading',     'South West', 22800.00, 1510.00, 'delivered',  '2025-02-21', '2025-02-22', 'Thames Valley Foods',   NULL),
('ORN-2025-0021', 'Bristol Hub', 'truck',  'Bristol',    'Gloucester',  'South West',  9100.00,  660.00, 'delivered',  '2025-02-24', '2025-02-25', 'Cotswold Timber',       NULL),
('ORN-2025-0022', 'Bristol Hub', 'lorry',  'Bristol',    'Taunton',     'South West', 21500.00, 1440.00, 'cancelled',  '2025-02-26', NULL,          'Somerset Aggregates',   'customer cancelled order'),
('ORN-2025-0023', 'Bristol Hub', 'lorry',  'Bristol',    'London',      'South West', 24000.00, 1600.00, 'delivered',  '2025-03-03', '2025-03-04', 'Port Logistics UK',     NULL),
('ORN-2025-0024', 'Bristol Hub', 'truck',  'Bristol',    'Cheltenham',  'South West', 11000.00,  790.00, 'delivered',  '2025-03-05', '2025-03-06', 'Regency Supplies',      NULL),
('ORN-2025-0025', 'Bristol Hub', 'lorry',  'Bristol',    'Southampton', 'South West', 20000.00, 1360.00, 'pending',    '2025-03-28', NULL,          'Hampshire Metals',      NULL),

-- Leeds Depot shipments (26-45)
('ORN-2025-0026', 'Leeds Depot', 'lorry',  'Leeds',      'Manchester',  'Yorkshire',  19000.00, 1100.00, 'delivered',  '2025-01-07', '2025-01-08', 'Northern Warehousing',  NULL),
('ORN-2025-0027', 'Leeds Depot', 'van',    'Leeds',      'York',        'Yorkshire',    950.00,  180.00, 'delivered',  '2025-01-09', '2025-01-09', 'York Crafts Ltd',       NULL),
('ORN-2025-0028', 'Leeds Depot', 'lorry',  'Leeds',      'Sheffield',   'Yorkshire',  22500.00, 1320.00, 'delivered',  '2025-01-13', '2025-01-14', 'Steel City Metals',     NULL),
('ORN-2025-0029', 'Leeds Depot', 'van',    'Leeds',      'Harrogate',   'Yorkshire',   1100.00,  210.00, 'delivered',  '2025-01-15', '2025-01-15', 'Harrogate Flowers',     NULL),
('ORN-2025-0030', 'Leeds Depot', 'lorry',  'Leeds',      'Hull',        'Yorkshire',  17500.00, 1050.00, 'delivered',  '2025-01-20', '2025-01-21', 'Humber Port Services',  NULL),
('ORN-2025-0031', 'Leeds Depot', 'van',    'Leeds',      'Bradford',    'Yorkshire',    800.00,  150.00, 'delivered',  '2025-01-22', '2025-01-22', 'Bradford Textiles',     NULL),
('ORN-2025-0032', 'Leeds Depot', 'lorry',  'Leeds',      'Manchester',  'Yorkshire',  21000.00, 1240.00, 'delivered',  '2025-01-27', '2025-01-28', 'Northern Warehousing',  NULL),
('ORN-2025-0033', 'Leeds Depot', 'lorry',  'Leeds',      'Newcastle',   'Yorkshire',  24000.00, 1580.00, 'delivered',  '2025-01-29', NULL,          'Tyne Industrial',       'status needs review'),
('ORN-2025-0034', 'Leeds Depot', 'van',    'Leeds',      'York',        'Yorkshire',   1050.00,  195.00, 'delivered',  '2025-02-03', '2025-02-03', 'York Crafts Ltd',       NULL),
('ORN-2025-0035', 'Leeds Depot', 'lorry',  'Leeds',      'Sheffield',   'Yorkshire',  18000.00, 1080.00, 'delayed',    '2025-02-05', NULL,          'Steel City Metals',     'M1 closure - rerouted via A1'),
('ORN-2025-0036', 'Leeds Depot', 'lorry',  'Leeds',      'Liverpool',   'Yorkshire',  20500.00, 1350.00, 'delivered',  '2025-02-10', '2025-02-11', 'Mersey Logistics',      NULL),
('ORN-2025-0037', 'Leeds Depot', 'van',    'Leeds',      'Harrogate',   'Yorkshire',    920.00,  175.00, 'in_transit', '2025-02-12', '2025-02-12', 'Harrogate Flowers',     'actually delivered'),
('ORN-2025-0038', 'Leeds Depot', 'lorry',  'Leeds',      'Hull',        'Yorkshire',  19500.00, 1150.00, 'delivered',  '2025-02-17', '2025-02-18', 'Humber Port Services',  NULL),
('ORN-2025-0039', 'Leeds Depot', 'lorry',  'Leeds',      'Manchester',  'Yorkshire',  23000.00, 1480.00, 'delivered',  '2025-02-24', '2025-02-25', 'Northern Warehousing',  NULL),
('ORN-2025-0040', 'Leeds Depot', 'van',    'Leeds',      'Bradford',    'Yorkshire',    750.00,  140.00, 'delivered',  '2025-02-26', '2025-02-26', 'Bradford Textiles',     NULL),
('ORN-2025-0041', 'Leeds Depot', 'lorry',  'Leeds',      'Newcastle',   'Yorkshire',  21500.00, 1420.00, 'delivered',  '2025-03-03', '2025-03-04', 'Tyne Industrial',       NULL),
('ORN-2025-0042', 'Leeds Depot', 'lorry',  'Leeds',      'Sheffield',   'Yorkshire',  16500.00,  980.00, 'delivered',  '2025-03-05', '2025-03-06', 'Steel City Metals',     NULL),
('ORN-2025-0043', 'Leeds Depot', 'van',    'Leeds',      'York',        'Yorkshire',   1100.00,  200.00, 'delivered',  '2025-03-10', '2025-03-10', 'York Crafts Ltd',       NULL),
('ORN-2025-0044', 'Leeds Depot', 'lorry',  'Leeds',      'Liverpool',   'Yorkshire',  25000.00, 1650.00, 'delayed',    '2025-03-17', NULL,          'Mersey Logistics',      'vehicle breakdown on M62'),
('ORN-2025-0045', 'Leeds Depot', 'lorry',  'Leeds',      'Manchester',  'Yorkshire',  18500.00, 1120.00, 'pending',    '2025-03-26', NULL,          'Northern Warehousing',  NULL),

-- Glasgow Terminal shipments (46-65)
('ORN-2025-0046', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Edinburgh',   'Scotland',  17000.00,  850.00, 'delivered',  '2025-01-08', '2025-01-08', 'Lothian Supplies',    NULL),
('ORN-2025-0047', 'Glasgow Terminal', 'truck',  'Glasgow',    'Dundee',      'Scotland',  11500.00,  720.00, 'delivered',  '2025-01-10', '2025-01-11', 'Tayside Timber',      NULL),
('ORN-2025-0048', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Aberdeen',    'Scotland',  23000.00, 1450.00, 'delivered',  '2025-01-14', '2025-01-15', 'North Sea Offshore',  NULL),
('ORN-2025-0049', 'Glasgow Terminal', 'truck',  'Glasgow',    'Stirling',    'Scotland',   8200.00,  510.00, 'delivered',  '2025-01-16', '2025-01-16', 'Central Belt Foods',  NULL),
('ORN-2025-0050', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Inverness',   'Scotland',  20000.00, 1380.00, 'delivered',  '2025-01-20', '2025-01-21', 'Highland Distribution',NULL),
('ORN-2025-0051', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Edinburgh',   'Scotland',  19500.00,  920.00, 'delivered',  '2025-01-23', NULL,          'Lothian Supplies',    'status needs review'),
('ORN-2025-0052', 'Glasgow Terminal', 'truck',  'Glasgow',    'Perth',       'Scotland',   9800.00,  640.00, 'delivered',  '2025-01-27', '2025-01-28', 'Perthshire Farms',    NULL),
('ORN-2025-0053', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Aberdeen',    'Scotland',  21500.00, 1520.00, 'delivered',  '2025-01-29', '2025-01-30', 'North Sea Offshore',  NULL),
('ORN-2025-0054', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Dundee',      'Scotland',  18000.00, 1100.00, 'delayed',    '2025-02-05', NULL,          'Tayside Timber',      'A9 snow closure'),
('ORN-2025-0055', 'Glasgow Terminal', 'truck',  'Glasgow',    'Stirling',    'Scotland',   7500.00,  470.00, 'delivered',  '2025-02-07', '2025-02-07', 'Central Belt Foods',  NULL),
('ORN-2025-0056', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Edinburgh',   'Scotland',  22000.00, 1050.00, 'delivered',  '2025-02-10', '2025-02-11', 'Lothian Supplies',    NULL),
('ORN-2025-0057', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Inverness',   'Scotland',  24500.00, 1620.00, 'in_transit', '2025-02-14', '2025-02-16', 'Highland Distribution','actually delivered'),
('ORN-2025-0058', 'Glasgow Terminal', 'truck',  'Glasgow',    'Perth',       'Scotland',  10500.00,  690.00, 'delivered',  '2025-02-19', '2025-02-20', 'Perthshire Farms',    NULL),
('ORN-2025-0059', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Aberdeen',    'Scotland',  19000.00, 1350.00, 'delivered',  '2025-02-24', '2025-02-25', 'North Sea Offshore',  NULL),
('ORN-2025-0060', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Edinburgh',   'Scotland',  16500.00,  810.00, 'delivered',  '2025-02-26', '2025-02-27', 'Lothian Supplies',    NULL),
('ORN-2025-0061', 'Glasgow Terminal', 'truck',  'Glasgow',    'Dundee',      'Scotland',  12000.00,  760.00, 'delivered',  '2025-03-03', '2025-03-04', 'Tayside Timber',      NULL),
('ORN-2025-0062', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Inverness',   'Scotland',  21000.00, 1450.00, 'cancelled',  '2025-03-05', NULL,          'Highland Distribution','route suspended due to weather'),
('ORN-2025-0063', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Aberdeen',    'Scotland',  25000.00, 1700.00, 'delivered',  '2025-03-10', '2025-03-11', 'North Sea Offshore',  NULL),
('ORN-2025-0064', 'Glasgow Terminal', 'truck',  'Glasgow',    'Stirling',    'Scotland',   8800.00,  550.00, 'delivered',  '2025-03-17', '2025-03-17', 'Central Belt Foods',  NULL),
('ORN-2025-0065', 'Glasgow Terminal', 'lorry',  'Glasgow',    'Edinburgh',   'Scotland',  20500.00,  980.00, 'pending',    '2025-03-27', NULL,          'Lothian Supplies',    NULL),

-- Birmingham Centre shipments (66-85)
('ORN-2025-0066', 'Birmingham Centre', 'van',    'Birmingham', 'Coventry',    'Midlands',   1100.00,  190.00, 'delivered',  '2025-01-07', '2025-01-07', 'Coventry Auto Parts',  NULL),
('ORN-2025-0067', 'Birmingham Centre', 'lorry',  'Birmingham', 'Nottingham',  'Midlands',  18500.00, 1150.00, 'delivered',  '2025-01-09', '2025-01-10', 'East Midlands Freight', NULL),
('ORN-2025-0068', 'Birmingham Centre', 'van',    'Birmingham', 'Wolverhampton','Midlands',    850.00,  160.00, 'delivered',  '2025-01-13', '2025-01-13', 'Black Country Metals',  NULL),
('ORN-2025-0069', 'Birmingham Centre', 'lorry',  'Birmingham', 'Leicester',   'Midlands',  21000.00, 1280.00, 'delivered',  '2025-01-15', '2025-01-16', 'Leicester Textiles',    NULL),
('ORN-2025-0070', 'Birmingham Centre', 'van',    'Birmingham', 'Stoke',       'Midlands',    980.00,  175.00, 'delivered',  '2025-01-20', '2025-01-20', 'Potteries Ceramics',    NULL),
('ORN-2025-0071', 'Birmingham Centre', 'lorry',  'Birmingham', 'Derby',       'Midlands',  17000.00, 1020.00, 'delivered',  '2025-01-22', '2025-01-23', 'Rolls-Royce Supply',    NULL),
('ORN-2025-0072', 'Birmingham Centre', 'van',    'Birmingham', 'Coventry',    'Midlands',   1200.00,  200.00, 'delivered',  '2025-01-27', '2025-01-27', 'Coventry Auto Parts',   NULL),
('ORN-2025-0073', 'Birmingham Centre', 'lorry',  'Birmingham', 'Nottingham',  'Midlands',  22000.00, 1350.00, 'delivered',  '2025-01-29', NULL,          'East Midlands Freight', 'status needs review'),
('ORN-2025-0074', 'Birmingham Centre', 'lorry',  'Birmingham', 'Leicester',   'Midlands',  19500.00, 1200.00, 'delivered',  '2025-02-05', '2025-02-06', 'Leicester Textiles',    NULL),
('ORN-2025-0075', 'Birmingham Centre', 'van',    'Birmingham', 'Wolverhampton','Midlands',    900.00,  165.00, 'delivered',  '2025-02-07', '2025-02-07', 'Black Country Metals',  NULL),
('ORN-2025-0076', 'Birmingham Centre', 'lorry',  'Birmingham', 'Derby',       'Midlands',  20000.00, 1180.00, 'delayed',    '2025-02-10', NULL,          'Rolls-Royce Supply',    'awaiting dock clearance'),
('ORN-2025-0077', 'Birmingham Centre', 'van',    'Birmingham', 'Stoke',       'Midlands',   1050.00,  185.00, 'delivered',  '2025-02-14', '2025-02-14', 'Potteries Ceramics',    NULL),
('ORN-2025-0078', 'Birmingham Centre', 'lorry',  'Birmingham', 'Nottingham',  'Midlands',  23500.00, 1420.00, 'delivered',  '2025-02-19', '2025-02-20', 'East Midlands Freight', NULL),
('ORN-2025-0079', 'Birmingham Centre', 'lorry',  'Birmingham', 'Leicester',   'Midlands',  16000.00,  950.00, 'delivered',  '2025-02-24', '2025-02-25', 'Leicester Textiles',    NULL),
('ORN-2025-0080', 'Birmingham Centre', 'van',    'Birmingham', 'Coventry',    'Midlands',   1150.00,  195.00, 'delivered',  '2025-02-26', '2025-02-26', 'Coventry Auto Parts',   NULL),
('ORN-2025-0081', 'Birmingham Centre', 'lorry',  'Birmingham', 'Derby',       'Midlands',  18000.00, 1080.00, 'delivered',  '2025-03-05', '2025-03-06', 'Rolls-Royce Supply',    NULL),
('ORN-2025-0082', 'Birmingham Centre', 'van',    'Birmingham', 'Wolverhampton','Midlands',    800.00,  150.00, 'delivered',  '2025-03-10', '2025-03-10', 'Black Country Metals',  NULL),
('ORN-2025-0083', 'Birmingham Centre', 'lorry',  'Birmingham', 'Nottingham',  'Midlands',  21500.00, 1300.00, 'delivered',  '2025-03-17', '2025-03-18', 'East Midlands Freight', NULL),
('ORN-2025-0084', 'Birmingham Centre', 'lorry',  'Birmingham', 'Leicester',   'Midlands',  24000.00, 1500.00, 'delayed',    '2025-03-19', NULL,          'Leicester Textiles',    'M69 closure'),
('ORN-2025-0085', 'Birmingham Centre', 'van',    'Birmingham', 'Stoke',       'Midlands',    950.00,  170.00, 'pending',    '2025-03-27', NULL,          'Potteries Ceramics',    NULL),

-- Cardiff Depot shipments (86-105)
('ORN-2025-0086', 'Cardiff Depot', 'truck',  'Cardiff',    'Swansea',     'Wales',       9500.00,  580.00, 'delivered',  '2025-01-08', '2025-01-08', 'Swansea Bay Imports',  NULL),
('ORN-2025-0087', 'Cardiff Depot', 'lorry',  'Cardiff',    'Newport',     'Wales',      18000.00, 1050.00, 'delivered',  '2025-01-10', '2025-01-11', 'Gwent Steel',          NULL),
('ORN-2025-0088', 'Cardiff Depot', 'truck',  'Cardiff',    'Carmarthen',  'Wales',       7800.00,  490.00, 'delivered',  '2025-01-15', '2025-01-16', 'West Wales Dairy',     NULL),
('ORN-2025-0089', 'Cardiff Depot', 'lorry',  'Cardiff',    'Bristol',     'Wales',      21000.00, 1250.00, 'delivered',  '2025-01-20', '2025-01-21', 'Celtic Cold Chain',    NULL),
('ORN-2025-0090', 'Cardiff Depot', 'truck',  'Cardiff',    'Swansea',     'Wales',      10200.00,  630.00, 'delivered',  '2025-01-24', '2025-01-24', 'Swansea Bay Imports',  NULL),
('ORN-2025-0091', 'Cardiff Depot', 'lorry',  'Cardiff',    'Newport',     'Wales',      19500.00, 1150.00, 'delivered',  '2025-01-29', '2025-01-30', 'Gwent Steel',          NULL),
('ORN-2025-0092', 'Cardiff Depot', 'truck',  'Cardiff',    'Carmarthen',  'Wales',       8500.00,  540.00, 'delayed',    '2025-02-05', NULL,          'West Wales Dairy',     'A48 flooding'),
('ORN-2025-0093', 'Cardiff Depot', 'lorry',  'Cardiff',    'Bristol',     'Wales',      22500.00, 1380.00, 'delivered',  '2025-02-10', '2025-02-11', 'Celtic Cold Chain',    NULL),
('ORN-2025-0094', 'Cardiff Depot', 'truck',  'Cardiff',    'Swansea',     'Wales',       9000.00,  560.00, 'delivered',  '2025-02-14', '2025-02-14', 'Swansea Bay Imports',  NULL),
('ORN-2025-0095', 'Cardiff Depot', 'lorry',  'Cardiff',    'Newport',     'Wales',      20000.00, 1200.00, 'delivered',  '2025-02-19', '2025-02-20', 'Gwent Steel',          NULL),
('ORN-2025-0096', 'Cardiff Depot', 'lorry',  'Cardiff',    'Aberystwyth', 'Wales',      16500.00,  980.00, 'delivered',  '2025-02-24', '2025-02-25', 'Mid Wales Agriculture', NULL),
('ORN-2025-0097', 'Cardiff Depot', 'truck',  'Cardiff',    'Carmarthen',  'Wales',      11000.00,  680.00, 'delivered',  '2025-03-03', '2025-03-04', 'West Wales Dairy',     NULL),
('ORN-2025-0098', 'Cardiff Depot', 'lorry',  'Cardiff',    'Bristol',     'Wales',      23000.00, 1420.00, 'delivered',  '2025-03-05', '2025-03-06', 'Celtic Cold Chain',    NULL),
('ORN-2025-0099', 'Cardiff Depot', 'truck',  'Cardiff',    'Swansea',     'Wales',       8200.00,  510.00, 'delivered',  '2025-03-10', '2025-03-10', 'Swansea Bay Imports',  NULL),
('ORN-2025-0100', 'Cardiff Depot', 'lorry',  'Cardiff',    'Newport',     'Wales',      17500.00, 1050.00, 'delivered',  '2025-03-17', '2025-03-18', 'Gwent Steel',          NULL),
('ORN-2025-0101', 'Cardiff Depot', 'lorry',  'Cardiff',    'Aberystwyth', 'Wales',      19000.00, 1120.00, 'cancelled',  '2025-03-19', NULL,          'Mid Wales Agriculture', 'customer requested delay to April'),
('ORN-2025-0102', 'Cardiff Depot', 'truck',  'Cardiff',    'Carmarthen',  'Wales',       9200.00,  570.00, 'delivered',  '2025-03-21', '2025-03-22', 'West Wales Dairy',     NULL),
('ORN-2025-0103', 'Cardiff Depot', 'lorry',  'Cardiff',    'Bristol',     'Wales',      24500.00, 1550.00, 'delivered',  '2025-03-24', '2025-03-25', 'Celtic Cold Chain',    NULL),
('ORN-2025-0104', 'Cardiff Depot', 'truck',  'Cardiff',    'Swansea',     'Wales',       7500.00,  460.00, 'delayed',    '2025-03-26', NULL,          'Swansea Bay Imports',  'driver illness'),
('ORN-2025-0105', 'Cardiff Depot', 'lorry',  'Cardiff',    'Newport',     'Wales',      18500.00, 1100.00, 'pending',    '2025-03-28', NULL,          'Gwent Steel',          NULL),

-- Norwich Hub shipments (106-115)
('ORN-2025-0106', 'Norwich Hub', 'truck',  'Norwich',    'Ipswich',     'East Anglia',  8000.00,  480.00, 'delivered',  '2025-01-09', '2025-01-09', 'Suffolk Grain Co',     NULL),
('ORN-2025-0107', 'Norwich Hub', 'truck',  'Norwich',    'Cambridge',   'East Anglia', 10500.00,  680.00, 'delivered',  '2025-01-15', '2025-01-16', 'Cambridge BioTech',    NULL),
('ORN-2025-0108', 'Norwich Hub', 'truck',  'Norwich',    'Peterborough','East Anglia',  9200.00,  590.00, 'delivered',  '2025-01-22', '2025-01-23', 'Fenland Produce',      NULL),
('ORN-2025-0109', 'Norwich Hub', 'truck',  'Norwich',    'Ipswich',     'East Anglia',  7500.00,  450.00, 'delivered',  '2025-02-05', '2025-02-05', 'Suffolk Grain Co',     NULL),
('ORN-2025-0110', 'Norwich Hub', 'truck',  'Norwich',    'Cambridge',   'East Anglia', 11000.00,  710.00, 'delivered',  '2025-02-14', '2025-02-15', 'Cambridge BioTech',    NULL),
('ORN-2025-0111', 'Norwich Hub', 'truck',  'Norwich',    'Kings Lynn',  'East Anglia',  8800.00,  550.00, 'delayed',    '2025-02-19', NULL,          'Norfolk Shellfish',    'frozen goods - reefer delay'),
('ORN-2025-0112', 'Norwich Hub', 'truck',  'Norwich',    'Peterborough','East Anglia',  9500.00,  610.00, 'delivered',  '2025-02-26', '2025-02-27', 'Fenland Produce',      NULL),
('ORN-2025-0113', 'Norwich Hub', 'truck',  'Norwich',    'Ipswich',     'East Anglia',  8200.00,  500.00, 'delivered',  '2025-03-10', '2025-03-10', 'Suffolk Grain Co',     NULL),
('ORN-2025-0114', 'Norwich Hub', 'truck',  'Norwich',    'Cambridge',   'East Anglia', 10000.00,  650.00, 'delivered',  '2025-03-19', '2025-03-20', 'Cambridge BioTech',    NULL),
('ORN-2025-0115', 'Norwich Hub', 'truck',  'Norwich',    'Kings Lynn',  'East Anglia',  7800.00,  470.00, 'pending',    '2025-03-27', NULL,          'Norfolk Shellfish',    NULL),

-- Duplicate tracking codes (system migration copies)
('ORN-2025-0013', 'Bristol Hub',       'lorry', 'Bristol',    'London',      'South West', 23400.00, 1550.00, 'delivered',  '2025-02-05', '2025-02-06', 'Port Logistics UK',     'duplicate - system switchover'),
('ORN-2025-0036', 'Leeds Depot',       'lorry', 'Leeds',      'Liverpool',   'Yorkshire',  20500.00, 1350.00, 'delivered',  '2025-02-10', '2025-02-11', 'Mersey Logistics',      'duplicate - system switchover'),
('ORN-2025-0056', 'Glasgow Terminal',  'lorry', 'Glasgow',    'Edinburgh',   'Scotland',   22000.00, 1050.00, 'delivered',  '2025-02-10', '2025-02-11', 'Lothian Supplies',      'duplicate - system switchover'),
('ORN-2025-0074', 'Birmingham Centre', 'lorry', 'Birmingham', 'Leicester',   'Midlands',   19500.00, 1200.00, 'delivered',  '2025-02-05', '2025-02-06', 'Leicester Textiles',    'duplicate - system switchover'),
('ORN-2025-0093', 'Cardiff Depot',     'lorry', 'Cardiff',    'Bristol',     'Wales',      22500.00, 1380.00, 'delivered',  '2025-02-10', '2025-02-11', 'Celtic Cold Chain',     'duplicate - system switchover');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM depots;      -- Expected: 6
SELECT COUNT(*) FROM drivers;     -- Expected: 12
SELECT COUNT(*) FROM vehicles;    -- Expected: 10
SELECT COUNT(*) FROM shipments;   -- Expected: 120
```

## Exercises

You are a data analyst at **Orion Freight**, a UK-based logistics company with six regional depots. Your operations director has a board meeting next week. He is presenting Q1 2025 performance - January through March - and he needs answers. But the warehouse team has warned that there are dodgy records in the system: shipments marked as delivered with no delivery date, shipments marked as in transit that have already been delivered, and duplicate entries from a system migration in February.

This is how real data projects work. You explore first, clean second, analyse third. Complete the following steps to build the board report:

### Step 1 - Explore the Raw Data

Query all four tables to understand what you are working with. How many depots are there? What vehicle types exist? How many shipments are in each status? Get a feel for the data before changing anything.

### Step 2 - Find the Mislabelled "Delivered" Records

Find all shipments where the status is 'delivered' but delivery_date is NULL. These have been mislabelled. There should be 4 of them (shipments 9, 33, 51, 73) - look for the notes that say "status needs review".

### Step 3 - Fix the Mislabelled "Delivered" Records

Update those 4 records: change their status from 'delivered' to 'pending' since we do not know when they were actually delivered. Always SELECT before UPDATE to preview what will change.

### Step 4 - Find the Mislabelled "In Transit" Records

Find all shipments where the status is 'in_transit' but delivery_date IS NOT NULL. These have actually been delivered. There should be 3 of them (shipments 12, 37, 57) - look for the notes that say "actually delivered".

### Step 5 - Fix the Mislabelled "In Transit" Records

Update those 3 records: change their status from 'in_transit' to 'delivered'. Again, SELECT first to preview.

### Step 6 - Find the Duplicate Tracking Codes

Use GROUP BY on tracking_code with HAVING COUNT(*) > 1 to find duplicate tracking codes. There should be 5 duplicated codes. Examine them to confirm they are genuine copies from the system migration.

### Step 7 - Remove the Duplicates

Delete the duplicate rows (the ones with the higher shipment_id - these are the migration copies, shipments 116-120). After deletion, the shipment count should drop from 120 to 115.

### Step 8 - Build the Executive Summary

Now that the data is clean, build the board report. Calculate total shipments by status, shipments per depot, total revenue by region, and the overall delivery rate. These are the numbers the operations director takes to the board.

## Key Concepts Covered
- **Explore first, clean second, analyse third**: The standard workflow for any real data project
- **SELECT before UPDATE or DELETE**: Always preview what will change before modifying data
- **GROUP BY + HAVING COUNT(*) > 1**: The go-to duplicate detection pattern for any table and any column
- **UPDATE with WHERE conditions**: Surgical data corrections targeting only the rows that need fixing
- **DELETE with subqueries or WHERE conditions**: Removing specific rows while keeping the originals
- **Aggregate functions for reporting**: COUNT, SUM, and GROUP BY to build executive-level summaries

---

[← Day 6: PRIMARY KEY, FOREIGN KEY & Constraints](../day-06/) | [Day 8: NULL Handling →](../day-08/)
