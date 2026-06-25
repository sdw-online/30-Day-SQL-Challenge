-- ============================================
-- DAY 17 SOLUTIONS: UNION and UNION ALL
-- ============================================

-- Task 1: Combine all transactions with source labels (UNION ALL)
SELECT
    'Invoice'    AS type,
    invoice_id   AS ref_id,
    client_name,
    amount,
    invoice_date AS trans_date,
    category
FROM invoices_sent
UNION ALL
SELECT
    'Payment'    AS type,
    payment_id,
    client_name,
    amount,
    payment_date,
    category
FROM payments_received
ORDER BY client_name, trans_date;

-- Task 2a: Unpaid invoices - invoices with no matching payment (EXCEPT)
SELECT client_name, amount, category
FROM invoices_sent
EXCEPT
SELECT client_name, amount, category
FROM payments_received;

-- Task 2b: Paid invoices - invoices that DO have a matching payment (INTERSECT)
SELECT client_name, amount, category
FROM invoices_sent
INTERSECT
SELECT client_name, amount, category
FROM payments_received;

-- Task 3: Per-client reconciliation summary (UNION ALL inside a CTE + CASE WHEN)
WITH all_transactions AS (
    SELECT client_name, amount, 'Invoice' AS type
    FROM invoices_sent
    UNION ALL
    SELECT client_name, amount, 'Payment' AS type
    FROM payments_received
)
SELECT
    client_name,
    SUM(CASE WHEN type = 'Invoice' THEN amount ELSE 0 END) AS total_invoiced,
    SUM(CASE WHEN type = 'Payment' THEN amount ELSE 0 END) AS total_paid,
    SUM(CASE WHEN type = 'Invoice' THEN amount ELSE 0 END)
  - SUM(CASE WHEN type = 'Payment' THEN amount ELSE 0 END) AS balance_owed
FROM all_transactions
GROUP BY client_name
ORDER BY balance_owed DESC;
