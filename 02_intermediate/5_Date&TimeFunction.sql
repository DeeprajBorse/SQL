-- DATE AND TIME FUNCTIONS

SELECT 
	o.OrderDate,
	o.ShipDate,
	o.CreationTime
FROM Sales.Orders o; 

-- DAY(), MONTH(), YEAR()

SELECT	
	o.OrderDate,
	DAY(o.OrderDate) AS day_OD,
	MONTH(o.OrderDate) AS month_OD,
	YEAR(o.OrderDate) AS year_OD
FROM SALES.Orders o

-- DATEPART()
-- IT NOT ONLY RETURNS DAY, MONTH, YEAR BUT ALSO RETURNS HOUR, WEEK, QUATER, ETC

SELECT 
	o.CreationTime,
	DATEPART(YEAR, o.CreationTime) AS Year_dp,
	DATEPART(MONTH, o.CreationTime) AS Month_dp,
	DATEPART(DAY, o.CreationTime) AS Day_dp,
	DATEPART(WEEK, o.CreationTime) AS Week_dp,
	DATEPART(QUARTER, o.CreationTime) AS Quater_dp,
	DATEPART(HOUR, o.CreationTime) AS Hour_dp,
	DATEPART(MINUTE, o.CreationTime) AS Min_dp,
	DATEPART(SECOND, o.CreationTime) AS Second_dp,
	DATEPART(MILLISECOND, o.CreationTime) AS MilliSecond_dp
FROM Sales.Orders o

-- DATENAME
-- This function basically returns the actual name of the day or month

SELECT 
	o.ShipDate,
	DATENAME(WEEKDAY, o.ShipDate) AS Day_dn,
	DATENAME(DAY, o.ShipDate) As Day_dn_num,
	DATENAME(MONTH, o.ShipDate)AS Month_dn,
	DATENAME(YEAR, o.ShipDate) AS Year_dn
FROM Sales.Orders o

-- DATETRUNC()
-- IT TRUNCATES THE DATA AT SPECIFIC PART AND RESET THE REST DATA 00 FOR TIME AND 01 IN CASE OF DATE

SELECT 
	o.CreationTime,
	DATETRUNC(MINUTE, o.CreationTime) AS Minute_dt,
	DATETRUNC(HOUR, o.CreationTime) AS Hour_dt,
	DATETRUNC(DAY, o.CreationTime) AS Day_dt,
	CAST(DATETRUNC(MONTH, o.CreationTime) AS DATE) AS Month_dt,
	DATETRUNC(YEAR, o.CreationTime) AS Year_dt
FROM Sales.Orders o

-- EOMONTH() - END OF MONTH

SELECT 
	o.OrderDate,
	EOMONTH(O.OrderDate)
FROM Sales.Orders o

-- WRITE A QUERY TO DISPLAY FIRST DATE OF THE MONTH AND THE LAST DATE OF THE MONTH WITH THE HELP OF SHIPDATE COLUMN, NAME THE MONTH AND THE DAY PRESENT ON FIRST DAY OF THE MONTH AND THE LAST DAY OF THE MONTH

SELECT 
	o.ShipDate,
	DATETRUNC(MONTH, o.ShipDate) AS FirstDay,
	DATENAME(WEEKDAY , (DATETRUNC(MONTH, o.ShipDate))) AS FirstDayName,
	DATENAME(MONTH, o.ShipDate) AS Month_Name,
	EOMONTH(o.ShipDate) AS LastDate,
	DATENAME(WEEKDAY, EOMONTH(o.ShipDate)) AS LastDateName
FROM Sales.Orders o
---------------------------------------
SELECT 
	MONTH(o.ShipDate) AS _Month,
	COUNT(o.OrderID) AS NoofOrders
FROM Sales.Orders o
GROUP BY MONTH(o.ShipDate)
-------------------------------------
SELECT 
	DATENAME(MONTH, ShipDate) AS Month,
	Count(*) NoOfOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, ShipDate)
ORDER BY DATENAME(MONTH, ShipDate) DESC
