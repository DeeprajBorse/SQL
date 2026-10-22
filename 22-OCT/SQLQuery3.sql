/*
Write a query to fetch all orders from the orders table where:
# sales is between 20 and 60 (inclusive), AND
# orderstatus is not 'Delivered', AND
# shipaddress is not NULL.
*/

SELECT * FROM Sales.Orders

SELECT * 
FROM Sales.Orders AS o
WHERE
	o.Sales BETWEEN 20 AND 60 
	AND
	o.OrderStatus != 'Delivered' 
	AND
	o.ShipAddress IS NOT NULL


-- Find all customers from the customers table whose lastname starts with the letter 'S' or who have a score that is currently NULL. Display their customerid, firstname, lastname, and score.

SELECT * FROM Sales.Customers

SELECT 
	c.CustomerID,
	c.FirstName AS CustomersFirstName,
	c.LastName As CustomersLastNmae,
	c.Score
FROM Sales.Customers AS c
WHERE c.LastName LIKE 'S%' OR score IS NULL

-- Write a query that displays each category from the products table, the total number of products in that category, and the average price of products in that category. Filter the results using HAVING to only show categories where the average price is greater than 15.

SELECT * FROM Sales.Products

SELECT 
	p.Category,
	COUNT(p.ProductID) AS NoofProducts,
	AVG(p.Price) AS AveragePrice
FROM Sales.Products AS p
GROUP BY p.Category
HAVING AVG(p.Price) > 15

DELETE FROM Sales.Products
WHERE ProductID = 106
