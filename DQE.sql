--------------------------------------------------------------------
/*
SQL Server Advanced Topic for Developers
Email:       roya.amin@gmail.com
Created By:  Roya Amin
Phone No:    9028172174
*/
--------------------------------------------------------------------
USE Northwind
GO;

-- استفاده از روش استفاده از پارامتر در کوئری های پویا
DECLARE @SQL NVARCHAR(1000)
DECLARE @Pid NVARCHAR(50)
SET @pid = '15'

SET @SQL = ' 
 SELECT ProductName , ProductID , UnitPrice, UnitsInStock  FROM Products WHERE ProductID =  '+ @Pid
 
EXEC (@SQL)


-- عدم استفاده از کش پلن
SELECT usecounts , cacheobjtype, objectid , ST.text
  FROM sys.dm_exec_cached_plans CP
    CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) ST

--استفاده از sp_executeSQL
EXECUTE sp_executesql   
        N'SELECT ProductName , ProductID , UnitPrice, UnitsInStock 
		FROM Products WHERE ProductID =  @Pid ',  
        N'@Pid varchar(50)',  
        @pid = '15';


---بررسی مشکل Parameter Sniffing
DROP PROCEDURE IF EXISTS usp_SearchProducts
CREATE PROCEDURE [dbo].[usp_SearchProducts]  
(
	  @ProductID			INT 
	 ,@ProductName			NVARCHAR(100) = NULL	
)
AS          
BEGIN      
	SET NOCOUNT ON;  
 
	DECLARE @SQL							VARCHAR(MAX)
	DECLARE @ProductIDFilter				VARCHAR(MAX)
	DECLARE @ProductNameFilter				VARCHAR(MAX)
	DECLARE @all                            VARCHAR(2)   = '-1'
	
 
	SET @ProductIDFilter = CASE WHEN @ProductID IS NULL OR @ProductID = 0 
	THEN '''' + @all + ''' = ''' + @all + '''' 
	ELSE 'ProductID = ''' +  @ProductID + '''' 
	END
 
	SET @ProductNameFilter = CASE WHEN @ProductName IS NULL OR @ProductName = ''
	THEN '''' + @all + ''' = ''' + @all + '''' 
	ELSE 'ProductName like ''%' + @ProductName + '%''' 
	END
 
		  SET @SQL = 'SELECT ProductName , 
		                     ProductID , 
							 UnitPrice, 
							 UnitsInStock 
		             FROM Products
			WHERE ' + @ProductIDFilter
			+ ' AND ' + @ProductNameFilter + ''
			
 
			PRINT (@sql)
			EXEC(@sql)
END

--حالت دوم
CREATE PROCEDURE [dbo].[usp_SearchProducts2]  
(
	  @ProductID			INT
	 ,@ProductName			NVARCHAR(100) = NULL	
)
AS          
BEGIN      
	SET NOCOUNT ON;  
 
	DECLARE @SQL							NVARCHAR(MAX)
	DECLARE @ParameterDef					NVARCHAR(500)
 
    SET @ParameterDef =      '@ProductID			INT,
							@ProductName			NVARCHAR(100)'
 
 
    SET @SQL = 'SELECT ProductName , 
		                     ProductID , 
							 UnitPrice, 
							 UnitsInStock 
		             FROM Products WHERE -1=-1' 
 
IF @ProductID IS NOT NULL AND @ProductID <> 0 
SET @SQL = @SQL+ ' AND ProductID = @ProductID'
 
IF @ProductName IS NOT NULL AND @ProductName <> ''
 
SET @SQL = @SQL+ ' AND ProductName like ''%'' + @ProductName + ''%'''
 
 
 EXEC sp_Executesql     @SQL,  @ParameterDef, @ProductID=@ProductID,@ProductName=@ProductName
               
               
 
END
--- استفاده از DQE برای ساخت اجزا بانک اطلاعات