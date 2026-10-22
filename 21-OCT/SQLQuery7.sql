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