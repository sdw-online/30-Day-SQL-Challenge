-- ============================================
-- DAY 8 SETUP: library_books table for NULL Handling
-- ============================================
-- A small library catalogue with intentional NULL
-- patterns that mirror real-world data quality issues:
--   - Books never borrowed (NULL last_borrower)
--   - Missing genres (NULL genre)
--   - Full-price books with no discount (NULL discount_pct)
--   - Reserved but not yet borrowed (reserved_by without last_borrower)

DROP TABLE IF EXISTS library_books;

CREATE TABLE library_books (
    book_id        SERIAL PRIMARY KEY,
    title          VARCHAR(100)    NOT NULL,
    author         VARCHAR(100)    NOT NULL,
    genre          VARCHAR(50),
    base_price     NUMERIC(6, 2)   NOT NULL,
    discount_pct   NUMERIC(5, 2),
    page_count     INTEGER         NOT NULL DEFAULT 0,
    is_available   BOOLEAN         NOT NULL DEFAULT TRUE,
    last_borrower  VARCHAR(50),
    reserved_by    VARCHAR(50),
    return_date    DATE
);

-- ============================================
-- INSERT: 20 books with intentional NULL patterns
-- ============================================
-- Pattern 1: 6 books never borrowed (NULL last_borrower, NULL return_date)
-- Pattern 2: 6 books with no genre recorded (NULL genre)
-- Pattern 3: 8 books at full price (NULL discount_pct)
-- Pattern 4: Some books reserved but never borrowed (reserved_by set, last_borrower NULL)
-- Pattern 5: 1 book with page_count = 0 (pamphlet/digital - triggers division by zero)
-- Pattern 6: 1 book with genre = 'Unknown' (legacy placeholder)

INSERT INTO library_books
    (title, author, genre, base_price, discount_pct, page_count, is_available, last_borrower, reserved_by, return_date)
VALUES
    ('The Glass Library',   'A. Morton',  'Fiction',  14.99,  NULL,   320,  TRUE,   NULL,      NULL,    NULL),
    ('Midnight Garden',     'B. Shaw',    'Fiction',  18.50,  NULL,   280,  TRUE,   NULL,      'Holly', NULL),
    ('Paper Kingdoms',      'C. Frost',   'Fiction',  22.99,  NULL,   410,  TRUE,   NULL,      NULL,    NULL),
    ('The Lost Chapter',    'D. Webb',    'Fiction',  12.99,  10.00,  195,  FALSE,  NULL,      'Jake',  NULL),
    ('Signal and Noise',    'E. Hart',    NULL,       29.99,  NULL,   0,    TRUE,   NULL,      NULL,    NULL),
    ('Quiet Earth',         'F. Lane',    NULL,       9.99,   NULL,   150,  TRUE,   NULL,      'Quinn', NULL),
    ('Dark Waters',         'G. Cole',    'Mystery',  16.99,  15.00,  340,  TRUE,   'Alice',   NULL,    '2025-02-10'),
    ('The Iron Bridge',     'H. Voss',    'History',  24.99,  20.00,  520,  TRUE,   'Ben',     NULL,    '2025-01-20'),
    ('Code Red',            'J. Osei',    'Science',  31.50,  10.00,  290,  TRUE,   'Callum',  NULL,    '2025-03-05'),
    ('Silent Witness',      'K. Ruiz',    'Mystery',  19.99,  15.00,  380,  TRUE,   'Ellie',   NULL,    '2024-12-15'),
    ('The Amber Room',      'L. Kato',    'Fiction',  27.50,  25.00,  450,  TRUE,   'George',  NULL,    '2025-04-01'),
    ('First Light',         'M. Chen',    NULL,       14.99,  NULL,   200,  TRUE,   'Grace',   NULL,    '2025-02-28'),
    ('Rust and Gold',       'N. Bell',    'History',  21.00,  10.00,  310,  FALSE,  'Harry',   NULL,    '2024-11-10'),
    ('The Quiet Storm',     'P. Das',     NULL,       35.99,  20.00,  280,  TRUE,   'Hiroshi', NULL,    '2025-03-18'),
    ('Border Lines',        'Q. Flynn',   'Science',  17.50,  15.00,  240,  TRUE,   'Jess',    NULL,    '2025-01-05'),
    ('The Long Walk',       'R. Mbeki',   'Unknown',  11.99,  10.00,  180,  TRUE,   'Lily',    NULL,    '2025-04-12'),
    ('Ocean Deep',          'S. Vega',    'Fiction',  28.00,  15.00,  360,  TRUE,   'Max',     NULL,    '2025-02-22'),
    ('The Wire',            'T. Holt',    NULL,       23.50,  15.00,  270,  TRUE,   'Megan',   NULL,    '2025-03-30'),
    ('Ghost Protocol',      'U. Khan',    'Mystery',  19.99,  NULL,   300,  TRUE,   'Safiya',  NULL,    '2025-04-08'),
    ('Stone Garden',        'V. Park',    NULL,       26.99,  NULL,   220,  TRUE,   'River',   NULL,    '2025-01-15');

-- Verify: Expected 20 rows
SELECT COUNT(*) AS total_books FROM library_books;
