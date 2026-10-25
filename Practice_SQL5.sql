-- Find all customerid values that appear in both the orders table and the orders_archive table using either the INTERSECT operator or an INNER JOIN / IN subquery structure.

SELECT 
	c.CustomerID
FROM Sales.Customers c
INTERSECT 
SELECT	
	o.CustomerID
FROM Sales.Orders o
INTERSECT
SELECT 
	oa.CustomerID
FROM Sales.OrdersArchive oa

-- USING INNER JOIN

SELECT DISTINCT
	o.CustomerID
FROM  Sales.Orders o
INNER JOIN Sales.OrdersArchive oa
ON o.CustomerID = oa.CustomerID

-- Using SUBQUERY

SELECT DISTINCT o.CustomerID
FROM Sales.Orders o
WHERE CustomerID IN (
	SELECT oa.CustomerID
	FROM Sales.OrdersArchive oa
)

/*
Write a query using a SELF JOIN on employees to find all pairs of employees who work in the same department, where Employee A was hired/born before Employee B.
- Avoid matching an employee with themselves.
- Avoid duplicate reverse pairs (e.g., show (A, B) but not (B, A)).
*/

SELECT *
FROM Sales.Employees

SELECT DISTINCT
	a.EmployeeID AS [EmployeeA ID],
	a.FirstName AS [EmployeeA Name],
	b.EmployeeID AS [EmployeeB ID],
	b.FirstName AS [EmployeeB Name],
	a.Department,
	a.FirstName+', '+b.FirstName+' - ' + a.Department [PAIR - DEPT]
FROM Sales.Employees a
INNER JOIN Sales.Employees b
ON a.Department = b.Department
AND DATEDIFF(YEAR, a.BirthDate, GETDATE()) > DATEDIFF(YEAR, b.BirthDate, GETDATE())

/*
Write a query that displays each product category along with:
-The total quantity of items sold from the orders table
-The total sales revenue generated
-Filter using HAVING to show only categories where total sales revenue exceeds 100.
*/

SELECT 
	p.Category,
	SUM(o.Quantity) AS [Total Items Sold],
	SUM(o.Quantity * p.Price) AS [Sales Revenue]
FROM Sales.Products p
INNER JOIN Sales.Orders o
ON p.ProductID = o.ProductID
GROUP BY p.Category
HAVING SUM(o.Quantity * p.Price) > 100

/*
Generate a sales performance report for all employees.
-Join employees to orders.
-Display employeeid, firstname, lastname, and the total sales amount.
-For employees who have made no sales, display 0 instead of NULL using a NULL handling function.
-Sort the results by total sales in descending order.
*/
SELECT *
FROM Sales.Orders

SELECT 
	e.EmployeeID,
	e.FirstName,
	COALESCE(e.LastName, ''),
	COALESCE(SUM(o.Quantity * o.Sales), 0) AS total_sales
FROM Sales.Employees e
LEFT JOIN Sales.Orders o
ON e.EmployeeID = o.SalesPersonID
GROUP BY 
	e.EmployeeID,
	e.FirstName,
	e.LastName
ORDER BY total_sales DESC

/*
Retrieve the orderid, customer's country, product product, and salesperson's department for every order in orders where:
-The customer is located in 'USA'
-The product belongs to the 'Clothing' category
-The order status is 'Delivered'
*/
SELECT 
	o.OrderID,
	c.Country AS customers_country,
	p.Product,
	e.Department AS salespersons_department
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID
WHERE c.Country = 'USA' AND p.Category = 'Clothing' AND o.OrderStatus = 'Delivered'
