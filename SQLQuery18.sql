-- Display all columns, but add a new column called dense_country_rank. It must rank players by their score highest to lowest within their own country, but if there's a tie, the next rank number must not be skipped.

SELECT 
	*,
	DENSE_RANK() OVER( PARTITION BY country ORDER BY score DESC) AS dense_country_rank
FROM customers

