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

/*
	Task: Track purchasing cadence for Northwind's VIP customers:

	- Filter Customers using a subquery (WHERE EXISTS) to include only customers who have ordered products from at least 5 distinct categories.
	- Inside a CTE, list all orders for those customers, assign a sequential order number (ROW_NUMBER()) per customer by OrderDate, and use LEAD(OrderDate) to grab the date of their very next order.
	- In the final SELECT, return CustomerID, CompanyName in uppercase (UPPER), OrderID, OrderDate, NextOrderDate, and DaysUntilNextOrder (DATEDIFF), filtering (WHERE) to show only instances where the customer waited more than 60 days between consecutive orders.
*/


WITH CTE_CustomerInfo AS
(
SELECT
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	o.OrderDate current_order_date,
	ROW_NUMBER() OVER(
		PARTITION BY c.CustomerID
		ORDER BY o.OrderDate ASC, o.OrderID ASC) sequential_Order,
	LEAD(o.OrderDate) OVER(
		PARTITION BY c.CustomerID
		ORDER BY o.OrderDate ASC, o.OrderID ASC) next_order_date 
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE EXISTS (
	SELECT 1
	FROM Orders o_sq
	INNER JOIN [Order Details] od
	ON o_sq.OrderID = od.OrderID
	INNER JOIN Products p
	ON od.ProductID = p.ProductID
	WHERE o_sq.CustomerID = c.CustomerID
	GROUP BY o_sq.CustomerID
	HAVING COUNT(DISTINCT p.CategoryID) >= 5
)
) ;
select *
from CTE_CustomerInfo;

WITH CustomerOrderCadence AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY c.CustomerID 
            ORDER BY o.OrderDate ASC, o.OrderID ASC
        ) AS OrderSequence,
        LEAD(o.OrderDate) OVER (
            PARTITION BY c.CustomerID 
            ORDER BY o.OrderDate ASC, o.OrderID ASC
        ) AS NextOrderDate
    FROM Customers c
    INNER JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    WHERE EXISTS (
        SELECT 1
        FROM Orders o_sub
        INNER JOIN [Order Details] od 
            ON o_sub.OrderID = od.OrderID
        INNER JOIN Products p 
            ON od.ProductID = p.ProductID
        WHERE o_sub.CustomerID = c.CustomerID
        GROUP BY o_sub.CustomerID
        HAVING COUNT(DISTINCT p.CategoryID) >= 5
    )
)
SELECT 
    CustomerID,
    UPPER(CompanyName) AS CompanyName,
    OrderID,
    OrderDate,
    NextOrderDate,
    DATEDIFF(day, OrderDate, NextOrderDate) AS DaysUntilNextOrder
FROM CustomerOrderCadence
WHERE DATEDIFF(day, OrderDate, NextOrderDate) > 60
ORDER BY CustomerID, OrderDate;
