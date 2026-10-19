-- Calculate the average score for each country. Return only the countries where the average score is strictly greater than 400.

SELECT country, AVG(score)
FROM customers
GROUP BY country
HAVING AVG(score) > 400
