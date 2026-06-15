-- Day 15: JOINs Part 1 - Exercise Script
-- Exercise tables: incidents (12 rows) + responder_units (10 rows) + dispatches (8 rows) + hospital_capacity (5 rows)

DROP TABLE IF EXISTS hospital_capacity;
DROP TABLE IF EXISTS dispatches;
DROP TABLE IF EXISTS responder_units;
DROP TABLE IF EXISTS incidents;

-- TABLE 1: incidents
CREATE TABLE incidents (
    incident_id     SERIAL PRIMARY KEY,
    incident_type   VARCHAR(30)   NOT NULL,
    location        VARCHAR(100)  NOT NULL,
    severity        VARCHAR(20)   NOT NULL,
    reported_at     TIMESTAMP     NOT NULL,
    status          VARCHAR(30)   NOT NULL DEFAULT 'open'
);

-- TABLE 2: responder_units
CREATE TABLE responder_units (
    unit_id         SERIAL PRIMARY KEY,
    unit_name       VARCHAR(50)   NOT NULL,
    unit_type       VARCHAR(30)   NOT NULL,
    base_location   VARCHAR(100)  NOT NULL,
    status          VARCHAR(30)   NOT NULL DEFAULT 'available'
);

-- TABLE 3: dispatches (linking table between incidents and responder_units)
CREATE TABLE dispatches (
    dispatch_id     SERIAL PRIMARY KEY,
    incident_id     INTEGER       NOT NULL REFERENCES incidents(incident_id),
    unit_id         INTEGER       NOT NULL REFERENCES responder_units(unit_id),
    dispatched_at   TIMESTAMP     NOT NULL,
    arrived_at      TIMESTAMP,
    notes           TEXT
);

-- TABLE 4: hospital_capacity
CREATE TABLE hospital_capacity (
    hospital_id        SERIAL PRIMARY KEY,
    hospital_name      VARCHAR(100)  NOT NULL,
    total_beds         INTEGER       NOT NULL,
    available_beds     INTEGER       NOT NULL,
    accepts_emergency  BOOLEAN       NOT NULL DEFAULT TRUE,
    nearest_district   VARCHAR(100)  NOT NULL
);

-- ============================================
-- INSERT: 12 incidents
-- ============================================
-- Incidents 9-12 have NO dispatch record (unassigned)

INSERT INTO incidents
    (incident_type, location, severity, reported_at, status)
VALUES
    ('fire',     'Elm Street, District 3',        'high',     '2025-05-01 08:15:00', 'resolved'),
    ('medical',  'Oak Avenue, District 1',        'critical', '2025-05-01 09:30:00', 'resolved'),
    ('traffic',  'Highway 7, District 5',         'medium',   '2025-05-01 10:45:00', 'resolved'),
    ('fire',     'Maple Road, District 2',        'low',      '2025-05-01 14:00:00', 'resolved'),
    ('medical',  'Pine Street, District 4',       'high',     '2025-05-02 07:20:00', 'dispatched'),
    ('hazmat',   'Industrial Park, District 6',   'critical', '2025-05-02 11:00:00', 'dispatched'),
    ('traffic',  'Bridge Road, District 1',       'low',      '2025-05-02 13:30:00', 'resolved'),
    ('medical',  'Cedar Lane, District 3',        'medium',   '2025-05-02 16:45:00', 'dispatched'),
    ('fire',     'Birch Court, District 5',       'high',     '2025-05-03 06:00:00', 'open'),
    ('traffic',  'River Road, District 2',        'medium',   '2025-05-03 08:30:00', 'open'),
    ('hazmat',   'Factory Lane, District 6',      'critical', '2025-05-03 10:15:00', 'open'),
    ('medical',  'Station Road, District 4',      'high',     '2025-05-03 12:00:00', 'open');

-- ============================================
-- INSERT: 10 responder units
-- ============================================
-- Units 8-10 have NO dispatch record (never dispatched)

INSERT INTO responder_units
    (unit_name, unit_type, base_location, status)
VALUES
    ('Engine 1',      'fire_engine', 'Station Alpha, District 1',  'dispatched'),
    ('Ambulance 1',   'ambulance',   'Station Beta, District 2',   'dispatched'),
    ('Patrol 1',      'patrol',      'Station Alpha, District 1',  'available'),
    ('Engine 2',      'fire_engine', 'Station Gamma, District 4',  'dispatched'),
    ('Ambulance 2',   'ambulance',   'Station Beta, District 2',   'available'),
    ('Hazmat 1',      'hazmat',      'Station Delta, District 6',  'dispatched'),
    ('Patrol 2',      'patrol',      'Station Gamma, District 4',  'available'),
    ('Engine 3',      'fire_engine', 'Station Alpha, District 1',  'available'),
    ('Ambulance 3',   'ambulance',   'Station Delta, District 6',  'maintenance'),
    ('Hazmat 2',      'hazmat',      'Station Gamma, District 4',  'available');

-- ============================================
-- INSERT: 8 dispatches (linking incidents to responder units)
-- ============================================
-- Only incidents 1-8 have dispatches; 9-12 are unassigned

INSERT INTO dispatches
    (incident_id, unit_id, dispatched_at, arrived_at, notes)
VALUES
    (1, 1, '2025-05-01 08:18:00', '2025-05-01 08:30:00', 'Fire contained quickly'),
    (2, 2, '2025-05-01 09:33:00', '2025-05-01 09:45:00', 'Patient stabilised on scene'),
    (3, 3, '2025-05-01 10:48:00', '2025-05-01 11:00:00', 'Minor collision cleared'),
    (4, 4, '2025-05-01 14:05:00', '2025-05-01 14:20:00', 'Small kitchen fire'),
    (5, 5, '2025-05-02 07:25:00', NULL,                   'En route - cardiac alert'),
    (6, 6, '2025-05-02 11:05:00', NULL,                   'Chemical spill containment'),
    (7, 7, '2025-05-02 13:33:00', '2025-05-02 13:45:00', 'Traffic light malfunction'),
    (8, 2, '2025-05-02 16:48:00', NULL,                   'Fall injury assessment');

-- ============================================
-- INSERT: 5 hospitals
-- ============================================

INSERT INTO hospital_capacity
    (hospital_name, total_beds, available_beds, accepts_emergency, nearest_district)
VALUES
    ('City General Hospital',         500, 42, TRUE,  'District 1'),
    ('Riverside Medical Centre',      320, 15, TRUE,  'District 2'),
    ('Northside Community Hospital',  180,  8, TRUE,  'District 4'),
    ('Eastview Clinic',               120, 30, FALSE, 'District 5'),
    ('Central Trauma Centre',         400,  5, TRUE,  'District 3');
