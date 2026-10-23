-- STRING FUNCTIONS

-- CONCAT
SELECT 
	c.FirstName,
	c.LastName,
	CONCAT(c.FirstName, ' ' , c.LastName) AS fullname
FROM Sales.Customers c

UNION

SELECT 
	e.FirstName,
	e.LastName,
	CONCAT(e.FirstName, ' ' , e.LastName) AS fullname
FROM Sales.Employees e

-- UPPER AND LOWER

SELECT 
	c.FirstName,
	c.LastName,
	UPPER(c.FirstName),
	LOWER(c.LastName)
FROM Sales.Customers c

-- TRIM
SELECT *
FROM Sales.Customers

INSERT INTO Sales.Customers
VALUES(6,' Sam', 'Altman ', 'USA', 900, 'sam@example.com')

SELECT *
FROM Sales.Customers c
WHERE c.FirstName != TRIM(c.FirstName)

DELETE FROM Sales.Customers 
WHERE CustomerID = 6

-- REPLACE

SELECT
	'996-665-6563' AS PhoneNumber,
	REPLACE('996-665-6563', '-', '_') AS REPLACED


-- LEN
SELECT 
	FirstName,
	LastName,
	LEN(FirstName) AS LEN_Firstname,
	LEN(LastName) AS LEN_Lastname
FROM Sales.Customers

-- LEFT & RIGHT

SELECT 
	FirstName,
	LastName,
	LEFT(FirstName, 2) AS LEFT_FirstTWO,
	RIGHT(LastName, 3) AS RIGHT_LastTHREE
FROM Sales.Customers

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
WHERE LEFT(FirstName, 2) = 'Ma'

-- SUBSTRING

SELECT 
	FirstName,
	LastName,
	SUBSTRING(FirstName,2,4),
	SUBSTRING(FirstName,2,LEN(TRIM(FirstName)))
FROM Sales.Customers

