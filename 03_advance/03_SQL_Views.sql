/*
	NOTE: AS THERE COULD BE ONE VIEW QUERIED IN ONE SINGLE QUERY SO IF USING THIS UNCOMENT THE SPECIFIC QUERY YOU WANT TO TEST 
*/

/*
	VIEWS: 
		It is a virtual table based on the result set of a query withing storing the data on database
		Its basically the abstraction between me and the real data. 

	TASK:
		Create a view named V_CustomerOrderSummary that displays every customer's customerid, full name, country, total number of orders placed, and total sales spent (defaulting to 0 for customers with no orders).
*/


CREATE VIEW Sales.V_V_CustomerOrderSummary AS
(
SELECT DISTINCT
	c.CustomerID,
	COALESCE(c.FirstName, '')+ ' ' + COALESCE(c.LastName, '') full_name,
	c.Country,
	SUM(COALESCE(o.OrderID,0))total_orders_placed,
	SUM(COALESCE(o.Sales,0))  total_sales
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY 
	c.CustomerID,
	COALESCE(c.FirstName, '')+ ' ' + COALESCE(c.LastName, '') ,
	c.Country
);
GO

/*
FOR DELETING THE SAME VIEW USE THIS :
*/
DROP VIEW Sales.V_V_CustomerOrderSummary
GO

/*
	TASK:
		Create a security-focused view named V_PublicEmployeeDirectory that exposes only employeeid, firstname, lastname, department, and gender from
		the employees table while hiding sensitive fields (birthdate and salary), then query the view to list all employees in the 'Sales' department.
*/


CREATE VIEW Sales.V_PublicEmployeeDirectory AS
(
SELECT 
	EmployeeID,
	FirstName,
	LastName,
	Department,
	Gender
FROM Sales.Employees
);
GO

SELECT *
FROM Sales.V_PublicEmployeeDirectory
WHERE Department = 'Sales';
GO


/*
	TASK: 
		Create a view named v_PendingFulfillment that joins orders, customers, and products to show orderid, orderdate, customer full name, product, quantity, sales, and shipaddress strictly for orders where orderstatus is 'Shipped' and shipaddress is not NULL,
		then query the view to list the customers without shipaddress.
*/


CREATE VIEW Sales.V_PendingFulfillment AS(
SELECT 
	o.OrderID,
	o.OrderDate,
	COALESCE(c.FirstName,'')+ ' '+ COALESCE(c.LastName,'') Customer_Name,
	p.Product,
	o.Quantity,
	o.Sales,
	o.ShipAddress
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products p
ON o.ProductID = P.ProductID
WHERE o.OrderStatus = 'Shipped'
);
GO

SELECT *
FROM Sales.V_PendingFulfillment
WHERE ShipAddress IS NULL;
GO


/*
	TASK:
		Create a unified view named V_AllOrdersHistory that combines all order records from both orders (labeled with a 'Current' source column) 
		and orders_archive (labeled with an 'Archive' source column), then write a query against the view to find total revenue by year.
*/


CREATE VIEW Sales.V_AllOrderHistory AS
(
SELECT 
	OrderID,
	OrderDate,
	Sales,
	'Curret' AS Source
FROM Sales.Orders

UNION ALL

SELECT
	OrderID,
	OrderDate,
	Sales,
	'Archive' AS Source
FROM Sales.OrdersArchive
);
GO

SELECT 
	YEAR(OrderDate) OrderYear,
	SUM(Sales) total_Revenue_by_year
FROM Sales.V_AllOrderHistory
GROUP BY YEAR(OrderDate)
ORDER BY SUM(Sales);
GO

/*
	TASK:
		Update an existing view vw_CustomerOrderSummary (using CREATE OR REPLACE VIEW or ALTER VIEW) to include each customer's score and a calculated customer_tier column ('VIP' for total sales of 100 or more, 'Standard' otherwise), and demonstrate dropping the view afterward.
*/

IF OBJECT_ID('Sales.V_V_CustomerOrderSummary', 'V') IS NOT NULL
	DROP VIEW Sales.V_V_CustomerOrderSummary;
GO

CREATE VIEW V_V_CustomerOrderSummary AS
(
SELECT 
	*,
	CASE 
		WHEN total_sales >= 100 THEN 'VIP'
		ELSE 'Standard'
	END AS CustomerTier
FROM (
SELECT DISTINCT
	c.CustomerID,
	COALESCE(c.FirstName, '')+ ' ' + COALESCE(c.LastName, '') full_name,
	c.Country,
	SUM(COALESCE(o.OrderID,0))total_orders_placed,
	SUM(COALESCE(o.Sales,0))  total_sales
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY 
	c.CustomerID,
	COALESCE(c.FirstName, '')+ ' ' + COALESCE(c.LastName, '') ,
	c.Country
)t
)
GO
