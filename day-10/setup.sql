-- ============================================
-- DAY 10 SETUP: Hotel booking data
-- ============================================
-- This creates a realistic dataset with:
--   - Guest DOBs spanning decades for AGE() calculations
--   - Booking dates spread across 2024-2026
--   - Check-in/check-out dates for duration calculations
--   - Some guests still checked in (check_out IS NULL)
--   - Loyalty member dates (some NULL for non-members)
--   - Mix of room types for grouping

DROP TABLE IF EXISTS hotel_bookings;

CREATE TABLE hotel_bookings (
    booking_id          SERIAL PRIMARY KEY,
    guest_name          VARCHAR(100)    NOT NULL,
    guest_dob           DATE            NOT NULL,
    booking_date        DATE            NOT NULL,
    check_in            DATE            NOT NULL,
    check_out           DATE,
    room_type           VARCHAR(30)     NOT NULL,
    nightly_rate        NUMERIC(8, 2)   NOT NULL,
    loyalty_member_since DATE
);

-- ============================================
-- INSERT: 30 hotel bookings with varied date patterns
-- ============================================

INSERT INTO hotel_bookings
    (guest_name, guest_dob, booking_date, check_in, check_out, room_type, nightly_rate, loyalty_member_since)
VALUES
    ('Lucy Barrett',       '1983-06-14', '2024-03-10', '2024-03-20', '2024-03-24', 'Deluxe',   145.00, '2021-01-15'),
    ('Joel Harding',       '1975-11-02', '2024-05-18', '2024-06-01', '2024-06-05', 'Standard',  89.00, NULL),
    ('Phoebe Saunders',    '1990-08-25', '2024-07-22', '2024-08-10', '2024-08-14', 'Suite',    275.00, '2019-06-01'),
    ('Sam Whitfield',      '1968-02-17', '2024-09-05', '2024-09-15', '2024-09-18', 'Standard',  89.00, '2020-03-22'),
    ('Rosie Crawford',     '2001-04-30', '2024-10-12', '2024-10-20', '2024-10-23', 'Deluxe',   145.00, NULL),
    ('Jack Thornton',      '1955-12-08', '2024-11-01', '2024-11-10', '2024-11-15', 'Suite',    275.00, '2016-09-10'),
    ('Clara Preston',      '1997-01-19', '2024-12-03', '2024-12-20', '2024-12-27', 'Standard',  89.00, NULL),
    ('Ade Ogunbiyi',       '1986-09-06', '2025-01-08', '2025-01-15', '2025-01-19', 'Deluxe',   155.00, '2022-07-14'),
    ('Mia Donovan',        '1972-03-21', '2025-01-20', '2025-02-01', '2025-02-04', 'Standard',  95.00, '2018-11-30'),
    ('Niall Corrigan',     '2005-07-13', '2025-02-05', '2025-02-14', '2025-02-17', 'Deluxe',   155.00, NULL),
    ('Kate Lawson',        '1960-10-27', '2025-02-18', '2025-03-01', '2025-03-06', 'Suite',    290.00, '2017-04-05'),
    ('Kieran Frost',       '1993-05-04', '2025-03-02', '2025-03-10', '2025-03-13', 'Standard',  95.00, NULL),
    ('Hannah Cole',        '1980-12-16', '2025-03-15', '2025-03-25', '2025-03-29', 'Deluxe',   155.00, '2023-01-20'),
    ('Oscar Briggs',       '1965-08-09', '2025-04-01', '2025-04-10', '2025-04-14', 'Suite',    290.00, '2015-08-18'),
    ('Ella Marsh',         '1998-02-22', '2025-04-08', '2025-04-15', NULL,          'Standard',  95.00, NULL),
    ('David Perry',        '1957-06-03', '2025-04-10', '2025-04-16', NULL,          'Deluxe',   155.00, '2014-02-28'),
    ('Chidinma Eze',       '1991-11-14', '2025-04-12', '2025-04-18', NULL,          'Suite',    290.00, '2024-06-01'),
    ('Fraser Mitchell',    '2003-09-28', '2025-05-01', '2025-05-10', '2025-05-13', 'Standard',  95.00, NULL),
    ('Natsuki Yamamoto',   '1978-04-15', '2025-05-14', '2025-05-22', '2025-05-26', 'Deluxe',   160.00, '2020-10-12'),
    ('Gemma Elliot',       '1988-01-07', '2025-06-02', '2025-06-10', '2025-06-14', 'Standard', 100.00, '2023-09-05'),
    ('Leo Chambers',       '1970-07-19', '2025-06-18', '2025-06-25', '2025-06-29', 'Suite',    310.00, NULL),
    ('Sade Adjei',         '1995-10-31', '2025-07-05', '2025-07-12', '2025-07-16', 'Deluxe',   160.00, '2022-03-17'),
    ('Connor Walsh',       '1962-03-24', '2025-08-01', '2025-08-10', NULL,          'Standard', 100.00, '2019-12-01'),
    ('Priti Desai',        '2000-05-20', '2025-08-15', '2025-08-22', NULL,          'Suite',    310.00, NULL),
    ('Alfie Turner',       '1985-12-02', '2025-09-01', '2025-09-08', NULL,          'Deluxe',   160.00, '2021-05-10'),
    ('Tessa Holt',         '1987-05-22', '2026-01-10', '2026-01-18', '2026-01-22', 'Deluxe',   165.00, '2023-04-15'),
    ('Ruben Castillo',     '1994-08-14', '2026-02-05', '2026-02-14', '2026-02-18', 'Standard', 105.00, NULL),
    ('Dina Osman',         '1976-03-09', '2026-03-12', '2026-03-20', '2026-03-25', 'Suite',    320.00, '2020-11-01'),
    ('Archie Webb',        '2001-11-30', '2026-04-08', '2026-04-14', NULL,          'Deluxe',   165.00, NULL),
    ('Nina Eriksson',      '1983-01-17', '2026-04-15', '2026-04-18', NULL,          'Standard', 105.00, '2022-08-20');

-- Verify: Expected 30 rows
SELECT COUNT(*) AS total_bookings FROM hotel_bookings;
