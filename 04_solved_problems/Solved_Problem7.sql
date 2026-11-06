/*
	Task: 
		Retrieve the OrderID, CustomerID, OrderDate, and ShippedDate for all orders placed in calendar year 1997 
		where the shipment took strictly more than 7 days to ship after being ordered (ShippedDate - OrderDate > 7).
		Exclude orders that have not shipped yet (ShippedDate IS NOT NULL).
*/

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	ShippedDate,
	DATEDIFF(DAY, OrderDate, ShippedDate) Shippment_Days
FROM Orders
WHERE YEAR(OrderDate) = 1997 
	AND DATEDIFF(DAY, OrderDate, ShippedDate)  > 7 
	AND ShippedDate IS NOT NULL;

/*
	Task: 
		Identify suppliers that provide at least 3 active (non-discontinued) products.
		Return the SupplierID and the average unit price of those products rounded to 2 decimal places,
		but only include suppliers whose average product unit price is greater than $20.00.
		Order the result by average unit price descending.
*/

SELECT *
FROM Products;

SELECT 
	SupplierID,
	ROUND(AVG(UnitPrice), 2)  [Average Unit Price]
FROM Products
GROUP BY SupplierID
HAVING AVG(UnitPrice) > 20 AND COUNT(*) >= 3
ORDER BY AVG(UnitPrice) DESC

/*
	Task:
		Write a query to list every customer (CustomerID, CompanyName) alongside their total number of orders placed.
		Ensure customers who have never placed an order are included with an order count of 0 (not 1 or NULL).
*/

SELECT 
	c.CustomerID,
	c.CompanyName,
	COALESCE(COUNT(o.OrderID),0) Total_Orders
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName

/*
	Task: 
		In the Employees table, each employee reports to another employee (ReportsTo references EmployeeID). 
		Write a query that returns the employee’s full name (FirstName + ' ' + LastName), their job title, 
		and the full name and title of the manager they report to. 
		Include top-level managers who do not report to anyone.
*/

SELECT 
	*
FROM Employees e

SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS Employee_FullName,
	e.Title As Employee_Title,
	CONCAT(m.FirstName, ' ', m.LastName) AS Manager_FullName,
	m.Title AS Manager_Title
FROM Employees e
LEFT JOIN Employees m
ON e.ReportsTo = m.EmployeeID

/*
	Task: 
		Retrieve a distinct list of countries where Northwind has registered Customers, but has no Suppliers.
		Do not use NOT IN or NOT EXISTS—use a SQL Set Operator.
*/

SELECT DISTINCT Country
FROM Customers

EXCEPT

SELECT Country
FROM Suppliers

/*
	Task: 
		For each category (CategoryID), find the top 2 most expensive products in the Products table.
		Return CategoryID, ProductID, ProductName, UnitPrice, and their price rank within the category.
		If products tie for the same price, they should share the rank without skipping the next rank number.
*/

SELECT * 
FROM(
	SELECT 
		CategoryID,
		ProductID,
		ProductName,
		UnitPrice,
		DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) ProductRank
	FROM Products
) AS ProductRankTable
WHERE ProductRank <= 2

/*
	Task:
		Calculate a running cumulative total of Freight charges by OrderDate across all orders in the Orders table. 
		Return OrderID, CustomerID, OrderDate, Freight, and a column named RunningFreightTotal,
		showing the progressive sum ordered chronologically by OrderDate and OrderID.
*/

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	Freight,
	SUM(Freight) OVER(ORDER BY OrderDate, OrderID) RunningFreightTotal
FROM Orders

/*
	Task: 
		Write a query against the Suppliers table to find all suppliers who currently do not have any products listed under the 'Beverages' category (CategoryID = 1).
		Use a correlated subquery with NOT EXISTS.
*/

SELECT 
	s.SupplierID,
	s.CompanyName,
	s.Country
FROM Suppliers s
WHERE NOT EXISTS (
	SELECT 1
	FROM Products p
	WHERE s.SupplierID = p.SupplierID 
		AND p.CategoryID = 1);

/*
	Task: 
		Write a query against the Suppliers table to find all suppliers who currently have  products listed under the 'Beverages' category (CategoryID = 1).
		Use a correlated subquery with EXISTS.
*/

SELECT
	s.SupplierID,
	s.CompanyName,
	s.Country
FROM Suppliers s
WHERE EXISTS (
	SELECT 1
	FROM Products p
	WHERE  p.SupplierID = s.SupplierID 
		AND p.CategoryID = 1
)

/*
Task: 
	For all records in the Employees table, display:
	-Full name formatted as "LastName, FirstName"
	-Age when hired (in completed years, using BirthDate and HireDate)
	-Location formatted as "City, [Region], Country"—if Region is NULL, replace it with 'N/A'
*/

SELECT 
	CONCAT(LastName,', ', FirstName) Employee_FullName,
	DATEDIFF(YEAR, BirthDate, HireDate) Employee_Age,
	CONCAT(City, ', ', COALESCE(Region, 'N/A'), ', ', Country) Employee_Address
FROM Employees

/*
	Task: 
		Retrieve the ProductID, ProductName, CategoryID, and UnitPrice from the Products table for all products 
		whose unit price is strictly greater than the average unit price of products belonging to the same CategoryID.
*/

SELECT 
	ProductID,
	ProductName,
	CategoryID,
	UnitPrice
FROM Products
WHERE UNITPRICE > (
	SELECT 
		AVG(UnitPrice)
	FROM Products	)

/*
	Task:
	Retrieve CustomerID and CompanyName from the Customers table for customers, 
	who have placed at least one order with a Freight cost exceeding $500.00.
	Write this using a correlated subquery with WHERE EXISTS pointing to the Orders table.
*/

SELECT
	CustomerID,
	CompanyName
FROM Customers c
WHERE EXISTS ( 
			SELECT 1 
			FROM Orders o
			WHERE c.CustomerID = o.CustomerID
			AND Freight >= 500	
);