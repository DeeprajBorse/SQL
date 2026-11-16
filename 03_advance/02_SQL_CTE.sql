/* 
   SQL Common Table Expressions (CTEs)
*/


-- Step1: Find the total Sales Per Customer (Standalone CTE)
WITH CTE_SalesPerCustomer AS
(
SELECT
	c.CustomerID,
	COALESCE(SUM(o.Sales), 0) total_sales
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
)
-- Step2: Find the last order date for each customer (Standalone CTE)
, CTE_LastOrderDate AS
(
SELECT 
	CustomerID,
	MAX(OrderDate) Last_Order_date
FROM Sales.Orders
GROUP BY CustomerID
)
-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)
, CTE_Customer_Rank AS
(
SELECT 
	CustomerID,
	total_sales,
	RANK() OVER(ORDER BY total_sales DESC) CustomersRank
FROM CTE_SalesPerCustomer
)

-- Step4: segment customers based on their total sales (Nested CTE)
, CTE_Customer_Seggment AS
(
SELECT
	CustomerID,
	total_sales,
	CASE
		WHEN total_sales > 100 THEN 'High'
		WHEN total_sales >80 THEN 'Medium'
		ELSE 'Low'
	END AS CustomerTier
FROM CTE_SalesPerCustomer	
)
-- Main Query
SELECT 
	c.CustomerID,
	CONCAT(c.FirstName,' ',c.LastName) CustomerName,
	csc.total_sales,
	cld.Last_Order_date,
	ccr.CustomersRank,
	ccs.CustomerTier
FROM Sales.Customers c
LEFT JOIN CTE_SalesPerCustomer csc
ON c.CustomerID = csc.CustomerID
LEFT JOIN CTE_LastOrderDate cld
ON cld.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Seggment ccs
ON ccs.CustomerID = c.CustomerID
ORDER BY ccr.CustomersRank ASC
/* ==============================================================================
   RECURSIVE CTE | GENERATE SEQUENCE
===============================================================================*/

/* TASK 2:
   Generate a sequence of numbers from 1 to 20.
*/

WITH Series AS
(
SELECT 
	1 AS MyNumber
UNION ALL
SELECT
	MyNumber + 1
FROM Series
WHERE MyNumber < 20
)
SELECT *
FROM Series;

/* TASK 3:
   Generate a sequence of numbers from 1 to 1000.
*/
WITH Series AS
(
SELECT 
	1 AS MyNumber
UNION ALL
SELECT
	MyNumber + 1
FROM Series
WHERE MyNumber < 1000
)
SELECT *
FROM Series
OPTION (MAXRECURSION 5000);


/* 
   RECURSIVE CTE | BUILD HIERARCHY
*/

/* TASK 4:
   Build the employee hierarchy by displaying each employee's level within the organization.
   - Anchor Query: Select employees with no manager.
   - Recursive Query: Select subordinates and increment the level.
*/

WITH CTE_Employee_Hirerarchy AS
(
SELECT 
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Level + 1
FROM Sales.Employees e
INNER JOIN CTE_Employee_Hirerarchy ceh
ON ceh.EmployeeID = e.ManagerID
)
SELECT *
FROM CTE_Employee_Hirerarchy