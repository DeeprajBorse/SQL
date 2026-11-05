/*
	Windows Value Function  | USE CASE
	-These functions let you reference and compare values from other rows in a result set without complex joins or subqueries, enabling advanced 
    analysis on ordered data.
*/

/*
	USE CASE | Time Series Analysis
	- It is the process of analysing the data understand the pattern, trends, behaviours over the time
	Eg:  Year over Year Analysis
	TASK :
	Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
	Between the Current and Previous Months
*/

SELECT 
	*,
	CurrentMonthSales - PreviousMonthSales AS MoM_Value,
	ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT) / PreviousMonthSales * 100, 2) AS PercentChange
FROM(
SELECT 
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY MONTH(OrderDate))t

/*
	USE CASE | Time Gap Analysis
	Customer Retention Analysis
	-It measures customer behaviour and loyalty to help business build strong relationship with customers
	TASK :
	In order to analyse customer loyalty, Rank the customers based on the average days between their orders 
*/

SELECT 
	CustomerID,
	AVG(DaysBetweenOrders) Avg_Days_Between_Orders,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysBetweenOrders), 99999)) CustomerRank
FROM(
	SELECT
		CustomerID,
		OrderID,
		OrderDate,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate ) AS NextOrder,
		DATEDIFF(DAY,  OrderDate , LEAD(OrderDate) OVER(PARTITION BY CustomerID 
															ORDER BY OrderDate )) DaysBetweenOrders
	FROM Sales.Orders
) AS CustomerOrders
GROUP BY CustomerID

-- Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales Between the Current and Previous Months

SELECT
	*,
	CurrentMonthSales - PreviousMonthSales MoM_Sales_Value,
	ROUND(
		CAST(CurrentMonthSales - PreviousMonthSales AS FLOAT) 
			/ PreviousMonthSales * 100, 2)  AS MoM_Sales_Percentage
FROM(
SELECT
	MONTH(OrderDate) AS CurrentMonth,
	SUM(Sales)  CurrentMonthSales,
	LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)t

/*
	USE CASE | Comparision Analysis
	How Well a value is performing relative to the extreme - HIGHEST OR LOWEST
	TASK:
	Find the Lowest and Highest Sales for Each Product,
	and determine the difference between the current Sales and the lowest Sales for each Product(Min Deaviation & Max Deviation).
*/

SELECT
	ProductID,
	OrderID,
	OrderDate,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
	MIN(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS MinSales,   -- Another way to do LowestSales
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID 
					ORDER BY Sales
					ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
					) AS HighestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) MaxSales,   -- Another way to do HighestSales
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders
