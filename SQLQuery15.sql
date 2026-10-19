-- Write a query to find countries where the maximum score is at least 500 AND the minimum score is strictly greater than 0. Return the country name and its total number of players.

SELECT
	country,
	COUNT(id) AS total_players 
FROM customers
GROUP BY country
HAVING MAX(score) <= 500 AND MIN(score) > 0