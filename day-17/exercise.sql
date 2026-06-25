-- Day 17: UNION and UNION ALL - Exercise Script
-- Exercise tables: invoices_sent (15 rows) + payments_received (12 rows)

DROP TABLE IF EXISTS payments_received;
DROP TABLE IF EXISTS invoices_sent;

-- TABLE 1: invoices_sent
-- Every invoice the firm has sent to a client.
CREATE TABLE invoices_sent (
    invoice_id     VARCHAR(10)    NOT NULL,
    client_name    VARCHAR(100)   NOT NULL,
    amount         NUMERIC(10,2)  NOT NULL,
    invoice_date   DATE           NOT NULL,
    category       VARCHAR(50)    NOT NULL
);

-- TABLE 2: payments_received
-- Every payment received from a client.
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

-- ============================================
-- EXERCISES
-- ============================================
-- You are supporting Rachel, Head of Finance at a consulting firm.
-- Every time the firm finishes a job, it sends an invoice.
-- When the client pays, that payment gets recorded separately.
-- So you have two tables:
--   invoices_sent     - 15 invoices the firm has sent out
--   payments_received - 12 payments that have come back in
--
-- Rachel needs a reconciliation report:
-- which invoices have been paid, which are still outstanding,
-- and how much each client owes overall.

-- Task 1: Combine All Transactions With Source Labels
--
-- Stack every invoice and every payment into one combined view.
-- Rename the columns so both sides line up:
--   invoice_id   -> ref_id
--   invoice_date -> trans_date
--   payment_id   -> ref_id
--   payment_date -> trans_date
-- Add a 'type' column labelled 'Invoice' or 'Payment' for each row.
-- Use UNION ALL (not UNION) - financial transactions must never be dropped.
-- Order by client_name, then trans_date.
-- Expected: 27 rows.

-- Write your query here:


-- Task 2: Find the Unpaid Invoices (and the Paid Ones)
--
-- Part A: Use EXCEPT to find invoices with no matching payment.
-- Match on client_name, amount, and category only
-- (leave out the IDs and dates - they will never match between the two tables).
-- Expected: 5 rows.

-- Write your query here:


-- Part B: Swap EXCEPT for INTERSECT to find invoices that DO have a matching payment.
-- Same three columns: client_name, amount, category.
-- Expected: 9 rows.

-- Write your query here:


-- Task 3: Per-Client Reconciliation Summary (Capstone)
--
-- Build a CTE called all_transactions that uses UNION ALL to combine
-- client_name, amount, and a 'type' label ('Invoice' or 'Payment')
-- from both tables (27 rows total).
--
-- Then write an outer query that reads from that CTE and produces
-- one row per client showing:
--   total_invoiced  - sum of all Invoice amounts for that client
--   total_paid      - sum of all Payment amounts for that client
--   balance_owed    - total_invoiced minus total_paid
--
-- Use SUM(CASE WHEN type = 'Invoice' THEN amount ELSE 0 END) for total_invoiced,
-- and the same pattern for total_paid.
-- Order by balance_owed DESC.
-- Expected: 5 rows, total balance owed across all clients = $6,600.

-- Write your query here:
