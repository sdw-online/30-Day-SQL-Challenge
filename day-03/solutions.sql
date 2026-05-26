-- ============================================
-- DAY 3 SOLUTIONS: ORDER BY & LIMIT
-- ============================================

-- Q1: Unique product categories in alphabetical order
SELECT DISTINCT category
FROM online_orders
ORDER BY category;

-- Q2: Top 10 highest-value orders
SELECT customer_name, product_name, order_amount, region
FROM online_orders
ORDER BY order_amount DESC
LIMIT 10;

-- Q3: Orders from specific regions, amount between 40 and 150
SELECT *
FROM online_orders
WHERE region IN ('London', 'North West', 'West Midlands')
  AND order_amount BETWEEN 40 AND 150
ORDER BY region, order_amount DESC;

-- Q4: Customers with @shopstream.com email
SELECT customer_name, email, product_name, order_amount
FROM online_orders
WHERE email LIKE '%@shopstream.com'
ORDER BY order_amount DESC;

-- Q5: Sportswear orders outside Scotland
SELECT *
FROM online_orders
WHERE category = 'Sportswear'
  AND region != 'Scotland'
ORDER BY order_amount DESC;

-- Q6: Gmail customers in London/Scotland/Wales, amount 30-300, top 10
SELECT *
FROM online_orders
WHERE email LIKE '%@gmail.com'
  AND region IN ('London', 'Scotland', 'Wales')
  AND order_amount BETWEEN 30 AND 300
ORDER BY region, order_amount DESC
LIMIT 10;

-- Q7: Page 2 of results (rows 11-20) sorted by date
SELECT *
FROM online_orders
ORDER BY order_date DESC
LIMIT 10 OFFSET 10;
