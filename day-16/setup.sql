-- Day 16: CROSS JOIN & Self Joins - Setup Script
-- Teaching tables: airports (6 rows) + flights (10 rows)

DROP TABLE IF EXISTS patient_prescriptions;
DROP TABLE IF EXISTS interactions;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;

-- ============================================
-- TABLE 1: airports
-- ============================================
-- Each row is one airport city. Used for the CROSS JOIN section:
-- pair every origin with every destination to build a route grid.

CREATE TABLE airports (
    airport_id  SERIAL PRIMARY KEY,
    city        VARCHAR(40) NOT NULL,
    country     VARCHAR(40) NOT NULL
);

-- ============================================
-- TABLE 2: flights
-- ============================================
-- Each row is one scheduled flight (a single leg). Used for self joins:
--   - connecting flights: one flight lands where another departs (destination = origin)
--   - same-route comparison: two airlines flying the same origin -> destination

CREATE TABLE flights (
    flight_no    VARCHAR(10)  PRIMARY KEY,
    airline      VARCHAR(40)  NOT NULL,
    origin       VARCHAR(40)  NOT NULL,
    destination  VARCHAR(40)  NOT NULL,
    depart_time  TIME         NOT NULL,
    arrive_time  TIME         NOT NULL,
    price        NUMERIC(6,2) NOT NULL
);

-- ============================================
-- INSERT: 6 airport cities
-- ============================================
-- Order matters: London=1, Paris=2, Dubai=3 mirror the concept animations.

INSERT INTO airports
    (city, country)
VALUES
    ('London',    'United Kingdom'),
    ('Paris',     'France'),
    ('Dubai',     'United Arab Emirates'),
    ('New York',  'United States'),
    ('Tokyo',     'Japan'),
    ('Singapore', 'Singapore');

-- ============================================
-- INSERT: 10 flights
-- ============================================
-- Dubai is the connecting hub:
--   4 flights INTO Dubai (from London x2, Paris x2)
--   4 flights OUT of Dubai (to Singapore x2, Tokyo x2)
-- That gives 4 x 4 = 16 possible connecting journeys via Dubai (before timing),
-- and 13 once we require the onward flight to depart after the first one lands
-- (the late Paris arrival at 15:45 misses three onward departures).
-- Five routes are flown by two airlines each -> five same-route price comparisons.

INSERT INTO flights
    (flight_no, airline, origin, destination, depart_time, arrive_time, price)
VALUES
    -- Into Dubai (arrive midday)
    ('EK002', 'Emirates',           'London', 'Dubai',     '06:00', '12:00', 520.00),
    ('BA107', 'British Airways',    'London', 'Dubai',     '07:30', '13:30', 575.00),
    ('AF202', 'Air France',         'Paris',  'Dubai',     '06:30', '12:15', 540.00),
    ('EK074', 'Emirates',           'Paris',  'Dubai',     '10:00', '15:45', 495.00),  -- late arrival

    -- Out of Dubai (depart afternoon)
    ('EK354', 'Emirates',           'Dubai',  'Singapore', '14:30', '21:00', 480.00),
    ('SQ495', 'Singapore Airlines', 'Dubai',  'Singapore', '16:00', '22:30', 455.00),
    ('EK318', 'Emirates',           'Dubai',  'Tokyo',     '15:00', '23:00', 610.00),
    ('JL034', 'Japan Airlines',     'Dubai',  'Tokyo',     '14:45', '22:45', 650.00),

    -- Transatlantic competition (no Dubai connection - for same-route comparison only)
    ('BA177', 'British Airways',    'London', 'New York',  '09:00', '12:00', 430.00),
    ('VS003', 'Virgin Atlantic',    'London', 'New York',  '11:00', '14:00', 395.00);
