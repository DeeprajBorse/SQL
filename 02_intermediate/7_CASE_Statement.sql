-- CASE STATEMENTS
-- CASE STATEMENTS ARE AS SAME AS IF, ELSE IF, ELSE STATEMENT
-- HERE OUT OF ALL THE CONDITIONS ANY ONE CONDITION IS TRUE

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

/*
Write a query on the customers table to classify each customer's loyalty tier based on their score:
-If score is greater than or equal to 800, label as 'High Priority'.
-If score is between 500 and 799 inclusive, label as 'Medium Priority'.
-If score is less than 500 and not NULL, label as 'Low Priority'.
-If score is NULL, label as 'Unrated'.
-Display customerid, firstname, lastname, score, and the calculated column aliased as customer_tier.
*/

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Score,
	CASE
		WHEN score >= 800 THEN 'High Priority'
		WHEN score BETWEEN 500 AND 799 THEN 'Medium Priority'
		WHEN score < 500 AND score IS NOT NULL THEN 'Low Priority'
		ELSE 'Unrated'
	END AS customer_tier
FROM Sales.Customers

/*
Write a query on the orders table to produce a department-wide delivery status breakdown for each salesperson (salespersonid).
Display:
-salespersonid
-Total count of orders with status 'Delivered' (aliased as delivered_count)
-Total count of orders with status 'Shipped' (aliased as shipped_count)
-Total revenue (SUM(sales)) generated only from 'Delivered' orders (aliased as delivered_revenue, displaying 0 if none)
*/

SELECT *
FROM Sales.Orders

SELECT
	o.SalesPersonID,
	COUNT(
		CASE
			WHEN o.OrderStatus = 'Delivered' THEN 1
		END) AS  delivered_count,
	COUNT(
		CASE
			WHEN o.OrderStatus = 'Shipped' THEN 1
		END	) AS shipped_count,
	SUM(
		CASE	
			WHEN o.OrderStatus = 'Delivered' THEN o.Sales
		END	) AS delivered_revenue
FROM Sales.Orders o
GROUP BY o.SalesPersonID
ORDER BY o.SalesPersonID