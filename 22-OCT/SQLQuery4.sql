/*
Write a query to retrieve every order from orders. Display:
# orderid
# orderdate
# Product name (product)
# Customer's first and last name concatenated or displayed as separate columns
# Total sales amount
*/

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Products

SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product AS ProductName,
	CONCAT(c.FirstName, ' ', c.LastName) AS customer_name, 
	p.price	as totalamount
FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID

-- Write a query using a LEFT JOIN between customers and orders to find all customers who have never placed an order in the orders table. Display their customerid, firstname, and country.

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Customers

SELECT 
	c.CustomerID,
	c.FirstName,
	c.Country
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

-- Retrieve the orderid, orderstatus, customer's country, and the salesperson's lastname for all orders placed in the month of February 2025 (orderdate >= '2025-02-01' AND orderdate <= '2025-02-28').

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Employees

SELECT 
	o.OrderID,
	o.OrderStatus,
	c.Country AS Customers_Country,
	e.LastName AS SalesPerson_LastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID 
-- WHERE o.OrderDate BETWEEN '2025-02-01' AND '2025-02-28'
WHERE o.OrderDate >= '2025-02-01' AND o.OrderDate <= '2025-02-28'
