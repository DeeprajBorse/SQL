-- SQL CLAUSES

SELECT
country,
SUM(score)
FROM customers
WHERE score > 0
GROUP BY country
HAVING SUM(score) > 400
ORDER BY SUM(score) ASC;


-- SELECT + FROM
SELECT *
FROM customers

-- DISTINCT

SELECT DISTINCT 
	country
FROM customers

-- TOP

SELECT TOP 3 *
FROM customers

-- WHERE CLAUSE
SELECT * 
FROM customers
WHERE first_name LIKE 'M%'

-- GROUP BY + HAVING CLAUSE

SELECT 
	country,
	SUM(score)
FROM customers
GROUP BY country
HAVING SUM(score) > 400

-- ORDER BY CLAUSE

SELECT *
FROM orders
WHERE sales > 15
ORDER BY order_date DESC

