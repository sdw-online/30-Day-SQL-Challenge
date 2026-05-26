-- ============================================
-- DAY 5 SOLUTIONS: INSERT, UPDATE & DELETE
-- ============================================

-- Q1: Insert three new tickets
INSERT INTO support_tickets (customer_name, customer_email, issue_description, priority, status, assigned_to, created_date, product_name)
VALUES
    ('Suki Patel', 'suki@pateldesign.co.uk', 'Heatmap not tracking mobile clicks', 'High', 'Open', NULL, '2025-04-16', 'Heatmap Tracker'),
    ('Jordan Marsh', 'jordan@marshconsulting.com', 'Need invoice for April', 'Low', 'Open', NULL, '2025-04-16', 'Enterprise Dashboard'),
    ('Freya Mitchell', 'freya@mitchellhr.com', 'A/B test variant not loading', 'Medium', 'Open', NULL, '2025-04-16', 'A/B Test Runner');

-- Q2: Preview unassigned open tickets, then assign to Suki Patel
SELECT * FROM support_tickets WHERE status = 'Open' AND assigned_to IS NULL;

UPDATE support_tickets
SET assigned_to = 'Suki Patel'
WHERE status = 'Open' AND assigned_to IS NULL;

-- Q3: Escalate non-High Heatmap Tracker tickets
SELECT * FROM support_tickets WHERE product_name = 'Heatmap Tracker' AND priority != 'High';

UPDATE support_tickets
SET priority = 'High'
WHERE product_name = 'Heatmap Tracker' AND priority != 'High';

-- Q4: Remove cancelled tickets
SELECT * FROM support_tickets WHERE status = 'Cancelled';

DELETE FROM support_tickets WHERE status = 'Cancelled';

-- Q5: Truncate staging table
TRUNCATE TABLE staging_daily_metrics;
-- TRUNCATE is faster than DELETE because it does not scan rows individually
-- or log each deletion. It deallocates the data pages in one operation.

-- Q6: Drop legacy tables
DROP TABLE legacy_ticket_categories;
DROP TABLE legacy_pricing_v1;
-- DROP removes the entire table structure and data permanently.
-- TRUNCATE keeps the table structure but removes all rows.
