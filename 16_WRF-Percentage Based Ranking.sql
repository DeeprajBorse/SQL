-- PERCENTAGE BASED RANKING

/*
CUME_DIST() 
- CUMMULATIVE DISTRIBUTION CALCULATES THE DATA POINTS WITHIN THE WINDOW 

FROMULA = CURRENT ROW / TOTAL ROWS  

TIE BREAKER RULE : IF THERE ARE SIMILAR VALUES THEN WE WILL TAKE THE LAST POSITION OF SAME VALUE.
*/

-- PERFORM THE FUNCTION FOR ALL PRODUCT SALES
SELECT *,
	CONCAT(CumulativeValue * 100 , '%') AS CumulativePercentage
FROM (
	SELECT 
		OrderID,
		OrderDate,
		OrderStatus,
		Sales,
		CUME_DIST() OVER(ORDER BY Sales DESC) AS CumulativeValue
	FROM Sales.Orders
	)t
			
-- PERFORM THE FUNCTION FOR INDIVIDUAL PRODUCT SALES

SELECT *,
	CONCAT(CumulativeValue * 100 , '%') CumulativePercentage
FROM(
	SELECT 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		ROUND(CUME_DIST() OVER(PARTITION BY ProductID ORDER BY Sales), 2) CumulativeValue
	FROM Sales.Orders
)t

-- USE ORDERSARCHIVE TABLE

SELECT *,
	CONCAT(RelativePosition * 100, '%') RelativePercentage,
	CONCAT(RelativeProductPosition * 100, '%') RelativePercentageProduct
FROM (
	SELECT 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		CUME_DIST() OVER(ORDER BY Sales DESC) RelativePosition,
		ROUND(CUME_DIST() OVER(PARTITION BY ProductID ORDER BY Sales DESC),2)  RelativeProductPosition 
	FROM Sales.OrdersArchive
)t

/*
PERCENT_RANK() 
- IT CALCULATES THE RELATIVE RANK (PERCENTILE) OF A ROW WITHIN A PARTITION OR RESULT SET, RETURN VALUE BETWEEN 0 AND 1 INCLUSIVE.

TIE RULE : THE POSITION OF FIRST OCCURENCE OF THE SAME VALUE

FORMULA : (POSITION NUMBER - 1) / (NO OF ROWS - 1)
*/

-- RESULT FOR ALL
SELECT *,
	Percent_Rank * 10 PERCENTILE
FROM (
	SELECT 
		OrderID,
		OrderDate,
		OrderStatus,
		Sales,
		ROUND(PERCENT_RANK() OVER(ORDER BY Sales ), 3) Percent_Rank
	FROM Sales.Orders
)t
ORDER BY PERCENTILE DESC

-- RESULT AS PER PRODUCT

SELECT *,
	Percent_Rank *10 Percentile
FROM (
	SELECT
		OrderID,
		OrderDate,
		Sales,
		ProductID,
		ROUND(PERCENT_RANK() OVER(PARTITION BY ProductID ORDER BY Sales), 3) Percent_Rank
	FROM Sales.Orders
)t

-- USE ORDERSARCHIVE TABLE
-- OVER ALL RESULT
SELECT *,
	RelativeRank * 10  Percentile
FROM (
	SELECT 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		ROUND(PERCENT_RANK() OVER(ORDER BY Sales DESC), 2) RelativeRank
	FROM Sales.OrdersArchive
)t
ORDER BY Percentile DESC

-- RESULT BY PRODUCT

SELECT *,
	RelativeProductRank * 10 PercentileProduct
FROM (
	SELECT 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		ROUND(PERCENT_RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC),2)  RelativeProductRank 
	FROM Sales.OrdersArchive
)t

-- GET THE HIGHEST PERCENTILE OF THE CUSTOMERS BY THEIR SCORE FROM  HIGHEST TO LOWEST

SELECT *,
	Percent_Rank * 10 Percentile
FROM(
SELECT
	CustomerID,
	FirstName + ' '+ COALESCE(LastName, '') [Customer Name],
	COALESCE(Score,0) Score,
	PERCENT_RANK() OVER(ORDER BY Score) Percent_Rank
FROM Sales.Customers
)t
ORDER BY Percentile DESC