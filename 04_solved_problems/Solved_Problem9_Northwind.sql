/*
	Task: 
		- Identify employees whose average order processing time is faster (lower) than the overall company average.

		- Return EmployeeID, full name (FirstName + ' ' + LastName), total shipped orders handled, 
		and their average days to ship (AVG(CAST(DATEDIFF(DAY, OrderDate, ShippedDate) AS DECIMAL(5,2)))).
		- Filter out unshipped orders (ShippedDate IS NOT NULL), and use HAVING to restrict results to employees who have shipped at least 40 orders 
		AND whose average shipping days are strictly less than a scalar subquery computing the company-wide average shipping days across all orders.
*/

SELECT 
	e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) full_name,
	COUNT(o.OrderID) Orders_Handled,
	AVG(CAST(DATEDIFF(Day, o.OrderDate, o.ShippedDate) AS DECIMAL(5,2))) Avg_days_to_ship 
FROM Employees e
LEFT JOIN Orders o
ON e.EmployeeID = o.EmployeeID
WHERE o.ShippedDate IS NOT NULL
GROUP BY 
	e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName)
HAVING COUNT(o.OrderID) >= 40 
	AND AVG(CAST(DATEDIFF(Day, o.OrderDate, o.ShippedDate) AS DECIMAL(5,2))) <  (
		SELECT 
			AVG(CAST(DATEDIFF(Day, o.OrderDate, o.ShippedDate) AS DECIMAL(5,2)))
		FROM Orders o);
GO



/*
	Task: Identify suppliers whose total on-hand inventory value is significantly higher than their regional average.
*/

WITH SuppliedStockSummary AS 
(
	SELECT 
		s.SupplierID,
		s.CompanyName,
		COALESCE(s.Region, 'Global') Region,
		COUNT(p.ProductID) Supplied_Prdoucts,
		SUM(p.UnitPrice * p.UnitsInStock) total_inventory_value
	FROM Suppliers s 
	LEFT JOIN Products p
	ON s.SupplierID = p.SupplierID
	GROUP BY 
		s.SupplierID,
		s.CompanyName,
		COALESCE(s.Region, 'Global')
),
AVGInventoryValue AS 
(
	SELECT 
		*,
		ROUND(AVG(total_inventory_value) OVER(PARTITION BY Region), 2) avg_inventory_value_by_region
	FROM SuppliedStockSummary
)
SELECT 
	*
FROM AVGInventoryValue 
WHERE total_inventory_value > 1.5 * avg_inventory_value_by_region
ORDER BY total_inventory_value DESC;
GO

/*
	Task: 
		Create a database View named vw_CategoryProductPerformance that summarizes active (Discontinued = 0) products and their sales contribution within their category:

	- Join Categories, Products, and [Order Details] to compute total units sold and total net revenue per product.
	- Use a window aggregate (SUM(...) OVER (PARTITION BY CategoryName)) to calculate the overall revenue for each product's entire category.
	- Display each product's percentage contribution to its category's total revenue formatted as a string with a '%' sign (e.g., '14.25%'), alongside its revenue rank (RANK()) within that category.
*/

CREATE VIEW  vw_CategoryProductPerformance AS
WITH ProductSales AS 
(
SELECT 
	c.CategoryName,
	p.ProductID,
	p.ProductName,
	COALESCE(SUM(od.Quantity), 2) total_units_sold,
	ROUND(COALESCE(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),0),2) ProductRevenue
FROM Products p
INNER JOIN  Categories c
ON p.CategoryID = c.CategoryID
LEFT JOIN [Order Details] od
ON p.ProductID = od.ProductID
WHERE p.Discontinued = 0
GROUP BY 
	c.CategoryName,
	p.ProductID,
	p.ProductName
)
SELECT 
	CategoryName,
	ProductID,
	ProductName,
	total_units_sold,
	ProductRevenue,
	SUM(ProductRevenue) OVER(PARTITION BY CategoryName) CategoryTotalRevenue,
	CONCAT(
		ROUND(ProductRevenue * 100.00 / 
			COALESCE(SUM(ProductRevenue) OVER(PARTITION BY CategoryName), 0),
			2), 
	'%' ) CategorySharePer,
	RANK() OVER(PARTITION BY CategoryName ORDER BY ProductRevenue DESC) CategoryRevenueRank
FROM ProductSales; 
GO