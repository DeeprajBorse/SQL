-- Write a query using GROUP BY and HAVING to find countries whose average score is higher than the average score of Germany. (Hint: You will need a subquery inside your HAVING clause).

SELECT 
	country,
	AVG(score)
FROM customers
GROUP BY country
HAVING AVG(score) > (
	SELECT AVG(score)
	FROM customers
	WHERE country = 'Germany'
);