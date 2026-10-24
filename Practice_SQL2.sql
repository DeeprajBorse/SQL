-- Write an ALTER TABLE statement to add a new column named email of type VARCHAR(100) to the customers table. Ensure that each customer's email must be distinct across all rows.

SELECT * FROM Sales.Customers

ALTER TABLE Sales.Customers
ADD email VARCHAR(100) 

CREATE UNIQUE NONCLUSTERED INDEX UQ_customer_email
ON Sales.Customers (email)
WHERE email IS NOT NULL

Update Sales.Customers
SET email = 'Anna@example.com'
WHERE CustomerID = 5

/*
Insert a new product into the products table with:
ID: 106, Product name: 'Helmet', Category: 'Accessories', Price: 45
*/

SELECT * FROM Sales.Products

INSERT INTO Sales.Products(ProductID, Product, Category, Price)
Values (106, 'Helmet', 'Accessories', 45) 

-- Write a query to update the salary in the employees table by giving a $5,000 raise to all employees who currently report to manager ID 1 (Frank Lee).

SELECT * FROM Sales.Employees

UPDATE Sales.Employees
SET Salary = Salary + 5000
WHERE ManagerID = 1

-- Write a statement to delete all records from orders_archive where the orderstatus is 'Shipped' and the billaddress is either NULL or an empty string ('').

SELECT * FROM Sales.OrdersArchive

DELETE FROM Sales.OrdersArchive
WHERE OrderStatus = 'Shipped' OR BillAddress = NULL OR BillAddress = ''

/*
Write a query to fetch all orders from the orders table where:
# sales is between 20 and 60 (inclusive), AND
# orderstatus is not 'Delivered', AND
# shipaddress is not NULL.
*/

SELECT * FROM Sales.Orders

SELECT * 
FROM Sales.Orders AS o
WHERE
	o.Sales BETWEEN 20 AND 60 
	AND
	o.OrderStatus != 'Delivered' 
	AND
	o.ShipAddress IS NOT NULL


-- Find all customers from the customers table whose lastname starts with the letter 'S' or who have a score that is currently NULL. Display their customerid, firstname, lastname, and score.

SELECT * FROM Sales.Customers

SELECT 
	c.CustomerID,
	c.FirstName AS CustomersFirstName,
	c.LastName As CustomersLastNmae,
	c.Score
FROM Sales.Customers AS c
WHERE c.LastName LIKE 'S%' OR score IS NULL

-- Write a query that displays each category from the products table, the total number of products in that category, and the average price of products in that category. Filter the results using HAVING to only show categories where the average price is greater than 15.

SELECT * FROM Sales.Products

SELECT 
	p.Category,
	COUNT(p.ProductID) AS NoofProducts,
	AVG(p.Price) AS AveragePrice
FROM Sales.Products AS p
GROUP BY p.Category
HAVING AVG(p.Price) > 15

DELETE FROM Sales.Products
WHERE ProductID = 106

/*
Write a query to retrieve every order from orders. Display:
# orderid
# orderdate
# Product name (product)
# Customer's first and last name concatenated or displayed as separate columns
# Total sales amount
*/

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Products

SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product AS ProductName,
	CONCAT(c.FirstName, ' ', c.LastName) AS customer_name, 
	p.price	as totalamount
FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID

-- Write a query using a LEFT JOIN between customers and orders to find all customers who have never placed an order in the orders table. Display their customerid, firstname, and country.

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Customers

SELECT 
	c.CustomerID,
	c.FirstName,
	c.Country
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

-- Retrieve the orderid, orderstatus, customer's country, and the salesperson's lastname for all orders placed in the month of February 2025 (orderdate >= '2025-02-01' AND orderdate <= '2025-02-28').

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Employees

SELECT 
	o.OrderID,
	o.OrderStatus,
	c.Country AS Customers_Country,
	e.LastName AS SalesPerson_LastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID 
-- WHERE o.OrderDate BETWEEN '2025-02-01' AND '2025-02-28'
WHERE o.OrderDate >= '2025-02-01' AND o.OrderDate <= '2025-02-28'

