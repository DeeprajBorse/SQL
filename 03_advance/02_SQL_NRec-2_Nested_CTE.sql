/*
	NON-RECURSIVE CTE:

	NESTED CTE: 
		- CTE Inside Another CTE
		- A nested CTE uses the result of another CTE, so it can't run independently
*/

/*
	TASK:
		Find the customers whose total spending in the orders table exceeds the average total spending across all active customers.
*/

WITH CustomerTotalSpend AS 
(
	SELECT 
		CustomerID,
		SUM(Sales) total_spend
	FROM Sales.Orders
	GROUP BY CustomerID
)
, AvgSpend AS
(
	SELECT 
		CustomerID,
		AVG(total_spend) OVER() avg_total_spend
	FROM CustomerTotalSpend	
)
SELECT 
	c.CustomerID,
	CONCAT(FirstName, ' ', LastName) Customers_Name,
	cts.total_spend,
	avg_s.avg_total_spend
FROM Sales.Customers c
LEFT JOIN CustomerTotalSpend cts
	ON c.CustomerID = cts.CustomerID
LEFT JOIN AvgSpend avg_s
	ON c.CustomerID = avg_s.CustomerID
WHERE cts.total_spend > avg_s.avg_total_spend

/*
	TASK: 
		Identify the top-selling product (by total revenue) within each product category,
		and display only those winning products alongside their percentage contribution to their category's total sales.
*/
WITH ProductSales AS
(
	SELECT 
		o.ProductID,
		p.Category,
		p.Product,
		SUM(o.Sales) total_revenue
	FROM Sales.Products p
	LEFT JOIN Sales.Orders o
		ON p.ProductID = o.ProductID
	GROUP BY o.ProductID, p.Product, p.Category
)
, CategoryAnalysis AS 
(
	SELECT
		ProductID,
		SUM(total_revenue) OVER(PARTITION BY Category) category_total,
		RANK() OVER(PARTITION BY Category ORDER BY total_revenue DESC) revenue_rank
	FROM ProductSales
)
SELECT 
	ps.Product,
	ps.Category,
	ps.total_revenue,
	ca.category_total,
	CONCAT(ROUND(CAST((ps.total_revenue * 100) AS FLOAT) / ca.category_total, 2),'%') per_category_sales
FROM CategoryAnalysis ca
LEFT JOIN ProductSales ps
	ON ca.ProductID = ps.ProductID
WHERE ca.revenue_rank = 1

/*
	TASK:
		Find the salesperson who generated the highest total sales revenue,
		and display all orders handled by that specific salesperson along with each order's difference from their personal average order value.
*/

WITH SalesPersonSales AS 
(
SELECT 
	SalesPersonID,
	SUM(Sales) total_sales,
	COUNT(OrderID) orders_handled,
	AVG(Sales) avg_order_value
FROM Sales.Orders
GROUP BY SalesPersonID
)
, TopsalesPerson AS
(
SELECT
	*,
	RANK() OVER(ORDER BY total_sales DESC) sales_rank
FROM SalesPersonSales
)
SELECT 
	e.EmployeeID, 
	CONCAT(e.FirstName,' ', e.LastName) employeeName,
	o.OrderID,
	o.OrderDate,
	o.Sales,
	t.avg_order_value,
	(o.Sales - t.avg_order_value) diff_from_personal_avg
FROM Sales.Orders o
LEFT JOIN Sales.Employees e
	ON e.EmployeeID	= o.SalesPersonID
LEFT JOIN TopsalesPerson t
	ON t.SalesPersonID = o.SalesPersonID
WHERE t.sales_rank = 1

/*
	TASK: 
		Determine which month in 2025 had the highest total sales, and list all customers who placed an order during that peak month.
*/

WITH MonthlySales AS
(
SELECT 
	YEAR(OrderDate) OrderYear,
	MONTH(OrderDate) OrderMonth,
	SUM(Sales)  monthly_sales
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025
GROUP BY
	YEAR(OrderDate), 
	MONTH(OrderDate) 
)
, PeakMonth AS
(
SELECT
	*,
	RANK() OVER(ORDER BY monthly_sales DESC) month_rank
FROM MonthlySales	
)
SELECT DISTINCT
	c.CustomerID,
	CONCAT(c.FirstName, ' ', c.LastName) CustomerName,
	p.OrderMonth,
	p.monthly_sales
FROM Sales.Orders o 
LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
LEFT JOIN PeakMonth p
	ON YEAR(o.orderdate) = OrderYear 
	AND MONTH(o.OrderDate) = p.OrderMonth
WHERE p.month_rank = 1


/*
	TASK:
		Find all employees whose salary is above their department's average salary, 
		and Calculate how much total sales revenue those specific high-earning employees have generated.
*/
WITH EmployeeSalaryDept AS 
(
	SELECT 
		e.EmployeeID,
		CONCAT(e.FirstName, ' ', e.LastName) EmployeeName,
		e.Department,
		e.Salary,
		AVG(Salary) OVER(PARTITION BY Department) dept_avg_Salary
	FROM Sales.Employees e
)
,HighEarning_Emp AS
(
	SELECT 
		*
	FROM EmployeeSalaryDept
	WHERE Salary > dept_avg_Salary 
)
SELECT 
	h.EmployeeID,
	h.EmployeeName,
	h.Department,
	h.Salary,
	h.dept_avg_Salary,
	COALESCE(SUM(o.Sales),0) Sales
FROM HighEarning_Emp h
LEFT JOIN Sales.Orders o
ON h.EmployeeID = o.SalesPersonID
GROUP BY 
	h.EmployeeID,
	h.EmployeeName,
	h.Department,
	h.Salary,
	h.dept_avg_Salary

