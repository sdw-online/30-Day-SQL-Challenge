-- Day 18: Normalisation and Denormalisation - Setup Script
-- 30 Day SQL Challenge | Stephen | Data

DROP TABLE IF EXISTS song_plays;

CREATE TABLE song_plays (
    playlist_name VARCHAR(60)  NOT NULL,
    position      INT          NOT NULL,
    song_title    VARCHAR(100) NOT NULL,
    artist        VARCHAR(80)  NOT NULL,
    album         VARCHAR(120) NOT NULL,
    release_year  INT          NOT NULL,
    genres        VARCHAR(120) NOT NULL
);

INSERT INTO song_plays (playlist_name, position, song_title, artist, album, release_year, genres) VALUES
('Throwbacks', 1, 'Billie Jean',     'Michael Jackson', 'Thriller',                                   1982, 'pop, funk, disco'),
('Throwbacks', 2, 'Beat It',         'Michael Jackson', 'Thriller',                                   1982, 'rock, pop, funk'),
('Gym',        1, 'Billie Jean',     'Michael Jackson', 'Thriller',                                   1982, 'pop, funk, disco'),
('Gym',        2, 'Beat It',         'Michael Jackson', 'Thriller',                                   1982, 'rock, pop, funk'),
('Gym',        3, 'Blinding Lights', 'The Weeknd',      'After Hours',                                2020, 'pop, synth-pop'),
('Gym',        4, 'Titanium',        'David Guetta',    'Nothing but the Beat',                       2011, 'dance, house'),
('Gym',        5, 'Unstoppable',     'Sia',             'This Is Acting',                             2016, 'pop, dance-pop'),
('Pop Hits',   1, 'Blinding Lights', 'The Weeknd',      'After Hours',                                2020, 'pop, synth-pop'),
('Pop Hits',   2, 'Titanium',        'David Guetta',    'Nothing but the Beat',                       2011, 'dance, house'),
('Pop Hits',   3, 'Unstoppable',     'Sia',             'This Is Acting',                             2016, 'pop, dance-pop'),
('Pop Hits',   4, 'Love Again',      'Dua Lipa',        'Future Nostalgia',                           2020, 'pop, nu-disco'),
('UK Rap',     1, 'Band4Band',       'Central Cee',     'Can''t Rush Greatness',                       2025, 'uk drill, uk rap'),
('UK Rap',     2, 'Not Over Yet',    'KSI',             'All Over the Place',                         2021, 'uk rap, pop'),
('UK Rap',     3, 'All Eyes on You', 'Meek Mill',       'Dreams Worth More Than Money',               2015, 'hip hop'),
('Focus',      1, 'Time',            'Hans Zimmer',     'Inception (Music from the Motion Picture)',  2010, 'cinematic'),
('Focus',      2, 'Don''t Cry',      'Frank Edwards',   'Frankincense',                               2016, 'gospel'),
('Focus',      3, 'Terminator',      'Asake',           'Mr. Money With the Vibe',                    2022, 'afrobeats, amapiano, fuji');

SELECT * FROM song_plays LIMIT 5;
