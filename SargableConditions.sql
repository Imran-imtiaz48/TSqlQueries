--------------------------------------------------------------------
/*
SQL Server Advanced Topic 
Email:       Roya.amin@gmail.com
Created By:  Roya Amin
Phone No:    9028172174
*/
--------------------------------------------------------------------
--Show Actual Execution Plan 
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
USE AdventureWorks2014
GO
--Show IO & Scan Count & Show Seek Predicates (Execution Plan)
--Non-sargable operators
SELECT * FROM Sales.SalesOrderHeader
	WHERE SalesOrderID IN (75000,75001,75002)
GO
SELECT * FROM Sales.SalesOrderHeader
	WHERE SalesOrderID >=75000 AND SalesOrderID<=75002
GO
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID BETWEEN 75000 AND 75002
GO
--------------------------------------------------------------------
--!< Condition vs. >= Condition
 -- دارد optimize query syntax هر دو کوئری در هر حالت یکسان هستند فقط کوئری دوم مرحله 
SELECT * FROM  Purchasing.PurchaseOrderHeader AS poh
	WHERE  poh.PurchaseOrderID >= 2975 
GO
--optimize query syntax
SELECT * FROM  Purchasing.PurchaseOrderHeader AS poh
	WHERE  poh.PurchaseOrderID !< 2975 
--------------------------------------------------------------------

