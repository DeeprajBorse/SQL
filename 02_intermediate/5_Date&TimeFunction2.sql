-- FORMAT AND CASTING 
-- STANDARD DATETIME FORMAT : YYYY-MM-dd hh:mm:ss

--FORMATTING
-- THERE ARE 2 WAYS TO PERFORM FORMATTING ONE WITH FORMAT() FUNCTION AND ANOTHER WITH CONVERT() FUNCTION

-- FORMAT()  - Syntax: FORMAT(value, format [, culture(optional)]) and the datatype is 'STRING', i.e. IT CONVERTS ANY DATATYPE INTO STRING

SELECT 
	o.OrderDate,
	FORMAT(o.OrderDate, 'MMM-yyyy') AS [Month - Year Format],
	FORMAT(o.OrderDate, 'dd-MM-yyyy')  AS [European Format],
	FORMAT(o.OrderDate, 'dd-MM-yyyy', 'ja-JP') AS [JAPNEESE FORMAT],
	FORMAT(o.OrderDate, 'MM-dd-yyyy', 'en-US') AS [USA FORMAT]
FROM SALES.ORDERS o;

SELECT 
	o.CreationTime,
	FORMAT(o.CreationTime, 'dd') AS NUM_DAY,
	FORMAT(o.CreationTime, 'ddd') AS ShortName_DAY,
	FORMAT(o.CreationTime, 'dddd') AS FullName_DAY
FROM Sales.Orders o

SELECT 
	o.CreationTime,
	FORMAT(o.CreationTime, 'MM') AS NUM_Month,
	FORMAT(o.CreationTime, 'MMM') AS ShortName_Month,
	FORMAT(o.CreationTime, 'MMMM') AS FullName_Month
FROM Sales.Orders o



SELECT 
	o.CreationTime,
	FORMAT(o.CreationTime, 'hh-mm-ss tt') AS Time_12HR,
	FORMAT(o.CreationTime, 'hh-mm-ss') AS Time_24HR,
	FORMAT(o.CreationTime, 'hh-mm tt') AS Hour
FROM Sales.Orders o

SELECT 
	1234567.89 AS OrdinaryNumber,
	FORMAT(1234567.89, 'N') AS ALIGNED,
	FORMAT(1234567.89, 'C') AS [$ SIGN],
	FORMAT(92.89, 'P') AS [% SIGN]

-- USECASE: 1. THIS METHOD IS USED BEFORE DATA AGGREGATION
		--	2. USE FOR DATA STANDARDIZATION I.E. DATA COMMING FROM VARIOUS SOURCES WITH DIFFERENT FORMAT GETS CONVERTED INTO STANDARD FORMAT FIRST THEN ITS FUTHER USED FOR ANALYSIS 

-- CASTING - ITS THE METHOD OF CONVERTING ONE DATATYPE INTO ANOTHER
-- WE CAN PERFORM CASTING WITH THE HELP OF CAST() AND CONVERT() 

--CAST() - CONVERTING ONE DATATYPE INTO ANOTHER

SELECT
	CAST('2025-08-20' AS DATE) AS dt_DATE

SELECT
	CAST('12345' AS INT) DT_INT

SELECT 
	o.CreationTime,
	CAST(o.CreationTime AS DATE) [DateTime to Date],
	CAST(o.CreationTime AS TIME) [DateTime to Time],
	CAST(o.CreationTime AS VARCHAR) [DateTime to String]
FROM Sales.Orders o


--CONVERT()

/* CONVERT() -- IT BASICALLY PERFORMES BOTH TASK'S WHICH CAST() AND FORMAT() FUNCTION DOES WITH SOME LIMITATION
1. CONVERT() FUNCTION CAN ONLY WORK UPON DATE & TIME FORMAT IT CAN'T WORK UPON NUMBERS AS FORMAT() FUNC DOES
2. AND IT CAN CONVERT ANY DATATYPE INTO ANY DATATYPE JUST ALIKE CASTING

SYNTAX - CONVERT(datatype, value [, Style])
*/

SELECT 
	CONVERT(INT, '123') AS converted_int             -- Casting

SELECT                                               -- FORMATTING
	o.OrderDate,
	CONVERT(VARCHAR, o.OrderDate, 32) AS [USA STD TIME STYLE:32],
	CONVERT(VARCHAR, O.OrderDate, 34) AS [EURO STD TIME STYLE:34],
	CONVERT(TIME, o.CreationTime) AS CT_TIME
FROM SALES.Orders o

----------||------------

-- DATE CALCULATIONS 

-- DATEADD() : WE ADD OR SUB SPECIFIC TIME INTERVAL FROM THE DATE
-- SYNTAX- DATEADD(part, interval, date)

SELECT 
	o.OrderDate,
	DATEADD(YEAR, 3, o.OrderDate) AS Year_ADD,
	DATEADD(MONTH, 5, o.OrderDate) AS Month_ADD,
	DATEADD(DAY, -15, o.OrderDate) AS Day_SUB,
	FORMAT(o.CreationTime, 'hh-mm-ss tt') AS ACTUAL_CT,
	FORMAT(DATEADD(HOUR, 5, o.CreationTime ), 'hh-mm-ss tt') AS UPDATED_CT,
	DATEDIFF(HOUR,O.CreationTime, DATEADD(HOUR, 5, o.CreationTime ) ) AS [Hour Difference]
FROM Sales.Orders o

-- DATEDIFF() : HERE WE CAN FIND THE DIFFERENCE BETWEEN TWO DATES

SELECT
	FORMAT(o.OrderDate, 'dd-MMM-yyyy'),
	FORMAT(o.ShipDate,'dd-MMM-yyyy'),
	DATEDIFF(DAY, o.OrderDate, o.ShipDate) AS [Days Req To Ship Order]
FROM Sales.Orders o

SELECT 
	DATEDIFF(YEAR, '2023-09-26', '2026-10-20') Year_diff,
	DATEDIFF(MONTH, '2025-02-16', '2025-10-02') Month_diff,
	DATEDIFF(DAY, '2025-05-26', '2025-08-15') Day_diff,
	DATEDIFF(HOUR, '11:12:56', '16:15:28') Hours_diff,
	DATEDIFF(MINUTE, '11:12:56', '16:15:28') Minute_diff,
	DATEDIFF(SECOND, '11:12:56', '16:15:28') Second_diff

-- FIND THE AGE OF THE EMPLOYEES AS PER THE DATA PRESENT IN THE TABLE

SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
	e.BirthDate,
	DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS EmployeeAge,
	FORMAT(e.Salary, 'C') SALARY
FROM Sales.Employees e

-- VALIDATION
-- ISDATE() - CHECKS IF A VALUE IS DATE OF NOT IF YES THEN RETURNS 1 ELSE 0

SELECT
	ISDATE('2025-08-20') [ISO DATE],
	ISDATE('2025') [YEAR],
	ISDATE('18-10-2026') [EURO DATE]


SELECT
	-- CAST(OrderDate As DATE),
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
	ELSE '2000-01-01'
	END [New Order Date]
FROM(
SELECT '2025-08-20' AS OrderDate UNION
SELECT '2025-07-24' UNION
SELECT '2025-09-02' UNION
SELECT '2025-02'
) AS OrderDate


