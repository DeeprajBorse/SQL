-- Select all rows and sort the data by country in ascending order. If multiple players are from the same country, sort them by score in descending order.

SELECT *
FROM customers
ORDER BY country ASC, score DESC