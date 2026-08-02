-- Day 20: Data Modelling and Star Schema - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

-- Day 20 - Data Modelling (Star Schema) TEACHING dataset: cinema ticket sales.
-- One fact table (fact_ticket_sales) surrounded by dimension tables
-- (dim_films, dim_cinemas, dim_customers, dim_actors) plus a bridge
-- (bridge_film_actors) that resolves the films<->actors many-to-many.
-- Naming: fact_ / dim_ / bridge_ prefixes so the role is visible and tables group in pgAdmin.
-- Films, actors, cinemas are REAL (accurate castings/genres/studios/budgets/box office).
-- Customers are invented (privacy - real named individuals do not belong in demo data).
-- dim_films carries budget + worldwide box_office (millions USD) so the demo can teach
-- profit = box_office - budget; Babylon is a deliberate real-world flop for contrast.
--
-- WARNING: this script DROPs and rebuilds the 6 teaching tables below in PUBLIC.

-- =====================================================================
-- DROP (children before parents)
-- =====================================================================
DROP TABLE IF EXISTS bridge_film_actors CASCADE;
DROP TABLE IF EXISTS fact_ticket_sales CASCADE;
DROP TABLE IF EXISTS dim_films CASCADE;
DROP TABLE IF EXISTS dim_cinemas CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_actors CASCADE;

-- =====================================================================
-- DIMENSIONS
-- =====================================================================

CREATE TABLE dim_films (
    film_id       INTEGER PRIMARY KEY,
    title         VARCHAR(100) NOT NULL,
    genre         VARCHAR(40)  NOT NULL,
    studio        VARCHAR(60)  NOT NULL,   -- snowflake candidate: split into dim_studios
    release_year  INTEGER      NOT NULL,
    runtime_mins  INTEGER      NOT NULL,
    budget        NUMERIC(8,1) NOT NULL,   -- production budget, millions USD (dimension context, not a fact measure)
    box_office    NUMERIC(8,1) NOT NULL    -- worldwide gross, millions USD (the film's global take, not our ticket sales)
);

-- budget / box_office in millions USD. Babylon (id 4) is the deliberate flop (63 < 80 = a loss).
INSERT INTO dim_films (film_id, title, genre, studio, release_year, runtime_mins, budget, box_office) VALUES
(1, 'Inception',                     'Sci-Fi',  'Warner Bros', 2010, 148, 160.0,  837.0),
(2, 'The Wolf of Wall Street',       'Comedy',  'Paramount',   2013, 180, 100.0,  392.0),
(3, 'Once Upon a Time in Hollywood', 'Drama',   'Sony',        2019, 161,  96.0,  377.0),
(4, 'Babylon',                       'Drama',   'Paramount',   2022, 189,  80.0,   63.0),
(5, 'Barbie',                        'Comedy',  'Warner Bros', 2023, 114, 145.0, 1446.0),
(6, 'Oppenheimer',                   'Drama',   'Universal',   2023, 180, 100.0,  976.0),
(7, 'Interstellar',                  'Sci-Fi',  'Paramount',   2014, 169, 165.0,  731.0),
(8, 'Dunkirk',                       'War',     'Warner Bros', 2017, 106, 100.0,  527.0);

CREATE TABLE dim_cinemas (
    cinema_id     INTEGER PRIMARY KEY,
    cinema_name   VARCHAR(60) NOT NULL,
    city          VARCHAR(40) NOT NULL,
    screen_count  INTEGER     NOT NULL
);

INSERT INTO dim_cinemas (cinema_id, cinema_name, city, screen_count) VALUES
(1, 'Odeon Luxe Leicester Square', 'London',     5),
(2, 'Vue Printworks',              'Manchester', 20),
(3, 'Cineworld Bristol',           'Bristol',    14),
(4, 'Everyman Leeds',              'Leeds',      4);

CREATE TABLE dim_customers (
    customer_id      INTEGER PRIMARY KEY,
    customer_name    VARCHAR(60) NOT NULL,
    membership_tier  VARCHAR(20) NOT NULL   -- Standard / Premium
);

INSERT INTO dim_customers (customer_id, customer_name, membership_tier) VALUES
(1, 'Nathan Cole',   'Premium'),
(2, 'Amara Okafor',  'Standard'),
(3, 'Priya Nair',    'Premium'),
(4, 'Jacob Bennett', 'Standard'),
(5, 'Sofia Marin',   'Premium');

CREATE TABLE dim_actors (
    actor_id     INTEGER PRIMARY KEY,
    actor_name   VARCHAR(60) NOT NULL
);

INSERT INTO dim_actors (actor_id, actor_name) VALUES
(1, 'Leonardo DiCaprio'),
(2, 'Margot Robbie'),
(3, 'Cillian Murphy'),
(4, 'Tom Hardy'),
(5, 'Matthew McConaughey'),
(6, 'Brad Pitt'),
(7, 'Florence Pugh'),
(8, 'Anne Hathaway');

-- =====================================================================
-- FACT (grain: one ticket sold)
-- =====================================================================

CREATE TABLE fact_ticket_sales (
    sale_id      INTEGER PRIMARY KEY,
    sale_date    DATE    NOT NULL,
    film_id      INTEGER NOT NULL REFERENCES dim_films(film_id),
    cinema_id    INTEGER NOT NULL REFERENCES dim_cinemas(cinema_id),
    customer_id  INTEGER NOT NULL REFERENCES dim_customers(customer_id),
    price        NUMERIC(6,2) NOT NULL   -- the measure
);

INSERT INTO fact_ticket_sales (sale_id, sale_date, film_id, cinema_id, customer_id, price) VALUES
(1,  '2025-03-01', 1, 1, 1, 12.50),
(2,  '2025-03-01', 4, 1, 2, 12.50),
(3,  '2025-03-02', 2, 2, 3, 11.00),
(4,  '2025-03-03', 5, 1, 1, 12.50),
(5,  '2025-03-04', 4, 3, 4,  8.50),
(6,  '2025-03-05', 6, 4, 5, 14.00),
(7,  '2025-03-06', 1, 2, 2, 11.00),
(8,  '2025-03-07', 3, 1, 3, 12.50),
(9,  '2025-03-08', 7, 4, 1, 14.00),
(10, '2025-03-09', 4, 2, 5, 11.00),
(11, '2025-03-10', 2, 1, 4, 12.50),
(12, '2025-03-11', 8, 3, 2,  8.50),
(13, '2025-03-12', 5, 4, 3, 14.00),
(14, '2025-03-13', 1, 1, 5, 12.50),
(15, '2025-03-14', 6, 2, 1, 11.00),
(16, '2025-03-15', 4, 4, 4, 14.00),
(17, '2025-03-16', 3, 3, 2,  8.50),
(18, '2025-03-17', 7, 1, 3, 12.50),
(19, '2025-03-18', 2, 4, 5, 14.00),
(20, '2025-03-19', 5, 2, 1, 11.00),
(21, '2025-03-20', 8, 1, 4, 12.50),
(22, '2025-03-21', 6, 3, 3,  8.50),
(23, '2025-03-22', 1, 4, 2, 14.00),
(24, '2025-03-23', 4, 2, 5, 11.00),
(25, '2025-03-24', 5, 1, 1, 12.50);

-- =====================================================================
-- BRIDGE (resolves films <-> actors many-to-many)
-- a film has many actors; an actor appears in many films
-- =====================================================================

CREATE TABLE bridge_film_actors (
    film_id   INTEGER NOT NULL REFERENCES dim_films(film_id),
    actor_id  INTEGER NOT NULL REFERENCES dim_actors(actor_id),
    PRIMARY KEY (film_id, actor_id)
);

INSERT INTO bridge_film_actors (film_id, actor_id) VALUES
(1, 1), (1, 3), (1, 4),   -- Inception: DiCaprio, Murphy, Hardy
(2, 1), (2, 2), (2, 5),   -- The Wolf of Wall Street: DiCaprio, Robbie, McConaughey
(3, 1), (3, 2), (3, 6),   -- Once Upon a Time in Hollywood: DiCaprio, Robbie, Pitt
(4, 2), (4, 6),           -- Babylon: Robbie, Pitt
(5, 2),                   -- Barbie: Robbie
(6, 3), (6, 7),           -- Oppenheimer: Murphy, Pugh
(7, 5), (7, 8),           -- Interstellar: McConaughey, Hathaway
(8, 3), (8, 4);           -- Dunkirk: Murphy, Hardy

SELECT 'dim_films'         AS table_name, COUNT(*) AS row_count FROM dim_films
UNION ALL SELECT 'dim_cinemas',        COUNT(*) FROM dim_cinemas
UNION ALL SELECT 'dim_customers',      COUNT(*) FROM dim_customers
UNION ALL SELECT 'dim_actors',         COUNT(*) FROM dim_actors
UNION ALL SELECT 'bridge_film_actors', COUNT(*) FROM bridge_film_actors
UNION ALL SELECT 'fact_ticket_sales',  COUNT(*) FROM fact_ticket_sales
ORDER BY table_name;

-- Day 20 - Data Modelling (Star Schema) exercise dataset: renewable-energy generation + sites<->regions bridge.
-- Grain of generation_fact: one row per site per month.
-- site_region_supply is a many-to-many bridge (a site can supply several regions;
-- a region can be fed by several sites) - it is the ONLY path from a site to its regions,
-- since region is deliberately NOT a column on generation_fact.
--
-- WARNING: this script DROPs and rebuilds the 5 tables below in the PUBLIC schema.
-- Do not run against a live database without first confirming that is intended.

-- =====================================================================
-- DROP (children before parents)
-- =====================================================================
DROP TABLE IF EXISTS site_region_supply CASCADE;
DROP TABLE IF EXISTS generation_fact CASCADE;
DROP TABLE IF EXISTS sites CASCADE;
DROP TABLE IF EXISTS regions CASCADE;
DROP TABLE IF EXISTS time_periods CASCADE;

-- =====================================================================
-- CREATE TABLE - dimensions
-- =====================================================================

CREATE TABLE regions (
    region_id     INT PRIMARY KEY,
    region_name   TEXT NOT NULL,
    climate_zone  TEXT NOT NULL
);

CREATE TABLE sites (
    site_id       INT PRIMARY KEY,
    site_name     TEXT NOT NULL,
    site_type     TEXT NOT NULL,      -- Wind / Solar / Hydro / Gas / Coal
    is_renewable  BOOLEAN NOT NULL,
    capacity_mw   NUMERIC NOT NULL
);

CREATE TABLE time_periods (
    period_id     INT PRIMARY KEY,
    month_name    TEXT NOT NULL,
    quarter       TEXT NOT NULL       -- Q1..Q4
);

-- =====================================================================
-- CREATE TABLE - fact
-- =====================================================================

CREATE TABLE generation_fact (
    generation_id   INT PRIMARY KEY,
    site_id         INT NOT NULL REFERENCES sites(site_id),
    period_id       INT NOT NULL REFERENCES time_periods(period_id),
    kwh_generated   NUMERIC NOT NULL,
    cost_usd        NUMERIC NOT NULL
);

-- =====================================================================
-- CREATE TABLE - bridge (resolves sites <-> regions many-to-many)
-- =====================================================================

CREATE TABLE site_region_supply (
    site_id     INT NOT NULL REFERENCES sites(site_id),
    region_id   INT NOT NULL REFERENCES regions(region_id),
    PRIMARY KEY (site_id, region_id)
);

-- =====================================================================
-- INSERT - regions (4 rows)
-- =====================================================================

INSERT INTO regions (region_id, region_name, climate_zone) VALUES
(1, 'North',       'Cool Temperate'),
(2, 'Central',      'Temperate'),
(3, 'South-East',   'Mild Dry'),
(4, 'South-West',   'Mild Maritime');

-- =====================================================================
-- INSERT - sites (8 rows: 5 renewable, 3 fossil)
-- =====================================================================

INSERT INTO sites (site_id, site_name, site_type, is_renewable, capacity_mw) VALUES
(1, 'Whitelee Wind Farm',          'Wind',  TRUE,  539.0),
(2, 'Moray East Offshore Wind',    'Wind',  TRUE,  950.0),
(3, 'Cleve Hill Solar Park',       'Solar', TRUE,  350.0),
(4, 'Shotwick Solar',              'Solar', TRUE,  72.2),
(5, 'Cruachan Hydro',              'Hydro', TRUE,  440.0),
(6, 'Pembroke Gas',                'Gas',   FALSE, 2180.0),
(7, 'Grain Gas',                   'Gas',   FALSE, 1275.0),
(8, 'Ratcliffe Coal',              'Coal',  FALSE, 2000.0);

-- =====================================================================
-- INSERT - time_periods (12 rows: months of 2025)
-- =====================================================================

INSERT INTO time_periods (period_id, month_name, quarter) VALUES
(1,  'January',   'Q1'),
(2,  'February',  'Q1'),
(3,  'March',     'Q1'),
(4,  'April',     'Q2'),
(5,  'May',       'Q2'),
(6,  'June',      'Q2'),
(7,  'July',      'Q3'),
(8,  'August',    'Q3'),
(9,  'September', 'Q3'),
(10, 'October',   'Q4'),
(11, 'November',  'Q4'),
(12, 'December',  'Q4');

-- =====================================================================
-- INSERT - generation_fact (96 rows: 8 sites x 12 months)
-- Renewables (Wind/Hydro) skew higher generation in winter months;
-- Solar skews higher in summer months; fossil (Gas/Coal) stays fairly
-- steady with a light winter-demand uplift. Light-touch seasonality only.
-- =====================================================================

INSERT INTO generation_fact (generation_id, site_id, period_id, kwh_generated, cost_usd) VALUES
-- Whitelee Wind Farm (site 1, renewable)
(1,  1, 1,  202500.00, 4050.00),
(2,  1, 2,  191100.00, 3822.00),
(3,  1, 3,  175100.00, 3502.00),
(4,  1, 4,  149200.00, 2984.00),
(5,  1, 5,  117000.00, 2340.00),
(6,  1, 6,   98500.00, 1970.00),
(7,  1, 7,   89100.00, 1782.00),
(8,  1, 8,   99900.00, 1998.00),
(9,  1, 9,  128100.00, 2562.00),
(10, 1, 10, 155100.00, 3102.00),
(11, 1, 11, 191200.00, 3824.00),
(12, 1, 12, 202500.00, 4050.00),
-- Moray East Offshore Wind (site 2, renewable)
(13, 2, 1,  311800.00, 6236.00),
(14, 2, 2,  310900.00, 6218.00),
(15, 2, 3,  269600.00, 5392.00),
(16, 2, 4,  229800.00, 4596.00),
(17, 2, 5,  190400.00, 3808.00),
(18, 2, 6,  151700.00, 3034.00),
(19, 2, 7,  137200.00, 2744.00),
(20, 2, 8,  154000.00, 3080.00),
(21, 2, 9,  197300.00, 3946.00),
(22, 2, 10, 238900.00, 4778.00),
(23, 2, 11, 294600.00, 5892.00),
(24, 2, 12, 311800.00, 6236.00),
-- Cleve Hill Solar Park (site 3, renewable)
(25, 3, 1,   27800.00,  417.00),
(26, 3, 2,   37000.00,  555.00),
(27, 3, 3,   56500.00,  847.50),
(28, 3, 4,   79100.00, 1186.50),
(29, 3, 5,  110600.00, 1659.00),
(30, 3, 6,  128400.00, 1926.00),
(31, 3, 7,  137100.00, 2056.50),
(32, 3, 8,  122200.00, 1833.00),
(33, 3, 9,   87900.00, 1318.50),
(34, 3, 10,  57900.00,  868.50),
(35, 3, 11,  32400.00,  486.00),
(36, 3, 12,  23800.00,  357.00),
-- Shotwick Solar (site 4, renewable)
(37, 4, 1,   12900.00,  193.50),
(38, 4, 2,   16300.00,  244.50),
(39, 4, 3,   24800.00,  372.00),
(40, 4, 4,   36700.00,  550.50),
(41, 4, 5,   48600.00,  729.00),
(42, 4, 6,   56500.00,  847.50),
(43, 4, 7,   60400.00,  906.00),
(44, 4, 8,   53800.00,  807.00),
(45, 4, 9,   38600.00,  579.00),
(46, 4, 10,  25500.00,  382.50),
(47, 4, 11,  14300.00,  214.50),
(48, 4, 12,  11100.00,  166.50),
-- Cruachan Hydro (site 5, renewable)
(49, 5, 1,  113100.00, 1131.00),
(50, 5, 2,  105800.00, 1058.00),
(51, 5, 3,   98800.00,  988.00),
(52, 5, 4,   97200.00,  972.00),
(53, 5, 5,   90200.00,  902.00),
(54, 5, 6,   88300.00,  883.00),
(55, 5, 7,   86500.00,  865.00),
(56, 5, 8,   89700.00,  897.00),
(57, 5, 9,   98100.00,  981.00),
(58, 5, 10, 106300.00, 1063.00),
(59, 5, 11, 109200.00, 1092.00),
(60, 5, 12, 118200.00, 1182.00),
-- Pembroke Gas (site 6, non-renewable)
(61, 6, 1,  425200.00, 19134.00),
(62, 6, 2,  397700.00, 17896.50),
(63, 6, 3,  392300.00, 17653.50),
(64, 6, 4,  365400.00, 16443.00),
(65, 6, 5,  339300.00, 15268.50),
(66, 6, 6,  331800.00, 14931.00),
(67, 6, 7,  325300.00, 14638.50),
(68, 6, 8,  337500.00, 15187.50),
(69, 6, 9,  369100.00, 16609.50),
(70, 6, 10, 380800.00, 17136.00),
(71, 6, 11, 413900.00, 18625.50),
(72, 6, 12, 425200.00, 19134.00),
-- Grain Gas (site 7, non-renewable)
(73, 7, 1,  299400.00, 13473.00),
(74, 7, 2,  280000.00, 12600.00),
(75, 7, 3,  276200.00, 12429.00),
(76, 7, 4,  257200.00, 11574.00),
(77, 7, 5,  252400.00, 11358.00),
(78, 7, 6,  233700.00, 10516.50),
(79, 7, 7,  229000.00, 10305.00),
(80, 7, 8,  251100.00, 11299.50),
(81, 7, 9,  259800.00, 11691.00),
(82, 7, 10, 268000.00, 12060.00),
(83, 7, 11, 291500.00, 13117.50),
(84, 7, 12, 299400.00, 13473.00),
-- Ratcliffe Coal (site 8, non-renewable)
(85, 8, 1,  324200.00, 17831.00),
(86, 8, 2,  320400.00, 17622.00),
(87, 8, 3,  299100.00, 16450.50),
(88, 8, 4,  278500.00, 15317.50),
(89, 8, 5,  273200.00, 15026.00),
(90, 8, 6,  253000.00, 13915.00),
(91, 8, 7,  247900.00, 13634.50),
(92, 8, 8,  271900.00, 14954.50),
(93, 8, 9,  281400.00, 15477.00),
(94, 8, 10, 306600.00, 16863.00),
(95, 8, 11, 315700.00, 17363.50),
(96, 8, 12, 324200.00, 17831.00);

-- =====================================================================
-- INSERT - site_region_supply (19 rows: the bridge)
-- Several sites supply 2-3 regions; every region is fed by 4+ sites.
-- =====================================================================

INSERT INTO site_region_supply (site_id, region_id) VALUES
(1, 1),  -- Whitelee Wind Farm -> North
(1, 2),  -- Whitelee Wind Farm -> Central
(2, 1),  -- Moray East Offshore Wind -> North
(2, 2),  -- Moray East Offshore Wind -> Central
(2, 3),  -- Moray East Offshore Wind -> South-East
(3, 3),  -- Cleve Hill Solar Park -> South-East
(3, 4),  -- Cleve Hill Solar Park -> South-West
(4, 1),  -- Shotwick Solar -> North
(4, 4),  -- Shotwick Solar -> South-West
(5, 1),  -- Cruachan Hydro -> North
(5, 2),  -- Cruachan Hydro -> Central
(6, 2),  -- Pembroke Gas -> Central
(6, 3),  -- Pembroke Gas -> South-East
(6, 4),  -- Pembroke Gas -> South-West
(7, 2),  -- Grain Gas -> Central
(7, 3),  -- Grain Gas -> South-East
(8, 1),  -- Ratcliffe Coal -> North
(8, 2),  -- Ratcliffe Coal -> Central
(8, 4);  -- Ratcliffe Coal -> South-West

SELECT 'sites' AS table_name, COUNT(*) AS row_count FROM sites
UNION ALL
SELECT 'regions', COUNT(*) FROM regions
UNION ALL
SELECT 'time_periods', COUNT(*) FROM time_periods
UNION ALL
SELECT 'generation_fact', COUNT(*) FROM generation_fact
UNION ALL
SELECT 'site_region_supply', COUNT(*) FROM site_region_supply;