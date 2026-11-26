/*
   SQL Joins 
*/


/* No Join
	TASK:
		Retrieve all data from customers and orders as separate results 
*/
SELECT *
FROM Sales.Customers --Customer Date
SELECT *
FROM Sales.Orders  -- Orders Data

/* 
	INNER JOIN
		TASK:
		Get all customers along with their orders, but only for customers who have placed an order 
*/

SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- LEFT JOIN
/* Get all customers along with their orders, 
   including those without orders */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- RIGHT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
RIGHT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Alternative to RIGHT JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Orders o
LEFT JOIN Sales.Customers c 
ON c.CustomerID = o.CustomerID

-- FULL JOIN
/* Get all customers and all orders, even if there’s no match */
SELECT
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c
FULL JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

/*
   ADVANCED JOINS
*/

/*LEFT ANTI JOIN
 Get all customers who haven't placed any order 
*/
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

-- RIGHT ANTI JOIN
/* Get all orders without matching customers */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
RIGHT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL

-- Alternative to RIGHT ANTI JOIN using LEFT JOIN
/* Get all orders without matching customers */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Orders o
LEFT JOIN Sales.Customers c 
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL

-- Alternative to INNER JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NOT NULL AND o.OrderID IS NOT NULL

-- FULL ANTI JOIN
/* Find customers without orders and orders without customers */
SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
FULL JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS  NULL AND o.OrderID IS  NULL

-- CROSS JOIN
/* Generate all possible combinations of customers and orders */

SELECT 
	c.CustomerID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	c.Country,
	o.OrderID,
	o.OrderDate
FROM Sales.Customers c 
CROSS JOIN Sales.Orders o;

/* ============================================================================== 
   MULTIPLE TABLE JOINS (4 Tables)
=============================================================================== */

/* Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
   and employee details. For each order, display:
   - Order ID
   - Customer's name
   - Product name
   - Sales amount
   - Product price
   - Salesperson's name */

SELECT 
	o.OrderID,
	COALESCE(c.FirstName,'') +' ' +COALESCE(c.LastName,'') Customer_Name,
	p.Product Product_Name,
	o.Sales,
	p.Price,
	COALESCE(e.FirstName,'') +' ' +COALESCE(e.LastName,'') SalesPerson_Name
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID