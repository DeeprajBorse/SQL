-- Retrieve all columns, but order the results so that players from USA appear first. For all other countries, sort them alphabetically by country ( A - Z ).

SELECT *
FROM customers
ORDER BY 
	CASE 
		WHEN country = 'USA' THEN 0 ELSE 1
	END,
	country ASC;