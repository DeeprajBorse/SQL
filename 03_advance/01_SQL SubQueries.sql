/*
		SQL SUBQUERY FUNCTION
		SUBQUERY - It's a Query Inside Query

		TYPES : 
		[1] DEPENDENCY
				|-------- NON-CORRELATED SUBQUERY : Independent of Main Query
				|________ CORRELATED SUBQUERY : Dependent On Main Query

		[2] RESULT TYPE: 
				|-------- SCALAR SUBQUERY : It Has Single Row And Single Column As an Output
				|-------- ROW SUBQUERY :  It Has Single Column and Multiple Rows As an Output
				|________ TABLE SUBQUERY : It Has Multiple Column And Multiple Rows As an Output

		[3] LOACTION / CLAUSE: 
				|-------- SELECT 
				|-------- FROM 
				|-------- JOIN
				|________ WHERE 
							|------- COMPARISION OPERATOR
							|_______ LOGICAL OPERATOR 
*/

-- RESULT TYPE

/* Scalar Query: Returns One Single Value */
SELECT 
	AVG(Sales) AS AverageSales
FROM  Sales.Orders

/* Row Query: Returns Multiple Rows and Single Column*/
SELECT 
	CONCAT(FirstName, ' ',COALESCE(LastName,'')) AS CustomerName
FROM Sales.Customers

/* Table Query: Returns Multiple Rows and Columns*/
SELECT *
FROM Sales.Employees

-------------------------------------------------------------------------

-- LOCATION / CLAUSE

/* 
	SUBQUERY - FROM CLAUSE : It is Used to use a Temporary Table for the Main Query 
	TASK:
	Find the Product That has Price Value higher then the Average Prive Of all products
*/

-- Main Query
SELECT *
FROM(
	-- Sub Query
	SELECT
		ProductID,
		Product,
		Price,
		AVG(Price) OVER() AveragePrice
	FROM Sales.Products
) AS AvgPrice
WHERE Price > AveragePrice

/*
	TASK:
	Get the Top 2 Customer having highest total Sales Amount
*/

SELECT 
	*	
FROM(
	SELECT 
		CustomerID,
		SUM(Sales)  totalSales,
		RANK() OVER(ORDER BY SUM(Sales) DESC) AS CustomerRank
	FROM Sales.Orders
	GROUP BY CustomerID
)  TotalSales
WHERE CustomerRank <= 2


/*
	SUBQUERY - SELECT CLAUSE : It is used to aggregate data side by side with the main query data allowing for direct Comparision.

	RULE: The Result of the SubQuery Must be a Sigle Value
		  i.e. Only Scalar Subqueries are allowed to be used for SELECT

	TASK:
	Show the product IDs, product names, prices, and the total number of orders.
*/
SELECT 
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM SALES.Products

/*
	TASK: 
		Show the CustomerID, Customer Full Name, Country and Number od Orders Placed By Each Customer
		(Its Correlative SubQuery)
*/

SELECT 
	CustomerID,
	CONCAT(FirstName, ' ', LastName ) FullName,
	Country,
	(SELECT COUNT(*) FROM SALES.Orders o WHERE c.CustomerID = o.CustomerID) AS TotalOrders
FROM Sales.Customers c

/*
	SUBQUERY - JOIN CLAUSE:
			It is Used To Prepare a data [Filtering or Aggregating] before joining it to another Table.
	
	Business Goal: Operations wants to evaluate high-volume products without using window functions or multi-step temp tables.

	Task: 
		Write a query that joins the products table to an aggregated subquery derived from orders.
		The subquery should calculate the total_units_sold and order_count for each productid.
		the outer query, join products to this derived table on productid.
		Display productid, product, category, price, total_units_sold, and order_count.
		Filter to only return products that have sold more than 3 units in total.
*/

SELECT 
	p.ProductID,
	p.Product,
	p.Category,
	p.Price,
	o.Total_Units_Sold,
	o.Order_Count
FROM Sales.Products p
INNER JOIN  (
		SELECT 
			o.ProductID,
			SUM(o.Quantity) Total_Units_Sold,
			COUNT(*) Order_Count
		FROM Sales.Orders o
		GROUP BY o.ProductID) o
ON p.ProductID = o.ProductID
WHERE o.Total_Units_Sold > 3

/*
	Business Goal: 
		Marketing wants to see all customers alongside details of orders that were specifically fulfilled successfully 
		('Delivered'). 
		If a customer has no delivered orders, their information must still appear with NULL order fields.

	Task:
		Write a query that performs a LEFT JOIN between customers and a subquery of orders.
		The subquery must filter orders for rows where orderstatus is Delivered before joining.
		Display customerid, Customer FullName, orderid, orderdate, and sales.
		Sort the output by customerid ASC, orderdate DESC.
*/

SELECT 
	c.CustomerID,
	CONCAT(c.FirstName,' ', c.LastName) AS Customer_Name,
	o.OrderID,
	o.OrderDate,
	o.Sales
FROM Sales.Customers c
LEFT JOIN (
	SELECT *
	FROM Sales.Orders
	WHERE OrderStatus = 'Delivered') o
ON c.CustomerID = o.CustomerID
ORDER BY CustomerID ASC, OrderDate DESC

/*
	SUBQUERY- WHERE CLAUSE
		- Used for complex filtering logic and makes query ore flexible and dynamic 
		- We Use this Clause in order to do Dynamic Filtering into Main Clause
	# COMPARISION OPERATOR :
		Used to Compare the Data Using 2 Values

	RULE: Only Scalar SubQuery could be used while using Comparision Operator

	TASK:
		Find the products that have price higher than the average price of all products 
*/

SELECT *,
	(SELECT AVG(Price) FROM Sales.Products) AveragePrice
FROM Sales.Products
WHERE Price > (
		SELECT AVG(Price) FROM Sales.Products)

/*
	Business Scenario: 
		The HR and operations team wants to identify high-earning individual contributors within each department without comparing across different divisions.

	Task:
		Write a query on the employees table to find all employees whose salary is greater than or equal to the average salary of their own specific department.

	Display Columns: employeeid, Employee Full Name, Department salary
*/

SELECT *
FROM Sales.Employees

SELECT 
	e.EmployeeID,
	e.FirstName + ' ' + COALESCE(LastName, '') [Employee Name],
	e.Department,
	e.Salary
FROM Sales.Employees e
WHERE Salary >= (
		SELECT AVG(Salary)
		FROM Sales.Employees e1
		WHERE e.Department = e1.Department)

/*
	IN OPERATOR:
		Checks whether a Value matches any value from a list 

	Business Scenario: Marketing is running a loyalty campaign targeted at high-value regions.

	Task: 
		Write a query on the orders table to retrieve all orders placed by customers residing in 'USA'.
		Columns to Display: orderid, customerid, orderdate, sales		
*/

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	Sales
FROM Sales.Orders
WHERE CustomerID IN (
		SELECT 
			CustomerID
		FROM Sales.Customers c
		WHERE c.Country = 'USA' ) 
ORDER BY OrderDate ASC

/*
	Business Scenario: Inventory management needs to identify catalog items that have had zero demand in active sales.

	Task: 
		Write a query on the products table to find all products that have never been ordered in the orders table.
		Columns to Display: productid, product, category, price
*/

SELECT *
FROM Sales.Products p
WHERE ProductID NOT IN (
		SELECT	ProductID
		FROM Sales.Orders o
		WHERE p.ProductID = o.ProductID)

/*
	Business Scenario: HR is reviewing marketing department compensation benchmarks against sales reps.

	Task:
		Find all employees in the 'Marketing' department who earn more than at least one employee in the 'Sales' department.
		Columns to Display: employeeid, firstname, lastname, salary
*/

SELECT 
	EmployeeID,
	FirstName,
	LastName,
	Salary
FROM Sales.Employees
WHERE Department = 'Marketing' 
	AND Salary > ANY (
			SELECT 
				Salary
			FROM Sales.Employees
			WHERE Department = 'Sales')

/*
	Business Scenario: Operations is auditing bulk transactions.
	Task: 
		Retrieve all records from orders where the quantity ordered matches any quantity that was ordered by customer ID 1 in the orders table.
		Columns to Display: orderid, customerid, productid, quantity, sales
*/

SELECT 
	OrderId,
	CustomerID,
	ProductID,
	Quantity,
	Sales
FROM Sales.Orders
WHERE Quantity = ANY(
		SELECT Quantity
		FROM Sales.Orders
		WHERE CustomerID = 1)

/*
	ALL OPERATOR: 
		Check if a Value Matches all Values Within a List

	Business Scenario: Finance wants to highlight single large transactions that outperform an entire low-value category.

	Task: 
		Find all orders in the orders table whose sales amount is greater than every single individual product price in the 'Accessories' category.
		Columns to Display: orderid, productid, sales
*/

SELECT 
	OrderID,
	ProductID,
	Sales
FROM Sales.Orders
WHERE Sales > ALL(
		SELECT Price
		FROM Sales.Products
		WHERE Category = 'Accessories')
ORDER BY OrderDate ASC

/*
	Business Scenario: HR wants to identify cross-department compensation floors.

	Task: 
		Find all employees whose salary is strictly greater than all salaries paid in the 'Marketing' department.
		Columns to Display: employeeid, firstname, lastname, department, salary
*/

SELECT 
	EmployeeID,
	FirstName,
	COALESCE(LastName,'') LastName,
	Department,
	Salary
FROM Sales.Employees
WHERE Salary > ALL(
		SELECT Salary
		FROM Sales.Employees
		WHERE Department = 'Marketing')


/*
	Business Scenario: Sales performance check on account executives.
	
	Task: 
		Retrieve all employees from the employees table who have handled at least one order with a status of 'Delivered'.
		Columns to Display: employeeid, firstname, lastname, department
*/

SELECT 
	EmployeeID,
	CONCAT(FirstName,' ', LastName) Employee_Name,
	Department
FROM Sales.Employees e
WHERE EXISTS (
		SELECT *
		FROM Sales.Orders o
		WHERE OrderStatus = 'Delivered'
		AND e.EmployeeID = o.SalesPersonID)
		AND 
		EXISTS (
		SELECT 1
		FROM Sales.Orders o
		WHERE OrderStatus = 'Delivered'
		AND e.EmployeeID = o.SalesPersonID)	

/*
	Business Scenario: Customer onboarding retention analysis.

	Task: 
		Find all customers from the customers table who have never placed an order in the active orders table.
		Columns to Display: customerid, firstname, lastname, country
*/

SELECT *
FROM Sales.Customers c
WHERE NOT EXISTS (
		SELECT 1
		FROM Sales.Orders o
		WHERE o.CustomerID = c.CustomerID);

/*
	Business Scenario: Identifying long-term recurring customers.

	Task: 
		Find all customers who have placed at least one order recorded in the active orders table 
		AND also have at least one past order recorded in the orders_archive table.
		Columns to Display: customerid, firstname, lastname
*/
SELECT 
	CustomerID,
	COALESCE(FirstName,'') FirstName,
	COALESCE(LastName,'') LastName
FROM Sales.Customers c
WHERE EXISTS (
		SELECT 1
		FROM Sales.Orders o 
		WHERE o.CustomerID = c.CustomerID)
		AND 
		EXISTS (
		SELECT 1
		FROM Sales.OrdersArchive oa
		WHERE c.CustomerID = oa.CustomerID);

/*
	Business Scenario: Product catalog fulfillment audit.

	Task: 
		Find all products in the products table that have never been fulfilled with an orderstatus of 'Delivered' 
		in either the current orders or past orders_archive tables.
		Columns to Display: productid, product, category
*/		

SELECT 
	ProductID,
	Product,
	Category
FROM Sales.Products p
WHERE NOT EXISTS (
		SELECT 1
		FROM Sales.Orders o
		WHERE p.ProductID = o.ProductID AND o.OrderStatus = 'Delivered')
		AND
		NOT EXISTS (
		SELECT 1 
		FROM  Sales.OrdersArchive oa
		WHERE p.ProductID = oa.ProductID AND oa.OrderStatus = 'Delivered');
