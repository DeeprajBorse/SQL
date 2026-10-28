-- Window Functions

-- WINDOW BASICS
-- SYNTAX : 
	-- Eg: AVG(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING )

-- Calculate the Total Sales Across All Orders 

SELECT 
	SUM(Sales) totalSales
FROM Sales.Orders

-- Calculate the Total Sales for Each Product 

SELECT 
	ProductID,
	SUM(Sales)  totalSales
FROM Sales.Orders
GROUP BY ProductID

-----------------------------------------------------

-- WINDOW FUNCTIONS | OVER CLAUSE

-- Find the total sales across all orders,
-- additionally providing details such as OrderID and OrderDate 

SELECT 
	OrderID,
	OrderDate,
	SUM(Sales) OVER() AS totalSales
FROM Sales.Orders

-- WINDOW FUNCTION | PARTITION CLAUSE

-- Find the total sales across all orders and for each product,
-- additionally providing details such as OrderID and OrderDate 

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS totalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS totalSalesbyProduct
FROM Sales.Orders

/* Find the total sales across all orders, for each product,
   and for each combination of product and order status,
   additionally providing details such as OrderID and OrderDate */

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER() totalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS SalesByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders

-- SQL WINDOW FUNCTIONS | ORDER CLAUSE

-- Rank each order by Sales from highest to lowest 
SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS salesRank
FROM Sales.Orders

-- SQL WINDOW FUNCTIONS | FRAME CLAUSE

-- Calculate Total Sales by Order Status for current and next two orders 

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER(
			PARTITION BY OrderStatus
			ORDER BY OrderDate
			ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
			) AS TotalSales
FROM Sales.Orders

-- Calculate Total Sales by Order Status for current and previous two orders 

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
			PARTITION BY OrderStatus
			ORDER BY OrderDate
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			) AS TotalSales
FROM Sales.Orders

-- Calculate Total Sales by Order Status from previous two orders only 

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS 2 PRECEDING
		) AS TotalSales
FROM Sales.Orders

-- Calculate cumulative Total Sales by Order Status up to the current order 
 
 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS TotalSales
 FROM Sales.Orders

 -- Calculate cumulative Total Sales by Order Status from the start to the current row 

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS  UNBOUNDED PRECEDING
		) AS TotalSales
 FROM Sales.Orders

 -- Calculate cumulative Total Sales by Order Status from the Current row to the next 2 row 

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
		) AS TotalSales
 FROM Sales.Orders

 -- Calculate cumulative Total Sales by Order Status from the Current row to the Last

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(
		PARTITION BY OrderStatus
		ORDER BY OrderDate
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
		) AS TotalSales
 FROM Sales.Orders

 ----------------------------------------------------------
 -- SQL WINDOW FUNCTIONS | RULES

 -- RULE 1:  Window functions can only be used in SELECT or ORDER BY clauses 

 SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate) AS Total_Sales
 FROM Sales.Orders
 /* NOTE: Though in the upper condition i havent use Frame Clause Still WE ARE SEEING THE RESULT AS ALIKE,
		  FRAME: ' ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ' Because Its Default Frame 
		  i.e. IF WE ARE USING ORDER BY AND NOT USING ANY FRAME THEN THE RESULT IS DISPLAYED ASPER THE DEFAULT FRAME 
*/
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ) AS Total_Sales
FROM Sales.Orders
-- WHERE SUM(Sales) OVER( PARTITION BY OrderStatus )  > 100   - Invalid: window function in WHERE clause
ORDER BY SUM(Sales) OVER( PARTITION BY OrderStatus)


-- RULE 2: Window functions cannot be nested 

SELECT 
	OrderID,
	OrderDate,
 	OrderStatus,
	Sales,
	SUM( SUM(Sales) OVER(PARTITION BY OrderStatus)) OVER(PARTITION BY OrderStatus) AS TotalSales
	-- THIS IS INVALID THIS THING WILL DEFINITELY GIVE AN ERROR
FROM Sales.Orders

--  SQL WINDOW FUNCTIONS | GROUP BY

--  Rank customers by their total sales 

SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS CustomerRank
FROM Sales.Orders
GROUP BY CustomerID