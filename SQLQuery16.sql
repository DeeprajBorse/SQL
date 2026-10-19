-- Write a query to calculate the average score of each country. However, using a HAVING clause, only return countries that have at least one player whose individual score is over 800.

SELECT 
	country,
	AVG(score) AS average
FROM customers
GROUP BY country 
Having MAX(score) > 800