-- Day 06: PRIMARY KEY, FOREIGN KEY & Constraints - Setup Script
-- Run this in pgAdmin to create today's tables
-- Note: sample data requires the Python seed script (day_06_seed.py) - see README for details

-- Clean up any existing tables (reverse dependency order)
DROP TABLE IF EXISTS playlist_tracks;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS streams;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS subscribers;

-- TABLE 1: subscribers
CREATE TABLE subscribers (
    subscriber_id   SERIAL          PRIMARY KEY,
    first_name      VARCHAR(50)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    plan            VARCHAR(20)     NOT NULL DEFAULT 'free'
                                    CHECK (plan IN ('free', 'premium', 'family')),
    signup_date     DATE            NOT NULL DEFAULT CURRENT_DATE,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    country         VARCHAR(50)     NOT NULL DEFAULT 'United Kingdom'
);

-- TABLE 2: artists
CREATE TABLE artists (
    artist_id       SERIAL          PRIMARY KEY,
    artist_name     VARCHAR(100)    NOT NULL UNIQUE,
    genre           VARCHAR(50)     NOT NULL,
    country         VARCHAR(50)     NOT NULL,
    formed_year     INTEGER         CHECK (formed_year >= 1900 AND formed_year <= 2025),
    is_verified     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 3: albums
CREATE TABLE albums (
    album_id        SERIAL          PRIMARY KEY,
    album_title     VARCHAR(200)    NOT NULL,
    artist_id       INTEGER         NOT NULL
                                    REFERENCES artists(artist_id)
                                    ON DELETE CASCADE,
    release_date    DATE            NOT NULL,
    total_tracks    INTEGER         NOT NULL CHECK (total_tracks > 0),
    UNIQUE (artist_id, album_title)
);

-- TABLE 4: tracks
CREATE TABLE tracks (
    track_id        SERIAL          PRIMARY KEY,
    track_title     VARCHAR(200)    NOT NULL,
    album_id        INTEGER         NOT NULL
                                    REFERENCES albums(album_id)
                                    ON DELETE CASCADE,
    track_number    INTEGER         NOT NULL CHECK (track_number > 0),
    duration_secs   INTEGER         NOT NULL CHECK (duration_secs > 0 AND duration_secs < 7200),
    is_explicit     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- TABLE 5: streams
CREATE TABLE streams (
    stream_id       SERIAL          PRIMARY KEY,
    subscriber_id   INTEGER
                    REFERENCES subscribers(subscriber_id)
                    ON DELETE SET NULL,
    track_id        INTEGER         NOT NULL
                    REFERENCES tracks(track_id)
                    ON DELETE CASCADE,
    streamed_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    duration_secs   INTEGER         NOT NULL CHECK (duration_secs >= 0)
);

-- TABLE 6: playlists
CREATE TABLE playlists (
    playlist_id     SERIAL          PRIMARY KEY,
    playlist_name   VARCHAR(100)    NOT NULL,
    subscriber_id   INTEGER         NOT NULL
                    REFERENCES subscribers(subscriber_id)
                    ON DELETE CASCADE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    is_public       BOOLEAN         NOT NULL DEFAULT TRUE
);

-- TABLE 7: playlist_tracks (junction table)
CREATE TABLE playlist_tracks (
    playlist_id     INTEGER         NOT NULL
                    REFERENCES playlists(playlist_id)
                    ON DELETE CASCADE,
    track_id        INTEGER         NOT NULL
                    REFERENCES tracks(track_id)
                    ON DELETE CASCADE,
    added_at        TIMESTAMP       NOT NULL DEFAULT NOW(),
    position        INTEGER         NOT NULL CHECK (position > 0),
    PRIMARY KEY (playlist_id, track_id)
);
