-- Write a query that displays the first_name, country, and a column showing the cumulative (running) sum of scores for players within each country, ordered alphabetically by their name.



SELECT 
	first_name,
	country,
	SUM(score) OVER ( ORDER BY first_name ASC ) AS cumulative_sum
FROM customers;