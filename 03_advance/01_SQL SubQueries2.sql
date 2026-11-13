/* 
   SQL Subquery Functions
*/


/* TASK 1:
   Find the products that have a price higher than the average price of all products.
*/
SELECT *
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)


/* TASK 2:
   Rank Customers based on their total amount of sales.
*/

SELECT 
	*,
	RANK() OVER(ORDER BY TotalSales DESC) SalesRank
FROM (
	SELECT 
		CustomerID,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t

/*
   SUBQUERY | SELECT
*/

/* TASK 3:
   Show the product IDs, product names, prices, and the total number of orders.
*/

SELECT 
	ProductID,
	Product ProductName,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) Total_Orders
FROM Sales.Products;

/* TASK 4:
   Show customer details along with their total sales.
*/

SELECT 
	*,
	(SELECT SUM(Sales) FROM Sales.Orders o WHERE c.CustomerID = o.CustomerID ) total_sales
FROM Sales.Customers c

/* TASK 5:
   Show all customer details and the total orders of each customer.
*/

SELECT 
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE c.CustomerID = o.CustomerID) [Total Orders]
FROM Sales.Customers c

-- USING: JOIN-SUBQUERY
SELECT 
	c.*,
	o.Total_Orders
FROM Sales.Customers c
LEFT JOIN (SELECT 
				CustomerID,
				COUNT(*) Total_Orders
			FROM Sales.Orders 
			GROUP BY CustomerID) AS o
ON c.CustomerID = o.CustomerID

/*
   SUBQUERY | COMPARISON OPERATORS
*/

/* TASK 6:
   Find the products that have a price higher than the average price of all products.
*/

SELECT *
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

/* 
   SUBQUERY | IN OPERATOR
*/

/* TASK 7:
   Show the details of orders made by customers in Germany.
*/

SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany');

/* TASK 8:
   Show the details of orders made by customers not in Germany.
*/

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	Sales
FROM Sales.Orders
WHERE CustomerID NOT IN (
				SELECT CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany');

/* 
   SUBQUERY | ANY OPERATOR
*/

/* TASK 9:
   Find female employees whose salaries are greater than the salaries of any male employees.
*/

SELECT *
FROM Sales.Employees
WHERE Gender = 'F' 
		AND 
		Salary > ANY(
				SELECT Salary
				FROM Sales.Employees
				WHERE Gender = 'M');

/* 
   CORRELATED SUBQUERY
*/

/* TASK 10:
   Show all customer details and the total orders for each customer using a correlated subquery.
*/

SELECT *,
	 (	SELECT COUNT(*)
		FROM Sales.Orders o
		WHERE c.CustomerID = o.CustomerID) AS Total_Orders
FROM Sales.Customers c


/* 
   SUBQUERY | EXISTS OPERATOR
*/

/* TASK 11:
   Show the details of orders made by customers in Germany.
*/

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	Sales
FROM Sales.Orders o
WHERE EXISTS (	SELECT 1
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND
				c.CustomerID = o.CustomerID) ;

/* TASK 12:
   Show the details of orders made by customers not in Germany.
*/

SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS (	SELECT 1
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND
				c.CustomerID = o.CustomerID)