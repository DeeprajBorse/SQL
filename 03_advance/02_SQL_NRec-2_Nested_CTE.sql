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

/*
	TASK:
		Find the salesperson who generated the highest total sales revenue,
		and display all orders handled by that specific salesperson along with each order's difference from their personal average order value.
*/

/*
	TASK: 
		Determine which month in 2025 had the highest total sales, and list all customers who placed an order during that peak month.
*/

/*
	TASK:
		Find all employees whose salary is above their department's average salary, 
		and calculate how much total sales revenue those specific high-earning employees have generated.
*/