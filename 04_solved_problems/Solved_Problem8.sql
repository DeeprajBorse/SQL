/*
	Task: Build a query that analyzes monthly revenue per customer for orders placed in 1997.
	- Use a CTE to aggregate total net revenue (UnitPrice * Quantity * (1 - Discount)) grouped by CustomerID and
	order month (formatted as 'yyyy-MM' using FORMAT or CONVERT).
	- In the outer query, use LAG() partitioned by CustomerID and ordered chronologically to retrieve the previous month's revenue.
	- Calculate the Month-over-Month dollar difference, and add a row-level CASE label ('Growth', 'Decline', or 'First Order Month'). 
	Only display rows where the current month's revenue exceeded $1,500.00.
*/



WITH CTE_total_net_revenue AS
(
	SELECT 
		o.CustomerID,
		EOMONTH(o.OrderDate) order_month,
		ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) total_net_revenue
	FROM [Order Details] od
	LEFT JOIN Orders o
	ON o.OrderID = od.OrderID
	GROUP BY o.CustomerID, EOMONTH(o.OrderDate)
)

SELECT 
	CustomerID,
	order_month,
	CONCAT('$', COALESCE(current_month_revenue, 0)),
	CONCAT('$', COALESCE(previous_month_revenue, 0)),
	CONCAT('$', COALESCE(MoM_Change, 0)),
	CASE	
		WHEN previous_month_revenue > current_month_revenue THEN 'Decline'
		WHEN previous_month_revenue < current_month_revenue THEN 'Growth'
		ELSE 'First Order Month'
	END AS [Revenue Status By Month]
FROM(
	SELECT 
		CustomerID,
		FORMAT(order_month, 'yyyy-MMM' ) AS order_month,
		total_net_revenue AS current_month_revenue,
		LAG(total_net_revenue) OVER(PARTITION BY CustomerID ORDER BY order_month) previous_month_revenue,
		total_net_revenue - LAG(total_net_revenue) OVER(PARTITION BY CustomerID ORDER BY order_month) MoM_Change
	FROM CTE_total_net_revenue
	WHERE YEAR(order_month) = 1997
)t
WHERE current_month_revenue > 1500.00;