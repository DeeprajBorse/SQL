-- Write a query that displays all columns, along with a new column called country_rank that ranks players by their score highest to lowest within their own country.


SELECT 
    id,
    first_name,
    country,
    score,
    DENSE_RANK() OVER(PARTITION BY country ORDER BY score DESC) AS country_rank
FROM customers;

-- Write a query that displays all columns, along with a new column called country_rank that ranks players by their score LOWEST to HIGHEST within their own country.

SELECT 
	*,
	DENSE_RANK() OVER (PARTITION BY country ORDER BY score ASC ) AS country_rank
FROM customers