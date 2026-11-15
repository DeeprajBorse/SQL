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


