/*
From the customers table, display:
-- customerid
-- Full name as a single column using CONCAT (replace any NULL last name with 'Unknown')
-- score (if score is NULL, display 0)
-- Alias the columns as full_name and clean_score.
*/

SELECT 
	c.CustomerID,
	CONCAT(c.FirstName, ' ', COALESCE(c.LastName,'unknown')) AS full_name,
	COALESCE(score, 0) AS score
FROM Sales.Customers c

SELECT 
	c.CustomerID,
	CONCAT(c.FirstName, ' ', ISNULL(c.LastName,'unknown')) AS full_name,
	ISNULL(score, 0) AS score
FROM Sales.Customers c

-- Write a query on the employees table to calculate each employee's age in completed years as of today using their birthdate. Display firstname, lastname, birthdate, and their calculated age. Order the results from oldest to youngest.

SELECT 
	e.FirstName,
	COALESCE(e.LastName, '') AS LastName,
	e.BirthDate,
	DATEDIFF(year, e.BirthDate, GETDATE()) AS Age
FROM Sales.Employees e

-- Write a query on the orders table to retrieve the orderid, the day name of the order date (e.g., 'Wednesday'), and the days elapsed between orderdate and shipdate. Filter to only show orders placed on a weekday (Monday through Friday).

SELECT 
	DATENAME(WEEKDAY, OrderDate)
FROM Sales.Orders

SELECT 
	o.OrderID,
	DATENAME(WEEKDAY, o.OrderDate) AS ORDERDAY,
	DATEDIFF(DAY, o.OrderDate, o.ShipDate) AS SHIPDELAY
FROM Sales.Orders o
WHERE DATEPART(dw, OrderDate) NOT IN (1,7)

/*
Calculate the difference between the recorded sales column in orders and the theoretical revenue calculated as 
quantity * price (by joining with products). 
Display:
- orderid
- Recorded sales
- Expected revenue (quantity * price)
- The absolute variance (ABS(sales - (quantity * price)))
*/

SELECT *
FROM Sales.Orders
SELECT *
FROM Sales.Products

SELECT 
	o.OrderID,
	o.Sales AS [RECORDED SALES],
	(o.Quantity * p.Price) AS [EXPECTED REVENUE],
	ABS(o.Sales - (o.Quantity * p.Price)) AS [Absolute Variance]
FROM Sales.Orders o
INNER JOIN Sales.Products p
ON o.ProductID = p.ProductID
ORDER BY o.OrderID

-- Write a query using UNION to find all distinct customer IDs who have placed an order with status 'Delivered' in either the orders table or the orders_archive table.

SELECT DISTINCT *
FROM Sales.Orders o
WHERE o.OrderStatus = 'Delivered'
UNION
SELECT DISTINCT *
FROM Sales.OrdersArchive oa
WHERE oa.OrderStatus = 'Delivered'

-- Since MySQL 8.0 introduced EXCEPT (or historically using NOT IN / LEFT JOIN), write a query to find all productid values that exist in the products table but have never appeared in the orders_archive table.
SELECT *
FROM Sales.OrdersArchive

SELECT 
	p.ProductID
FROM Sales.Products p
LEFT JOIN Sales.OrdersArchive oa
ON p.ProductID = oa.ProductID
WHERE oa.ProductID IS NULL

-- OR

SELECT p.ProductID
From Sales.Products p

EXCEPT

SELECT oa.ProductID
FROM Sales.OrdersArchive oa
