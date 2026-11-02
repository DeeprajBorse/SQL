-- WINDOWS VALUE FUNCTIONS

-- Business Use Cases: Customer repeat purchase analysis, Salesperson performance trend, Customer loyalty ranking, Fulfillment tracking
-- Functions: LEAD, LAG, FIRST_VALUE, LAST_VALUE with framing

/*
LEAD() - Access a Value from the Next Row Within a Window. 
Syntax : LEAD(Expression, offset, default) OVER(ORDER BY)
Here in the Syntax Expression, ORDER BY will be required and rest clauses would be optional 
DEFAULT: offset: 1 | default: NULL
*/

-- FIND THE NEXT POSSIBLE SALES VALUE FOR ORDERS TABLE  

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	LEAD(Sales) OVER(ORDER BY Sales DESC) NextSales
FROM Sales.Orders

/*
Write a query on the orders table to track how frequently individual customers make purchases.
For each order, display:
-customerid
-orderid
-orderdate
-The date of the customer's subsequent order.
-The number of days elapsed between the current order and the next order.
*/

SELECT *,
	DATEDIFF(DAY, OrderDate, next_order_date) days_until_next_order
FROM (
	SELECT 
		CustomerID,
		OrderID,
		OrderDate,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderID) next_order_date
	FROM Sales.Orders
)t

/*
Write a query on the orders table to look two steps ahead in the fulfillment sequence.
Display:
-orderid
-orderdate
-shipdate
-productid
-The productid of the order placed two orders after the current one, If no order exists two places ahead, return -1 as the default value.
-Order the overall sequence by orderdate ASC, orderid ASC.
*/

SELECT 
    OrderID, 
    OrderDate, 
    ShipDate, 
    ProductID, 
    LEAD(ProductID, 2, -1) OVER (
        ORDER BY OrderDate ASC, OrderID ASC
    ) AS product_after_next
FROM Sales.Orders
ORDER BY OrderDate ASC, OrderID ASC;


/*
LAG() - ACCESS A VALUE FROM THE PREVIOUS ROW WTHIN A WINDOW
SYNTAX : LAG(expression, offset, default) OVER(ORDER BY) - HERE Expression and ORDER BY Clause is Manditory Rest is Optional
DEFAULT: offset: 1 | default: NULL
*/

-- Write a query to generate previous customers score in new table.

SELECT 
	CustomerID,
	CONCAT(UPPER(FirstName), ' ', LOWER(LastName)) CustomerName,
	COALESCE(Score,0) Score,
	LAG(Score,1,0) OVER(Order BY CustomerID ASC) PreviousCustomerScore
FROM Sales.Customers

/*
Write a query on the orders table to analyze chronological ordering behavior.
Order the records by orderdate ascending (and orderid ascending as a tiebreaker).
Display:
-orderid
-orderdate
-sales
-The sales amount of the immediately preceding order , aliased as previous_order_sales. For the very first order, display 0 instead of NULL using the function's default value parameter.
-The difference between the current order's sales and the previous order's sales (sales - previous_order_sales), aliased as sales_difference.
*/

SELECT 
	OrderID,
	OrderDate,
	Sales,
	LAG(Sales,1,0) OVER(ORDER BY OrderDate) previous_order_sales,
	(Sales - LAG(Sales,1,0) OVER(ORDER BY OrderDate)) sales_difference
FROM Sales.Orders
ORDER BY OrderID

/*
Write a query joining employees and orders to evaluate the order-by-order sales trend for each salesperson individually.
Display:
-employeeid
-Salesperson full name as salesperson_name
-orderid
-orderdate
-sales
-The preceding order's sales value for that specific salesperson using LAG(), aliased as prev_sales.
-A calculated flag column named performance_trend using a CASE statement:
	-If current sales is greater than prev_sales, label 'Increased'.
	-If current sales is less than prev_sales, label 'Decreased'.
	-If current sales equals prev_sales, label 'Equal'.
	-If there is no previous order (prev_sales is NULL), label 'First Sale'.
*/

SELECT 
	*,
	CASE
		WHEN Sales > prev_sales THEN 'Increased'
		WHEN Sales < prev_sales THEN 'Decreased'
		WHEN Sales = prev_sales THEN 'Equal'
		ELSE 'First Sale'
	END performance_trend
FROM(
	SELECT
		e.EmployeeID,
		CONCAT(e.FirstName, ' ', e.LastName) salesperson_name,
		o.OrderID,
		o.OrderDate,
		o.Sales,
		LAG(Sales, 1, 0) OVER(PARTITION BY e.EmployeeID ORDER BY o.OrderDate ) prev_sales
	FROM Sales.Employees e
	LEFT JOIN Sales.Orders o
	ON e.EmployeeID = o.SalesPersonID
)t

/*
	In order to analyze customer loyalty Rank the Customers based on the average days between their orders.
*/

SELECT 
	CustomerID,
	AVG(days_between_orders) average_days,
	RANK() OVER(ORDER BY COALESCE(AVG(days_between_orders), 999999) ASC) Customer_Loyalty_Rank
FROM(
	SELECT
		OrderID,
		Sales,
		CustomerID,
		OrderDate,
		LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) previous_order_date,
		ABS(DATEDIFF(DAY, OrderDate, LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY CustomerID))) days_between_orders
	FROM Sales.Orders
)t
GROUP BY CustomerID

/*
FIRST_VALUE() - ACCESS A VALUE FROM THE FIRST ROW WITHIN THE WINDOW 
SYNTAX : FIRST_VALUE(Expression) OVER(ORDER BY + DEFAULT FRAME)
HERE Expression and ORDER BY CLAUSE Is Mandatory WRT Default FRAME
*/

-- WRITE A QUERY TO GET 1ST VALUE WRT TO SALES

SELECT
	OrderID,
	OrderDate,
	Sales,
	FIRST_VALUE(Sales) OVER(ORDER BY Sales) First_Value
FROM Sales.Orders

/*
Business Context: The marketing team wants to analyze customer lifetime value by comparing every subsequent order a customer makes 
				  back to the value of their very first (baseline) purchase.

Task: Write a query on the orders table. For every order, display:
-customerid
-orderid
-orderdate
-sales
-The sales amount of the customer's initial (first ever) order , aliased as first_order_sales.
-The difference between the current order's sales and their first order's sales, aliased as sales_growth_since_first_order.
*/

SELECT 
	CustomerID,
	OrderID,
	OrderDate,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate) first_order_Sales,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC,OrderID ASC) sales_growth_since_first_order
FROM Sales.Orders

/*
LAST_VALUE() - ACCESS THE VALUE FROM LAST ROW WITHIN A WINDOW 
- HERE WE NEED TO CUSTOMISE THE FRAME IN ORDER TO GET DESIRED OUTPUT
SYNTAX: LAST_FRAME(Expression) OVER(ORDER BY ....... ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
*/

-- WRITE A QUERY TO GET LAST VALUE WRT TO SALES

SELECT 
	OrderID,
	OrderDate,
	Sales,
	LAST_VALUE(Sales) OVER(ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER(ORDER BY Sales DESC) HighestSales_F_V,
	MAX(Sales) OVER(ORDER BY Sales DESC) MaxSales
FROM Sales.Orders -- HERE THERE ARE 3 WAYS TO DO THIS QUERY

/*
Business Context: Sales leadership wants to display each employee's most recent order date alongside every order they fulfilled, to quickly spot inactive sales reps.

Task: Write a query on the orders table. For each order, display:
salespersonid
orderid
orderdate
The date of the salesperson's most recent (latest) order using LAST_VALUE(), aliased as latest_order_date.
Requirements:
Partition by salespersonid and sort by orderdate ASC, orderid ASC.
*/

SELECT
	SalesPersonID,
	OrderID,
	OrderDate,
	LAST_VALUE(OrderDate) OVER(PARTITION BY SalesPersonID
		ORDER BY OrderDate ASC, OrderID ASC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) latest_order_date
FROM Sales.Orders

/*
Business Context: Merchandising wants to see the cheapest and most expensive product in each category side-by-side with every product on the catalog.
Task: Write a query on the products table displaying:
-productid
-category
-product
-price
-The name of the cheapest product in that category using FIRST_VALUE(), aliased as lowest_priced_product.
-The name of the most expensive product in that category using LAST_VALUE(), aliased as highest_priced_product.
*/

SELECT
	ProductID,
	Category,
	Product,
	Price,
	FIRST_VALUE(Product) OVER(PARTITION BY Category ORDER BY Price, ProductID) lowest_priced_product,
	LAST_VALUE(Product) OVER(PARTITION BY Category 
			ORDER BY  Price, ProductID
			ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_priced_product
FROM Sales.Products

/*
Business Context: Operations wants to track fulfillment cycle duration for each customer across 2025.

Task: Write a query on the orders table (filtering out records where shipdate is NULL) displaying:
-customerid
-orderid
-shipdate
-The date of the customer's earliest shipment using FIRST_VALUE(), aliased as earliest_ship_date.
-The date of the customer's final shipment using LAST_VALUE(), aliased as final_ship_date.
-The total number of days elapsed between that customer's earliest shipment and final shipment using DATEDIFF(), aliased as customer_fulfillment_span_days.
*/

SELECT *,
	DATEDIFF(DAY, earliest_ship_date, final_ship_date) customer_fulfillment_span_days
FROM (
	SELECT
		CustomerID,
		OrderID,
		ShipDate,
		FIRST_VALUE(ShipDate) OVER(PARTITION BY CustomerID ORDER BY ShipDate) earliest_ship_date,
		LAST_VALUE(ShipDate) OVER(PARTITION BY CustomerID 
				ORDER BY ShipDate
				ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) final_ship_date
	FROM Sales.Orders
)t