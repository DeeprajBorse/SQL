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