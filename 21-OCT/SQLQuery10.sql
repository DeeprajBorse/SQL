-- LEFT ANTI JOIN
-- ONLY ROWS OF TABLE A AND NO MATCHING RECORD BETWEEN TABLE A&B
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

-- Right ANTI JOIN
-- ONLY ROWS OF TABLE B AND NO MATCHING RECORD BETWEEN TABLE A&B

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

-- ALTERNATE WAY
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL