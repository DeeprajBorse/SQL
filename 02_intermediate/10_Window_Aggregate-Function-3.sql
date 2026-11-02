--  SQL Window Aggregate Functions
/* These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.
*/

-- SQL WINDOW AGGREGATION | COUNT

-- TASK 1 : Find the Total Number of Orders and the Total Number of Orders for Each Customer
SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() AS [Total Orders],
	COUNT(*) OVER(PARTITION BY CustomerID) AS [Orders By Customers]
FROM Sales.Orders

/* TASK 2:
   - Find the Total Number of Customers
   - Find the Total Number of Scores for Customers
   - Find the Total Number of Countries
*/

SELECT DISTINCT
	CustomerID,
	FirstName+' '+ COALESCE(LastName,'') AS CustomerName,
	Country,
	Score,
	COUNT(*) OVER() AS totalCustomersSTAR,
	COUNT(1) OVER() AS totalCustomersONE,
	COUNT(Score)  OVER() AS [No of Valid Score],
	COUNT(Country)  OVER() AS totalCountries
FROM Sales.Customers

-- TASK 3: Check whether the table 'OrdersArchive' contains any duplicate rows

SELECT *
FROM(
	SELECT 
		OrderID,
		OrderDate,
		OrderStatus,
		COUNT(*) OVER(PARTITION BY OrderID) CHECK_PK
	FROM Sales.OrdersArchive
)t WHERE CHECK_PK > 1

-- -- SQL WINDOW AGGREGATION | SUM

/* TASK 4:
   - Find the Total Sales Across All Orders 
   - Find the Total Sales for Each Product
*/

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	ProductID,
	SUM(Sales) OVER() Total_Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) Product_Sales
FROM Sales.Orders

-- TASK 5: Find the Percentage Contribution of Each Product's Sales to the Total Sales

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	ProductID,
	SUM(Sales) OVER() AS TotalSales,
	ROUND(CAST(Sales AS float) /SUM(Sales) OVER() * 100, 2) AS [Prod Contribution %]
FROM Sales.Orders

--  SQL WINDOW AGGREGATION | AVG

/* TASK 6:
   - Find the Average Sales Across All Orders 
   - Find the Average Sales for Each Product
*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AS AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgSalesByProduct
FROM Sales.Orders

-- TASK 7: Find the Average Scores of Customers

SELECT 
	*,
	AVG(COALESCE(Score, 0)) OVER() AS AverageScore
FROM Sales.Customers

-- TASK 8: Find all orders where Sales exceed the average Sales across all orders

SELECT *
FROM (
	SELECT
		OrderID,
		OrderStatus,
		Sales,
		AVG(Sales) OVER() AS Average_Sales
	FROM SALES.Orders
	)t 
WHERE Sales > Average_Sales

--  SQL WINDOW AGGREGATION | MAX / MIN

-- TASK 9: Find the Highest and Lowest Sales across all orders

SELECT 
	MIN(Sales) OVER() MinimumSales,
	MAX(Sales) OVER() MaximumSales
FROM Sales.Orders

-- TASK 10: Find the Lowest Sales across all orders and by Product

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	MIN(Sales) OVER() AS LowestSales,
	MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders

-- TASK 11: Show the employees who have the highest salaries

SELECT *
FROM (
	SELECT
		EmployeeID,
		Salary,
		Department,
		MAX(Salary) OVER() AS HighestSalary
	 FROM Sales.Employees
 )t WHERE Salary = HighestSalary

 -- TASK 12: Find the deviation of each Sale from the minimum and maximum Sales

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	MIN(Sales) OVER() AS MinSales,
	MAX(Sales) OVER() AS MaxSales,
	Sales - MIN(Sales) OVER() AS MinDeviation,
	MAX(Sales) OVER() - Sales  AS MaxDeviation
 FROM Sales.Orders

 -- Use Case | ROLLING SUM & AVERAGE

 -- TASK 13: Calculate the moving average of Sales for each Product over time

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AverageSales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS MovingAverage
 FROM Sales.Orders

 -- TASK 14: Calculate the moving average of Sales for each Product over time, including only the next order

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AverageSales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
				ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAVG
FROM Sales.Orders