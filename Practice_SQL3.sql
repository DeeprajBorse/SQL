-- Write an ALTER TABLE statement on orders_archive to add a foreign key constraint named fk_archive_product on the column productid, referencing products(productid). Configure it to cascade deletions (ON DELETE CASCADE).

SELECT *
FROM Sales.OrdersArchive

ALTER TABLE Sales.OrdersArchive 
ADD CONSTRAINT fk_archive_product
FOREIGN KEY (ProductID)
REFERENCES Sales.Products 

-- Write an UPDATE statement to apply a 10% price increase (rounded to the nearest whole integer using a numeric function) to all products in the 'Clothing' category.

SELECT *
FROM Sales.Products

UPDATE Sales.Products
SET Price = 30
WHERE ProductID = 105

UPDATE Sales.Products
SET Price = ROUND(Price + (Price * 10/100),0)
WHERE Category = 'Clothing'

-- Write a Query to Display Which Customer Have any Order in Orders and OrdersArchive Table

SELECT 
	c.CustomerID,
	c.FirstName + ' ' + c.LastName AS CustomerName,
	o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.OrdersArchive oa
ON c.CustomerID = oa.CustomerID
WHERE o.CustomerID IS NULL AND oa.CustomerID IS NULL 

-- Write a DELETE statement to remove any customer from the customers table who has never placed an order in either orders or orders_archive.

--Using SET Operator

DELETE FROM Sales.Customers
WHERE CustomerID NOT IN 
(

SELECT CustomerID 
FROM Sales.Orders 
WHERE CustomerID IS NOT NULL

UNION

SELECT CustomerID
FROM Sales.OrdersArchive
WHERE CustomerID IS NOT NULL

)

-- Using JOINS

DELETE c
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.OrdersArchive oa
ON oa.CustomerID = c.CustomerID
WHERE o.CustomerID IS NULL AND oa.CustomerID IS NULL

/*
Write a query to display all employees in a single formatted column named employee_summary.
- Format: UPPER(lastname), firstname - DEPARTMENT (e.g., LEE, Frank - Marketing).
- Also include a second column showing the total character count of this generated summary string.
- Only show employees where lastname is not NULL.
*/

SELECT *
FROM Sales.Employees

SELECT 
UPPER(LastName)+', '+ FirstName +' - '+ Department AS [employee summary],
DATALENGTH(UPPER(LastName)+', '+ FirstName +' - '+ Department) AS [character count]
FROM Sales.Employees
WHERE LastName IS NOT NULL