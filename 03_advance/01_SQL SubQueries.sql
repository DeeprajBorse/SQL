/*
		SQL SUBQUERY FUNCTION
		SUBQUERY - It's a Query Inside Query

		TYPES : 
		[1] DEPENDENCY
				|-------- NON-CORRELATED SUBQUERY : Independent of Main Query
				|________ CORRELATED SUBQUERY : Dependent On Main Query

		[2] RESULT TYPE: 
				|-------- SCALAR SUBQUERY : It Has Single Row And Single Column As an Output
				|-------- ROW SUBQUERY :  It Has Single Column and Multiple Rows As an Output
				|________ TABLE SUBQUERY : It Has Multiple Column And Multiple Rows As an Output

		[3] LOACTION / CLAUSE: 
				|-------- SELECT 
				|-------- FROM 
				|-------- JOIN
				|________ WHERE 
							|------- COMPARISION OPERATOR
							|_______ LOGICAL OPERATOR
*/

-- RESULT TYPE

/* Scalar Query: Returns One Single Value */
SELECT 
	AVG(Sales) AS AverageSales
FROM  Sales.Orders

/* Row Query: Returns Multiple Rows and Single Column*/
SELECT 
	CONCAT(FirstName, ' ',COALESCE(LastName,'')) AS CustomerName
FROM Sales.Customers

/* Table Query: Returns Multiple Rows and Columns*/
SELECT *
FROM Sales.Employees

-------------------------------------------------------------------------

-- LOCATION / CLAUSE

/* 
	SUBQUERY - FROM CLAUSE : It is Used to use a Temporary Table for the Main Query 
	TASK:
	Find the Product That has Price Value higher then the Average Prive Of all products
*/

-- Main Query
SELECT *
FROM(
	-- Sub Query
	SELECT
		ProductID,
		Product,
		Price,
		AVG(Price) OVER() AveragePrice
	FROM Sales.Products
) AS AvgPrice
WHERE Price > AveragePrice

/*
	TASK:
	Get the Top 2 Customer having highest total Sales Amount
*/

SELECT 
	*	
FROM(
	SELECT 
		CustomerID,
		SUM(Sales)  totalSales,
		RANK() OVER(ORDER BY SUM(Sales) DESC) AS CustomerRank
	FROM Sales.Orders
	GROUP BY CustomerID
)  TotalSales
WHERE CustomerRank <= 2


/*
	SELECT CLAUSE : It is used to aggregate data side by side with the main query data allowing for direct Comparision.

	RULE: The Result of the SubQuery Must be a Sigle Value
		  i.e. Only Scalar Subqueries are allowed to be used for SELECT

	TASK:
	Show the product IDs, product names, prices, and the total number of orders.
*/
SELECT 
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM SALES.Products

