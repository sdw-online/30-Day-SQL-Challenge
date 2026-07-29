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
