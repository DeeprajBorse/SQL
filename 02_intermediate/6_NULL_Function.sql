-- NULL FUNCTION - IT MEANS NOTHING,'UNKONWN'

/* 
NULL -------------------------------------------> VALUE
For Doing this thing we have 2 Functions 1.ISNULL()  2.COALESCE()
*/

--ISNULL() : Here we are Replacing NULL Value with a Static Value or Column Value
-- SYNTAX : ISNULL(value, replacement_value)

SELECT *
FROM Sales.Orders

-- HERE WE REPLACE THE NULL VALUE WITH SOME STATIC VALUE
SELECT 
	o.OrderID,
	o.ShipAddress,
	ISNULL(o.ShipAddress, 'unknown') [UPDATED SHIP-ADDRESS]
FROM Sales.Orders o

-- HERE WE ARE REPPLACING NULL VALUE WITH COLUMN VALUE

SELECT
	o.OrderDate,
	o.ShipAddress,
	o.BillAddress,
	ISNULL(o.BillAddress, o.ShipAddress) AS [UPDATED BILL-ADD]
FROM Sales.Orders o

-- by using ISNULL() Function we can only have two values so in this case if the column value itself has NULL valu stored init so we are getting null value again in the result for that we use COALESCE() Function

-- COALESCE() : IT RETURNS 1'ST NON NULL VALUE FROM THE LIST
-- SYNTAX: COALESCE(Value1, Value2, Value3, ...... )

-- HERE WE REPLACE THE NULL VALUE WITH SOME STATIC VALUE
SELECT 
	o.ShipAddress,
	COALESCE(o.ShipAddress, 'unknown') AS [SHIP-ADDRESS]
FROM Sales.Orders o

-- HERE WE ARE REPPLACING NULL VALUE WITH COLUMN VALUE
SELECT 
	o.ShipAddress,
	o.BillAddress,
	COALESCE(o.BillAddress, o.ShipAddress) AS [BILL-ADDRESS]
FROM Sales.Orders o

-- BUT STILL NULL VALUE PRESENT IN THE RESULT
SELECT
	o.ShipAddress,
	o.BillAddress,
	COALESCE(o.BillAddress, o.ShipAddress, 'unknown') [BILL-ADDRESS]
FROM Sales.Orders o

-- Empty Strings Handled
SELECT
	o.ShipAddress,
	o.BillAddress,
	COALESCE(NULLIF(o.BillAddress, ''), o.ShipAddress, 'unknown') [BILL-ADDRESS]
FROM Sales.Orders o

/* 
VALUE -------------------------------------------> NULL
For Doing this thing we have Function 1.NULLIF()
*/
-- NULLIF() : IT COMPARES TWO EXPRESSION AND RETURNS 
--            1. NULL IF BOTH ARE EQUAL | 2.FIRST_VALUE IF BOTH ARE NOT EQUAL

SELECT *
FROM Sales.Customers

SELECT 
	c.Score,
	NULLIF(c.Score, 350) AS Score
FROM Sales.Customers c

SELECT
	o.ShipAddress,
	NULLIF(o.ShipAddress, o.BillAddress) [Check-Address],
	NULLIF(o.BillAddress, '') AS BillAddress
FROM SALES.Orders o

-- IS NULL | IS NOT NULL
-- IS NULL: Returns TRUE If the Value Is NULL else FALSE

SELECT
	o.OrderID,
	o.ShipAddress,
	o.BillAddress
FROM Sales.Orders o
WHERE o.ShipAddress IS NULL OR o.BillAddress IS NULL

SELECT
	c.CustomerID,
	c.Score
FROM Sales.Customers c
WHERE c.Score IS NULL

-- IS NOT NULL: Returns TRUE If the Value Is NOT NULL else FALSE

SELECT
	o.OrderID,
	o.BillAddress
FROM Sales.Orders o
WHERE o.BillAddress IS NOT NULL

SELECT
	o.OrderID,
	NULLIF(o.BillAddress, '') BillAddress
FROM Sales.Orders o
WHERE NULLIF(o.BillAddress, '') IS NOT NULL