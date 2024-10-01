--------------------------------------------------------------------
/*
SQL Server Advanced Topic
Email:       roya.amin@gmail.com
Created By:  Roya Amin
Phone No:    9028172174
*/
--------------------------------------------------------------------

-- Enable Actual Execution Plan, IO, and Time Statistics
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Switch to the appropriate database
USE AdventureWorks2014;
GO

--------------------------------------------------------------------
-- Show IO, Scan Count, and Seek Predicates in Execution Plan

-- Non-SARGable Query (Avoiding)
SELECT * 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (75000, 75001, 75002);
GO

-- SARGable Query (Preferred)
SELECT * 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID >= 75000 AND SalesOrderID <= 75002;
GO

-- Another SARGable Query using BETWEEN (Preferred)
SELECT * 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID BETWEEN 75000 AND 75002;
GO

--------------------------------------------------------------------
-- Optimized Query Syntax: >= Condition vs. !< Condition

-- Query using >= Condition
SELECT * 
FROM Purchasing.PurchaseOrderHeader AS poh
WHERE poh.PurchaseOrderID >= 2975;
GO

-- Equivalent Query using !< Condition (Not recommended)
SELECT * 
FROM Purchasing.PurchaseOrderHeader AS poh
WHERE poh.PurchaseOrderID !< 2975;
GO

--------------------------------------------------------------------
