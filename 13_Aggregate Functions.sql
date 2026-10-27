/* ============================================================================== 
   SQL Aggregate Functions
   Table of Contents:
     1. Basic Aggregate Functions
        - COUNT
        - SUM
        - AVG
        - MAX
        - MIN
     2. Grouped Aggregations
        - GROUP BY
=================================================================================
*/

-- BASIC AGGREGATE FUNCTIONS

-- COUNT()
-- Find the total number of customers

SELECT 
    COUNT(*) Total_Customers
FROM Sales.Customers

-- SUM()
-- Find the total sales of all orders

SELECT
    SUM(Sales) AS total_sales
FROM Sales.Orders

-- AVG()
-- Find the average sales of all orders

SELECT
    AVG(Sales) AS avg_Sales
FROM Sales.Orders

-- MAX()
-- Find the Maximum Sales Amount

SELECT 
    MAX(Sales) AS max_Sale
FROM Sales.Orders

-- MIN()
-- Find the Minimum Sales Amount

SELECT 
    MIN(Sales)
FROM Sales.Orders

-- PERFROM ALL THESE FUNCTIONS ON CUSTOMERS TABLE

SELECT 
    COUNT(*) AS NoOfCustomers,
    SUM(COALESCE(c.Score, 0)) AS total_score,
    AVG(COALESCE(c.Score, 0)) AS avg_Score,
    MAX(ISNULL(c.Score, 0)) AS MaximunScore,
    MIN(c.Score) AS Minimum_Score
FROM Sales.Customers c

-- Grouped Aggregations  
-- GROUP BY

SELECT 
    CustomerID,
    COUNT(*) AS total_Customers,
    SUM(Sales) As totalSales,
    AVG(Sales) AS averageSales,
    MAX(Sales) AS maxSales,
    MIN(Sales) AS minSales
FROM Sales.Orders 
GROUP BY CustomerID