/*
	RECURSIVE CTE:
	-It is self-referencing query that iterates data until a specific condition is met.
	-It is alike Just alike Recursion 
	-We use Recurive CTE when we have Hierarchical structure
*/

-- TASK : Generate a sequence of numbers from 1 to 20

WITH Iterate AS
(
SELECT 
	1 AS MyNumber

UNION ALL

SELECT
	MyNumber + 1
FROM Iterate
WHERE MyNumber < 20
)
SELECT *
FROM Iterate;

-- GENERATE A TABLE OF 29

WITH Number AS
(
SELECT 
	29 AS Twenty_Nine
UNION ALL

SELECT 
	Twenty_Nine + 29
FROM Number
WHERE Twenty_Nine < 290
)
SELECT *
FROM Number
OPTION (MAXRECURSION  10);

/*
	TASK: Show Employee Hierarchy by displaying each employee level within organization
*/

WITH Emp_Level AS
(
SELECT 
	EmployeeID,
	CONCAT(FirstName,' ', LastName) EmployeeName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL

UNION ALL

SELECT
	e.EmployeeID,
	CONCAT(e.FirstName,' ', e.LastName) EmployeeName,
	e.ManagerID,
	el.Level + 1
FROM Sales.Employees e
INNER JOIN Emp_Level el
ON e.ManagerID = el.EmployeeID
)
SELECT *
FROM Emp_Level;

/*
	TASK:
		Generate a complete daily calendar for January 2025 (2025-01-01 to 2025-01-31) 
		and show total daily sales for every day, displaying 0 on days with no orders.
*/

WITH JanCalender AS
(
SELECT
	CAST('2025-01-01' AS DATE) AS calc_date
UNION ALL
SELECT 
	DATEADD(Day, 1, calc_date)
FROM JanCalender
WHERE calc_date < '2025-01-31'
)
SELECT 
	jc.calc_date,
	COALESCE(SUM(o.Sales), 0) AS DailySales 
FROM JanCalender jc
LEFT JOIN Sales.Orders o
ON jc.calc_date = o.OrderDate
GROUP BY jc.calc_date
ORDER BY jc.calc_date;

/*
	TASK:
		Build a top-down organizational hierarchy from the employees table, 
		assigning each employee a numeric management tier starting at 1 for top executives (managerid IS NULL).
*/

WITH Employee_Hierarchy AS
(
SELECT 
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS LEVEL
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	eh.LEVEL + 1
FROM Sales.Employees e
INNER JOIN Employee_Hierarchy eh
ON eh.EmployeeID = e.ManagerID
)
SELECT *
FROM Employee_Hierarchy;

/*
	TASK:
		Display every employee alongside their full reporting path from the top executive down to them (e.g., Frank -> Mary -> Carol).
*/

WITH ManagementChain AS
(
SELECT
	EmployeeID,
	ManagerID,
	CAST(FirstName AS VARCHAR(500)) AS reporting_path
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
SELECT
	e.EmployeeID,
	e.ManagerID,
	CAST(CONCAT(mc.reporting_path, '-->', e.FirstName ) AS VARCHAR(500)) reporting_path
FROM ManagementChain mc
INNER JOIN Sales.Employees e
ON e.ManagerID = mc.EmployeeID
)
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.Department,
	mc.reporting_path
FROM Sales.Employees e
LEFT JOIN ManagementChain mc
ON e.EmployeeID = mc.EmployeeID;

/*
	TASK:
		Trace the chain of command upward starting from employee ID 5 (Carol Baker) all the way to the top executive,
		showing how many management levels each person sits above her.
*/

WITH UpwardChain AS
(
SELECT
	EmployeeID,
	FirstName,
	LastName,
	Department,
	ManagerID,
	0 AS Step_Above
FROM Sales.Employees
WHERE EmployeeID = 5
UNION ALL
SELECT
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	e.Department,
	e.ManagerID,
	uc.Step_Above + 1
FROM Sales.Employees e
INNER JOIN UpwardChain uc
	ON e.EmployeeID = uc.ManagerID
)
SELECT DISTINCT
	EmployeeID,
	FirstName,
	LastName,
	Department,
	Step_Above
FROM UpwardChain 
ORDER BY Step_Above ASC

/*
	TASK:
		Simulate bulk pricing tiers for 'Bottle' (productid = 101, base price $10) across quantities from 1 to 10 units,
		reducing the unit price by $0.50 for each additional unit and calculating the total batch cost.
*/

WITH BulkQuantity AS
(
SELECT 
	ProductID,
	Product,
	1 AS unit_qty,
	CAST(Price AS DECIMAL(10,2)) unit_price
FROM Sales.Products
WHERE ProductID = 101

UNION ALL

SELECT
	ProductID,
	Product,
	unit_qty + 1,
	CAST(unit_price  - 0.50 AS DECIMAL(10,2))
FROM BulkQuantity
WHERE unit_qty < 10
)
SELECT 
	ProductID,
	Product,
	unit_price,
	unit_price,
	(unit_price * unit_qty) AS total_batch_cost
FROM BulkQuantity