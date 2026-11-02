-- SQL Window Ranking Functions - USE CASE

-- TASK 1: Rank Orders Based on Sales from Highest to Lowest

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) row_salesRank,
	RANK() OVER(ORDER BY Sales DESC) range_salesRank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) dense_salesRank  
FROM Sales.Orders

/* 
	Use Case | Top-N Analysis:
	TASK: Find the Highest Sale for Each Product
*/

SELECT*
FROM (
	SELECT 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS Rank_by_Product
	FROM Sales.Orders
) t
WHERE Rank_by_Product = 1

/* 
	Use Case | Bottom-N Analysis: 
	TASK: Find the Lowest 2 Customers Based on Their Total Sales
*/

SELECT 
	*
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) totalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) SalesRank
	FROM Sales.Orders
	GROUP BY CustomerID
)t
WHERE SalesRank <= 2


/*
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
*/

SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID) UniqueID,
	*
FROM Sales.OrdersArchive

/* 
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates
*/

SELECT *
FROM(
	SELECT
		Row_Number() OVER(PARTITION BY OrderID ORDER BY OrderID) Check_Duplicate,
		*
	FROM Sales.OrdersArchive
)t
WHERE Check_Duplicate = 1


-- NTILE
/*
	USE CASE | DATA SEGMENTATION : Dividing a dataset into distinct subsets based on certain Criteria.
	TASK : Segment all Orders into 3 Categories: High, Medium, and Low Sales.
*/

SELECT 
	OrderID,
	Sales,
	Buckets,
	CASE	
		WHEN Buckets = 1 THEN 'High'
		WHEN Buckets = 2 THEN 'Medium'
		WHEN Buckets = 3 THEN 'Low'
	END
FROM (
SELECT 
	OrderID,
	OrderDate,
	Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) Buckets
FROM Sales.Orders
)t