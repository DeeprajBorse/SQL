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
