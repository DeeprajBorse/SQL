SELECT
country,
SUM(score)
FROM customers
WHERE score > 0
GROUP BY country
HAVING SUM(score) > 400
ORDER BY SUM(score) ASC;

SELECT *
FROM customers