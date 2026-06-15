-- ============================================
-- DAY 15 SOLUTIONS: JOINs Part 1
-- ============================================

-- Task 1: Match incidents to responders (INNER JOIN)
SELECT
    i.incident_id,
    i.incident_type,
    i.severity,
    r.unit_name,
    r.unit_type,
    d.dispatched_at,
    d.arrived_at
FROM incidents i
INNER JOIN dispatches d ON i.incident_id = d.incident_id
INNER JOIN responder_units r ON d.unit_id = r.unit_id
ORDER BY i.reported_at;

-- Task 2a: All incidents with dispatch status (LEFT JOIN)
SELECT
    i.incident_id,
    i.incident_type,
    i.severity,
    i.status,
    d.dispatch_id,
    r.unit_name
FROM incidents i
LEFT JOIN dispatches d ON i.incident_id = d.incident_id
LEFT JOIN responder_units r ON d.unit_id = r.unit_id
ORDER BY i.reported_at;

-- Task 2b: Unassigned incidents only (anti-join)
SELECT
    i.incident_id,
    i.incident_type,
    i.location,
    i.severity,
    i.reported_at,
    i.status
FROM incidents i
LEFT JOIN dispatches d ON i.incident_id = d.incident_id
WHERE d.dispatch_id IS NULL
ORDER BY i.reported_at;

-- Task 3: Hospital capacity check (multi-table JOIN with SPLIT_PART)
SELECT
    i.incident_id,
    i.incident_type,
    i.severity,
    i.location,
    r.unit_name,
    h.hospital_name,
    h.available_beds,
    h.accepts_emergency
FROM incidents i
INNER JOIN dispatches d ON i.incident_id = d.incident_id
INNER JOIN responder_units r ON d.unit_id = r.unit_id
INNER JOIN hospital_capacity h
    ON h.nearest_district = SPLIT_PART(i.location, ', ', 2)
ORDER BY i.reported_at;
