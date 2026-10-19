-- Write a query to find the details of the player(s) who scored higher than the overall average score of all players in the table.

SELECT * 
FROM customers
WHERE score > (
	SELECT AVG(score) 
	FROM customers
)