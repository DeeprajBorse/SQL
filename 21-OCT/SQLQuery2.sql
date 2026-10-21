
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