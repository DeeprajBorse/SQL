-- Without using LIMIT or TOP, write a query to find the second highest score in the entire table.

SELECT MAX(score) AS second_highest
FROM customers
WHERE score < (
	SELECT MAX(	score )
	FROM customers
);

--Without using LIMIT or TOP, write a query to find the second LOWEST score in the entire table.

SELECT MIN(score) as second_lowest
FROM customers
WHERE score > (
	SELECT MIN(score) 
	FROM customers) ;