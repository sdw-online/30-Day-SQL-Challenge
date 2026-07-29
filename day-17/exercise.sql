-- Day 17: UNION and UNION ALL - Exercise Script
-- 30 Day SQL Challenge | Stephen | Data

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
