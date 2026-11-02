-- INNER JOIN
-- ITS ALIKE ( A INTERSECTION B ) ONLY SHOWS MATCHING ELEMENTS/DATA
-- USECASE: FOR DATA ENRICHMENT

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- LEFT JOIN

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- RIGHT JOIN

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

-- ANOTHER WAY TO DO RIGHT JOIN
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id

-- FULL JOIN

SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

-- PRACTICE


SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id


SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id= c.id
WHERE c.id IS NULL

SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL