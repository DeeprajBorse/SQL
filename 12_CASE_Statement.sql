-- CASE STATEMENTS

SELECT 
	OrderID,
	Sales,
	CASE
		WHEN Sales > 50 THEN 'HIGH'
		WHEN Sales > 25 THEN 'MEDIUM'
		ELSE 'LOW'
	END AS Category
FROM Sales.Orders

-- CASE STATEMENT INTO AGGREGATE FUNCTION
SELECT 
	c.CustomerID,
	COUNT(*) AS total_orders,
	SUM(
	CASE 
		WHEN o.Sales > 30 THEN 1
		ELSE 0
	END	) AS SalesFlag
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY c.CustomerID ASC

-- CASE STAMENT TO HANDLE NULLS 

SELECT 
	c.CustomerID,
	c.Country,
	c.Score,
	AVG(c.Score) OVER() AS AvgScore,
	CASE 
		WHEN c.Score IS NULL THEN 0
		ELSE c.Score
	END AS cleanScore,
	AVG(CASE 
			WHEN c.Score IS NULL THEN 0
			ELSE c.Score
		END	) OVER() AS Avg_CleanScore
FROM Sales.Customers c

-- CASE WHILE MAPPING VALUES

SELECT 
	EmployeeID,
	CONCAT(FirstName, ' ', COALESCE(LastName, '')) AS Customers_name,
	Gender,
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Not Available'
	END AS GenderASText
FROM Sales.Employees