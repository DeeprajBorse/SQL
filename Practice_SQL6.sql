-- Analyse The Scores In Customer Table

SELECT 
	c.Country,
	COUNT(*) NoOfCustomers,
	SUM(COALESCE(c.Score,0))AS TotalScore,
	AVG(COALESCE(c.Score,0))AS AverageScore,
	MAX(c.Score) AS MaximumScore,
	MIN(c.Score) MinimumScore
FROM Sales.Customers c
GROUP BY c.Country

-- FIND TOTAL SALES ACROSS ALL ORDERS

SELECT 
	SUM(Sales)TotlSales
FROM Sales.Orders

-- FIND TOTAL SALES FOR EACH PRODUCT

SELECT 
	ProductID,
	SUM(Sales)TotlSales
FROM Sales.Orders
GROUP BY ProductID

-- FIND TOTAL SALES ACROSS ALL PRODUCT  ADDITIONALLY PROVIDE DETAILS SUCH AS ORDERID, ORDER DATE
SELECT 
	OrderID,
	OrderDate,
	SUM(Sales) OVER() AS total_sales
FROM Sales.Orders

-- FIND THE TOTAL SALES FOR EACH PRODUCT ADDITIONALLY PROVIDE DETAILS SUCH AS ORDERID, ORDER DATE
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) AS total_Sales
FROM Sales.Orders

-- FIND TOTAL SALES ACROSS ALL ORDERS,
--  FIND THE TOTAL SALES FOR EACH PRODUCT ADDITIONALLY PROVIDE DETAILS SUCH AS ORDERID, ORDER DATE

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() AS totalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS totalSalesBYProduct
FROM Sales.Orders

-- FIND THE TOTAL SALES FOR EACH COMBINATION OFPRODUCT AND ORDER STATUS
-- FIND TOTAL SALES ACROSS ALL ORDERS,
--  FIND THE TOTAL SALES FOR EACH PRODUCT ADDITIONALLY PROVIDE DETAILS SUCH AS ORDERID, ORDER DATE

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER() total_Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS totalsalesByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS SalesByProductAndOrder
FROM Sales.Orders

-- Rank each other based on the sales from the highest to lowest 
-- Additionally provide details orderId, OrderDate

SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders

-- RANK Customers based on their total Score
SELECT 
	CustomerID,
	CONCAT(FirstName, ' ', LastName) AS CustomerName,
	Score,
	RANK() OVER(ORDER BY Score DESC) AS ScoreRank
FROM Sales.Customers 
