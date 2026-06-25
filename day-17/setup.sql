-- Day 17: UNION and UNION ALL - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

-- ============================================
-- DAY 17 SETUP: Music library merge
-- ============================================
-- Teaching tables: songs across two platforms
-- Exercise tables: invoices sent vs payments received
-- ============================================

-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS spotify_songs;
DROP TABLE IF EXISTS youtube_songs;
DROP TABLE IF EXISTS invoices_sent;
DROP TABLE IF EXISTS payments_received;

-- ============================================
-- TABLE 1: spotify_songs
-- ============================================
-- Songs saved in your Spotify library

CREATE TABLE spotify_songs (
    song_title     VARCHAR(100)   NOT NULL,
    artist         VARCHAR(100)   NOT NULL,
    genre          VARCHAR(50)    NOT NULL,
    duration_secs  INTEGER        NOT NULL,
    added_date     DATE           NOT NULL
);

-- ============================================
-- TABLE 2: youtube_songs
-- ============================================
-- Songs saved in your YouTube Music library
-- Same structure as spotify_songs (required for UNION)

CREATE TABLE youtube_songs (
    song_title     VARCHAR(100)   NOT NULL,
    artist         VARCHAR(100)   NOT NULL,
    genre          VARCHAR(50)    NOT NULL,
    duration_secs  INTEGER        NOT NULL,
    added_date     DATE           NOT NULL
);

-- ============================================
-- INSERT: 12 Spotify songs
-- ============================================
-- Some songs also appear in youtube_songs (deliberate overlap)

INSERT INTO spotify_songs
    (song_title, artist, genre, duration_secs, added_date)
VALUES
    -- 3 songs that also appear in youtube_songs (the deliberate overlap - rows MUST be identical)
    ('Calm Down',                  'Rema',                                                     'Afrobeats', 239, '2025-03-14'),
    ('Essence',                    'Wizkid ft. Tems',                                          'Afrobeats', 248, '2025-08-22'),
    ('Water',                      'Tyla',                                                     'Amapiano',  200, '2026-01-09'),
    -- 9 Spotify-only songs (added_date scattered, always after the song's release)
    ('Nakupenda',                  'TxC ft. Davido, Shoday, Scotts Maphuma, Zlatan & Al Xapo', 'Amapiano',  252, '2025-06-03'),
    ('Hot Body',                   'Ayra Starr',                                               'Afrobeats', 178, '2026-02-26'),
    ('Praise the Lord (Da Shine)', 'A$AP Rocky ft. Skepta',                                    'Hip-Hop',   219, '2025-02-11'),
    ('My Head & My Heart',         'Ava Max',                                                  'Pop',       171, '2025-11-27'),
    ('Love Again',                 'Dua Lipa',                                                 'Pop',       258, '2025-04-19'),
    ('wgft',                       'Gunna ft. Burna Boy',                                      'Hip-Hop',   184, '2025-12-05'),
    ('The Last Dragon',            'Youngs Teflon',                                            'UK Rap',    226, '2026-06-18'),
    ('Last Last',                  'Burna Boy',                                                'Afrobeats', 173, '2025-09-30'),
    ('Sprinter',                   'Dave & Central Cee',                                       'UK Rap',    229, '2026-03-22');

-- ============================================
-- INSERT: 10 YouTube songs
-- ============================================
-- 3 songs are identical to Spotify entries (same title, artist, genre, duration, date)
-- These deliberate duplicates demonstrate UNION vs UNION ALL

INSERT INTO youtube_songs
    (song_title, artist, genre, duration_secs, added_date)
VALUES
    -- 3 songs identical to spotify_songs (same title, artist, genre, duration, date) - the UNION dedup demo
    ('Calm Down',                  'Rema',                             'Afrobeats', 239, '2025-03-14'),
    ('Essence',                    'Wizkid ft. Tems',                  'Afrobeats', 248, '2025-08-22'),
    ('Water',                      'Tyla',                             'Amapiano',  200, '2026-01-09'),
    -- 7 YouTube-only songs (added_date scattered, always after the song's release)
    ('Under the Influence',        'Chris Brown',                      'R&B',       184, '2025-01-25'),
    ('I''m Blessed',               'Sinach',                           'Gospel',    360, '2025-05-13'),
    ('Obsession',                  'C Biz',                            'UK Drill',  198, '2025-10-08'),
    ('Plot Twist',                 'Drake',                            'Hip-Hop',   235, '2026-06-12'),
    ('A.W.A.',                     'Lacrim ft. French Montana',        'Rap',       217, '2025-03-29'),
    ('Sink a Boat',                'Giggs & Blade Brown ft. Fem Fel',  'UK Rap',    244, '2025-07-16'),
    ('Toca Toca (Radio Edit)',     'Fly Project',                      'Dance',     165, '2026-04-21');

-- ============================================
-- TABLE 3: invoices_sent
-- ============================================
-- Invoices the company has sent to clients

CREATE TABLE invoices_sent (
    invoice_id     VARCHAR(10)    NOT NULL,
    client_name    VARCHAR(100)   NOT NULL,
    amount         NUMERIC(10,2)  NOT NULL,
    invoice_date   DATE           NOT NULL,
    category       VARCHAR(50)    NOT NULL
);

-- ============================================
-- TABLE 4: payments_received
-- ============================================
-- Payments received from clients

CREATE TABLE payments_received (
    payment_id     VARCHAR(10)    NOT NULL,
    client_name    VARCHAR(100)   NOT NULL,
    amount         NUMERIC(10,2)  NOT NULL,
    payment_date   DATE           NOT NULL,
    category       VARCHAR(50)    NOT NULL
);

-- ============================================
-- INSERT: 15 invoices sent
-- ============================================
-- Some invoices have matching payments, some do not (overdue)
-- Some have matching amounts but different dates (late payments)

INSERT INTO invoices_sent
    (invoice_id, client_name, amount, invoice_date, category)
VALUES
    ('INV-001', 'Ishan Mehta',       2500.00, '2025-01-05', 'Consulting'),
    ('INV-002', 'Jamila Osei',       1800.00, '2025-01-10', 'Design'),
    ('INV-003', 'Samir Hadid',       4200.00, '2025-01-15', 'Development'),
    ('INV-004', 'Gabriela Costa',    3100.00, '2025-01-20', 'Consulting'),
    ('INV-005', 'Xin Liu',           1500.00, '2025-02-01', 'Design'),
    ('INV-006', 'Ishan Mehta',       2500.00, '2025-02-10', 'Consulting'),
    ('INV-007', 'Jamila Osei',       2200.00, '2025-02-15', 'Development'),
    ('INV-008', 'Samir Hadid',       3800.00, '2025-02-20', 'Design'),
    ('INV-009', 'Gabriela Costa',    1900.00, '2025-03-01', 'Consulting'),
    ('INV-010', 'Xin Liu',           2700.00, '2025-03-05', 'Development'),
    ('INV-011', 'Ishan Mehta',       3300.00, '2025-03-10', 'Design'),
    ('INV-012', 'Jamila Osei',       1600.00, '2025-03-15', 'Consulting'),
    ('INV-013', 'Samir Hadid',       4500.00, '2025-03-20', 'Development'),
    ('INV-014', 'Gabriela Costa',    2100.00, '2025-03-25', 'Design'),
    ('INV-015', 'Xin Liu',           1800.00, '2025-04-01', 'Consulting');

-- ============================================
-- INSERT: 12 payments received
-- ============================================
-- Most payments match invoices by client + amount
-- 2 payments have NO matching invoice (overpayments / duplicates)
-- 3 invoices have NO matching payment (overdue)

INSERT INTO payments_received
    (payment_id, client_name, amount, payment_date, category)
VALUES
    ('PAY-001', 'Ishan Mehta',       2500.00, '2025-01-20', 'Consulting'),
    ('PAY-002', 'Jamila Osei',       1800.00, '2025-01-25', 'Design'),
    ('PAY-003', 'Samir Hadid',       4200.00, '2025-02-01', 'Development'),
    ('PAY-004', 'Gabriela Costa',    3100.00, '2025-02-05', 'Consulting'),
    ('PAY-005', 'Xin Liu',           1500.00, '2025-02-15', 'Design'),
    ('PAY-006', 'Ishan Mehta',       2500.00, '2025-02-25', 'Consulting'),
    ('PAY-007', 'Jamila Osei',       2200.00, '2025-03-01', 'Development'),
    ('PAY-008', 'Samir Hadid',       3800.00, '2025-03-05', 'Design'),
    ('PAY-009', 'Gabriela Costa',    1900.00, '2025-03-15', 'Consulting'),
    ('PAY-010', 'Xin Liu',           2700.00, '2025-03-20', 'Development'),
    ('PAY-011', 'Ishan Mehta',       2500.00, '2025-03-28', 'Consulting'),
    ('PAY-012', 'Samir Hadid',       4200.00, '2025-03-30', 'Development');

SELECT 'spotify_songs' AS table_name, COUNT(*) AS row_count FROM spotify_songs
UNION ALL
SELECT 'youtube_songs', COUNT(*) FROM youtube_songs;

-- Songs that appear in BOTH platforms with identical details
SELECT s.song_title, s.artist
FROM spotify_songs s
INNER JOIN youtube_songs y
    ON s.song_title = y.song_title
    AND s.artist = y.artist
    AND s.genre = y.genre
    AND s.duration_secs = y.duration_secs
    AND s.added_date = y.added_date;

SELECT 'invoices_sent' AS table_name, COUNT(*) AS row_count FROM invoices_sent
UNION ALL
SELECT 'payments_received', COUNT(*) FROM payments_received;

SELECT * FROM invoices_sent LIMIT 5;