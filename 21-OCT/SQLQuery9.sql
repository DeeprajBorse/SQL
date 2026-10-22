-- FULL JOIN

SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id