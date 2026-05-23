-- ============================================
-- DAY 9 EXERCISE: City Road Maintenance Audit
-- ============================================
-- 25 road repair records from 4 council districts
-- Deliberately messy: inconsistent casing, leading/
-- trailing spaces, excessive decimal places.

DROP TABLE IF EXISTS raw_road_repairs;

CREATE TABLE raw_road_repairs (
    repair_id        SERIAL PRIMARY KEY,
    road_name        VARCHAR(100),
    district         VARCHAR(50),
    repair_type      VARCHAR(50),
    contractor_name  VARCHAR(100),
    contractor_email VARCHAR(100),
    repair_ref       VARCHAR(30),
    estimated_cost   NUMERIC(10,2),
    actual_cost      NUMERIC(10,2),
    length_metres    NUMERIC(8,2),
    completion_pct   NUMERIC(5,2)
);

INSERT INTO raw_road_repairs
    (road_name, district, repair_type, contractor_name, contractor_email, repair_ref, estimated_cost, actual_cost, length_metres, completion_pct)
VALUES
    (' Kings Road',        ' North',   'pothole',       'ROADFIX LTD',        'INFO@ROADFIX.CO.UK',        'RD-LON-A-0042', 4567.891234, 4812.3456,   120.50, 100.00),
    ('Victoria Lane',      'SOUTH',    'RESURFACING',   '  Asphalt Solutions', 'sales@asphaltsolutions.com', 'RD-LON-B-0117', 12890.45678, 13200.789,  340.75, 85.50),
    ('  Oxford Street  ',  'north',    ' Drainage ',    'cityPave',            'JOBS@CITYPAVE.COM',         'RD-LON-A-0203', 8920.123456, 8750.4567,   95.20,  100.00),
    ('BRIDGE ROAD',        'EAST',     'signage',       'ROADFIX LTD',        'INFO@ROADFIX.CO.UK',        'RD-BRI-B-0088', 2340.567891, 2340.567891, 45.00,  100.00),
    (' Church Lane',       'West',     'barrier',       'Metro Highways',      'contact@metrohighways.com', 'RD-MAN-A-0155', 6780.234561, 7100.891234, 88.30,  72.00),
    ('high street',        ' South ',  'pothole',       '  Asphalt Solutions', 'SALES@ASPHALTSOLUTIONS.COM','RD-LON-A-0301', 3450.789012, 3200.456789, 65.40,  100.00),
    ('  Park Avenue',      'NORTH',    'POTHOLE',       'cityPave',            'jobs@citypave.com',         'RD-LON-B-0044', 5670.345678, 5890.123456, 110.00, 90.00),
    ('Mill Lane',          'east',     'resurfacing',   'TarMac Pro',          'hello@TARMACPRO.COM',       'RD-EDI-A-0076', 15430.67891, 16200.34567, 420.50, 60.00),
    (' Station Road  ',    'West',     'drainage',      'ROADFIX LTD',        'info@roadfix.co.uk',        'RD-MAN-B-0091', 9870.456123, 10100.78912, 150.75, 45.00),
    ('QUEENS DRIVE',       'North',    ' Signage',      'Metro Highways',      'CONTACT@METROHIGHWAYS.COM', 'RD-LON-M-0012', 1890.234567, 1890.234567, 30.00,  100.00),
    ('Elm Grove',          'SOUTH',    'barrier',       '  Asphalt Solutions', 'sales@asphaltsolutions.com', 'RD-BRI-A-0134', 7650.891234, 8100.567891, 200.25, 80.00),
    (' Regent Street',     ' East',    'pothole',       'cityPave',            'Jobs@CityPave.com',         'RD-LON-A-0188', 4120.678912, 3980.345678, 75.60,  100.00),
    ('manor road',         'west',     'RESURFACING',   'TarMac Pro',          'Hello@TarMacPro.com',       'RD-MAN-A-0220', 11200.34567, 11800.89123, 310.00, 55.00),
    ('  Priory Lane  ',    'NORTH',    'drainage',      'ROADFIX LTD',        'INFO@ROADFIX.CO.UK',        'RD-EDI-B-0033', 6540.123789, 6540.123789, 105.80, 100.00),
    ('Castle Street',      ' south',   'signage',       'Metro Highways',      'contact@metrohighways.com', 'RD-LON-B-0256', 2100.456789, 2250.891234, 40.20,  95.00),
    ('BROOK LANE',         'East',     'pothole',       '  Asphalt Solutions', 'SALES@ASPHALTSOLUTIONS.COM','RD-BRI-M-0007', 3890.567123, 4100.234567, 82.50,  100.00),
    (' Waterloo Road',     'WEST',     ' Barrier ',     'cityPave',            'jobs@CITYPAVE.COM',         'RD-LON-A-0315', 8450.891234, 9200.456789, 175.30, 35.00),
    ('king edward avenue', 'north',    'resurfacing',   'TarMac Pro',          'hello@tarmacpro.com',       'RD-MAN-B-0148', 14300.23456, 13900.78912, 385.60, 70.00),
    ('Harbour Way',        'EAST',     'drainage',      'ROADFIX LTD',        'Info@RoadFix.co.uk',        'RD-BRI-A-0199', 7890.345612, 8200.123456, 130.40, 50.00),
    ('  Albert Road',      ' West ',   'POTHOLE',       'Metro Highways',      'Contact@MetroHighways.com', 'RD-EDI-A-0061', 5230.678901, 5230.678901, 98.70,  100.00),
    ('Pembroke Terrace',   'south',    'signage',       '  Asphalt Solutions', 'sales@asphaltsolutions.com', 'RD-LON-B-0278', 1750.234567, 1900.891234, 35.50,  88.00),
    (' Grafton Street',    'NORTH',    'barrier',       'cityPave',            'JOBS@CITYPAVE.COM',         'RD-LON-A-0332', 9100.456789, 9600.345678, 160.90, 25.00),
    ('NELSON WAY',         'East',     'resurfacing',   'TarMac Pro',          'Hello@TARMACPRO.COM',       'RD-BRI-B-0165', 13670.89123, 14100.56789, 365.20, 40.00),
    ('Gladstone Crescent', ' west',    ' Drainage',     'ROADFIX LTD',        'info@roadfix.co.uk',        'RD-MAN-M-0004', 8200.345678, 7900.123456, 115.60, 100.00),
    ('  Windsor Avenue ',  'SOUTH',    'pothole',       'Metro Highways',      'CONTACT@METROHIGHWAYS.COM', 'RD-EDI-B-0052', 4890.678912, 5100.234567, 90.80,  65.00);

-- Verify: Expected 25 rows
SELECT COUNT(*) AS total_repairs FROM raw_road_repairs;
