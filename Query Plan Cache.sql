--------------------------------------------------------------------
/*
SQL Server Advanced Topic 

Email:       Roya.amin@gmail.com
Created By:  Roya Amin
Phone No:    9028172174
*/
--------------------------------------------------------------------
SELECT cplan.usecounts, cplan.objtype, qtext.text, qplan.query_plan
FROM sys.dm_exec_cached_plans AS cplan
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS qtext
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qplan
ORDER BY cplan.usecounts DESC


DBCC FREEPROCCACHE

CREATE Database Company
GO

USE Company
GO
 
 
CREATE TABLE department
(
    id INT PRIMARY KEY,
    dep_name VARCHAR(50) NOT NULL, 
 )

INSERT INTO department 
 VALUES
(1, 'Sales'),
(2, 'HR'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Finance')

USE company
GO
 
CREATE PROCEDURE getdepartment
AS
	SELECT * FROM department
GO

EXEC getdepartment

SELECT * FROM department where dep_name = 'Sales'
SELECT * FROM department where dep_name = 'HR'

GO
CREATE PROCEDURE getdepartmentbyname @name nvarchar(30)
AS
	SELECT * FROM department WHERE dep_name = @name
GO

exec getdepartmentbyname 'Sales'
exec getdepartmentbyname 'HR'
