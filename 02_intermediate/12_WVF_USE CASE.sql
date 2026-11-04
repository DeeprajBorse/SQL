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