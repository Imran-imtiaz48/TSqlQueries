--------------------------------------------------------------------
/*
SQL Server Advanced Topic for Developers
Email:       roya.amin@gmail.com
Created By:  Roya Amin
Phone No:    9028172174
*/
--------------------------------------------------------------------
USE Northwind;
GO;

-- Using parameters in dynamic queries safely
DECLARE @SQL NVARCHAR(1000);
DECLARE @Pid NVARCHAR(50);
SET @Pid = '15';

-- Avoid SQL injection by using sp_executesql
SET @SQL = N' 
 SELECT ProductName, ProductID, UnitPrice, UnitsInStock  
 FROM Products 
 WHERE ProductID = @Pid';

EXEC sp_executesql @SQL, N'@Pid NVARCHAR(50)', @Pid;

-- Prevent cached execution plan from being used
SELECT usecounts, cacheobjtype, objectid, ST.text
FROM sys.dm_exec_cached_plans CP
CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) ST;

-- Using sp_executesql for parameterized queries
EXEC sp_executesql   
    N'SELECT ProductName, ProductID, UnitPrice, UnitsInStock  
      FROM Products WHERE ProductID = @Pid',  
    N'@Pid NVARCHAR(50)',  
    @Pid = '15';

-- Handling Parameter Sniffing
DROP PROCEDURE IF EXISTS usp_SearchProducts;
GO

CREATE PROCEDURE [dbo].[usp_SearchProducts]  
(
    @ProductID    INT, 
    @ProductName  NVARCHAR(100) = NULL
)
AS          
BEGIN      
    SET NOCOUNT ON;

    -- Declare variables for filters
    DECLARE @ProductIDFilter NVARCHAR(MAX);
    DECLARE @ProductNameFilter NVARCHAR(MAX);
    DECLARE @All NVARCHAR(2) = '-1';

    -- Build dynamic SQL filters
    SET @ProductIDFilter = CASE 
        WHEN @ProductID IS NULL OR @ProductID = 0 
        THEN N'@All = @All' 
        ELSE N'ProductID = @ProductID' 
    END;

    SET @ProductNameFilter = CASE 
        WHEN @ProductName IS NULL OR @ProductName = '' 
        THEN N'@All = @All' 
        ELSE N'ProductName LIKE ''%' + @ProductName + '%''' 
    END;

    -- Construct the final SQL query
    SET @SQL = N'SELECT ProductName, ProductID, UnitPrice, UnitsInStock
                 FROM Products
                 WHERE ' + @ProductIDFilter + N' AND ' + @ProductNameFilter;

    PRINT @SQL;
    EXEC sp_executesql @SQL, N'@ProductID INT, @All NVARCHAR(2)', @ProductID, @All;
END;
GO

-- Alternative approach for dynamic SQL with sp_executesql
CREATE PROCEDURE [dbo].[usp_SearchProducts2]  
(
    @ProductID    INT, 
    @ProductName  NVARCHAR(100) = NULL
)
AS          
BEGIN      
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ParameterDef NVARCHAR(500);

    -- Define the parameter string
    SET @ParameterDef = N'@ProductID INT, @ProductName NVARCHAR(100)';

    -- Start building the SQL query
    SET @SQL = N'SELECT ProductName, ProductID, UnitPrice, UnitsInStock
                 FROM Products
                 WHERE 1=1';

    -- Add dynamic filters
    IF @ProductID IS NOT NULL AND @ProductID <> 0
        SET @SQL += N' AND ProductID = @ProductID';

    IF @ProductName IS NOT NULL AND @ProductName <> ''
        SET @SQL += N' AND ProductName LIKE ''%'' + @ProductName + ''%''';

    -- Execute the dynamic SQL with parameters
    EXEC sp_executesql @SQL, @ParameterDef, @ProductID = @ProductID, @ProductName = @ProductName;
END;
GO
