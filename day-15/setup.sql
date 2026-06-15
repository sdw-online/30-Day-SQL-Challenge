-- Day 15: JOINs Part 1 - Setup Script
-- Teaching tables: users (8 rows) + songs (12 rows) + playlist_tracks (17 rows)

DROP TABLE IF EXISTS playlist_tracks;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id            SERIAL PRIMARY KEY,
    username           VARCHAR(50)   NOT NULL,
    display_name       VARCHAR(100)  NOT NULL,
    signup_date        DATE          NOT NULL,
    subscription_type  VARCHAR(20)   NOT NULL DEFAULT 'free'
);

CREATE TABLE songs (
    song_id           SERIAL PRIMARY KEY,
    title             VARCHAR(150)  NOT NULL,
    artist            VARCHAR(100)  NOT NULL,
    genre             VARCHAR(50)   NOT NULL,
    duration_seconds  INTEGER       NOT NULL,
    release_year      INTEGER       NOT NULL
);

-- Each row is one song added to a playlist by a user
-- Links users to songs via user_id and song_id
CREATE TABLE playlist_tracks (
    playlist_track_id  SERIAL PRIMARY KEY,
    user_id            INTEGER       NOT NULL,  -- soft reference (no FK): a user can be deleted but their playlist rows remain as orphans
    song_id            INTEGER       NOT NULL REFERENCES songs(song_id),
    playlist_name      VARCHAR(100)  NOT NULL,
    added_date         DATE          NOT NULL
);

-- ============================================
-- INSERT: 8 users
-- ============================================
-- Users 6-8 have NO playlist entries (for LEFT JOIN demos)

INSERT INTO users
    (username, display_name, signup_date, subscription_type)
VALUES
    ('ren_m',       'Ren',      '2024-01-15', 'premium'),
    ('ida_k',       'Ida',      '2024-03-22', 'free'),
    ('sven_l',      'Sven',     '2024-05-10', 'premium'),
    ('anjali_r',    'Anjali',   '2024-07-08', 'free'),
    ('akira_t',     'Akira',    '2024-09-14', 'premium'),
    ('clara_w',     'Clara',    '2024-11-01', 'free'),
    ('noah_b',      'Noah',     '2025-01-20', 'free'),
    ('piper_s',     'Piper',    '2025-03-05', 'premium');

-- ============================================
-- INSERT: 12 songs
-- ============================================
-- Songs 10-12 do NOT appear in any playlist (for anti-join demos)

INSERT INTO songs
    (title, artist, genre, duration_seconds, release_year)
VALUES
    ('Calm Down',           'Rema',                                      'Afrobeats',   237, 2022),
    ('In Da Club',          '50 Cent',                                   'Hip Hop',     198, 2003),
    ('With You',            'Chris Brown',                               'R&B',         264, 2007),
    ('Stick Season',        'Noah Kahan',                                'Folk',        182, 2022),
    ('The Loneliest',       'Maneskin',                                  'Rock',        312, 2022),
    ('Asibe Happy',         'Kabza De Small, DJ Maphorisa & Ami Faku',   'Amapiano',    245, 2021),
    ('Doja',                'Central Cee',                               'UK Rap',      210, 2022),
    ('Temperature',         'Sean Paul',                                 'Dancehall',   278, 2005),
    ('Chaise Longue',       'Wet Leg',                                   'Indie Pop',   195, 2021),
    ('Unavailable',         'Davido ft. Musa Keys',                      'Afrobeats',   320, 2023),
    ('Mnike',               'Tyler ICU & Tumelo.za',                     'Amapiano',    256, 2023),
    ('Ripples in the Sand', 'Hans Zimmer',                               'Cinematics',  188, 2021);

-- ============================================
-- INSERT: 17 playlist tracks (15 valid + 2 orphan)
-- ============================================
-- Only users 1-5 have playlist entries
-- Only songs 1-9 appear in playlists
-- The final 2 rows are orphans: they reference user 99, a deleted user with no
-- matching row in the users table. They appear only in a FULL OUTER JOIN
-- (right-only rows), never in an INNER or LEFT JOIN driven from users.

INSERT INTO playlist_tracks
    (user_id, song_id, playlist_name, added_date)
VALUES
    (1, 1, 'Late Night Vibes',       '2024-02-10'),
    (1, 3, 'Late Night Vibes',       '2024-02-10'),
    (1, 6, 'Amapiano Chill',         '2024-03-15'),
    (2, 2, 'Sunday Morning',         '2024-04-01'),
    (2, 4, 'Sunday Morning',         '2024-04-01'),
    (2, 7, 'Sunday Morning',         '2024-04-22'),
    (3, 1, 'Afrobeats Workout',      '2024-06-05'),
    (3, 5, 'Afrobeats Workout',      '2024-06-05'),
    (3, 8, 'Afrobeats Workout',      '2024-06-18'),
    (4, 2, 'Study Focus',            '2024-08-12'),
    (4, 9, 'Study Focus',            '2024-08-12'),
    (4, 3, 'Party Mix',              '2024-09-01'),
    (5, 4, 'Road Trip',              '2024-10-10'),
    (5, 5, 'Road Trip',              '2024-10-10'),
    (5, 1, 'Road Trip',              '2024-11-02'),
    -- Orphan rows: user 99 was deleted, but these playlist entries were left behind.
    -- There is no user_id 99 in the users table - these are right-only rows for FULL OUTER JOIN.
    (99, 2, 'Forgotten Favourites',  '2024-12-15'),
    (99, 4, 'Forgotten Favourites',  '2024-12-15');
