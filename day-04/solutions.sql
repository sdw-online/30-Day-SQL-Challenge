-- ============================================
-- DAY 4 SOLUTIONS: Aggregate Functions & GROUP BY
-- ============================================

-- Q1: Single-row summary
SELECT
    COUNT(*)                          AS total_transactions,
    SUM(transaction_amount)           AS total_revenue,
    ROUND(AVG(transaction_amount), 2) AS avg_transaction,
    MIN(transaction_amount)           AS smallest_transaction,
    MAX(transaction_amount)           AS largest_transaction
FROM client_transactions;

-- Q2: Unique clients and sales reps
SELECT
    COUNT(DISTINCT client_name) AS unique_clients,
    COUNT(DISTINCT sales_rep)   AS unique_reps
FROM client_transactions;

-- Q3: Department-level revenue breakdown
SELECT
    department,
    COUNT(*)                AS transaction_count,
    SUM(transaction_amount) AS total_revenue
FROM client_transactions
GROUP BY department
ORDER BY total_revenue DESC;

-- Q4: Sales rep performance (revenue > 300,000)
SELECT
    sales_rep,
    department,
    COUNT(*)                AS transaction_count,
    SUM(transaction_amount) AS total_revenue
FROM client_transactions
GROUP BY sales_rep, department
HAVING SUM(transaction_amount) > 300000
ORDER BY total_revenue DESC;

-- Q5: Departments with cash revenue exceeding 75,000
SELECT
    department,
    SUM(transaction_amount) AS cash_revenue,
    COUNT(*)                AS cash_transactions
FROM client_transactions
WHERE payment_method = 'Cash'
GROUP BY department
HAVING SUM(transaction_amount) > 75000;
