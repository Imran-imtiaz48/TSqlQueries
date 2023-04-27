DROP DATABASE IF EXISTS Royadb
CREATE DATABASE Royadb
GO

USE Royadb

CREATE TYPE LessonType 
  AS TABLE
(
 LessonId   INT, 
 LessonName NVARCHAR(100)
)

CREATE TABLE Lesson ( 
        Id    INT PRIMARY KEY, 
        LessonName NVARCHAR(100)
                )


CREATE PROCEDURE Usp_InsertLesson 
@ParLessonType LessonType READONLY
AS
INSERT INTO Lesson
SELECT * FROM @ParLessonType

DECLARE @VarLessonType AS LessonType
 
INSERT INTO @VarLessonType
VALUES ( 1, N'ریاضیات'
       )
INSERT INTO @VarLessonType
VALUES ( 2, N'پایگاه داده'
       )
INSERT INTO @VarLessonType
VALUES ( 3, N'ساختمان داده'
       )
    
    
EXECUTE Usp_InsertLesson @VarLessonType


SELECT * FROM Lesson


--Using Memory-Optimized Table-Valued Parameters

CREATE TYPE LessonType_MemOptimized
 AS TABLE
(
   LessonId  INT PRIMARY KEY NONCLUSTERED  HASH WITH (BUCKET_COUNT = 1000)
 , LessonName NVARCHAR(100)
) WITH ( MEMORY_OPTIMIZED = ON )

CREATE PROCEDURE Usp_InsertLessonMemOpt
@ParLessonType LessonType_MemOptimized READONLY
AS
INSERT INTO Lesson
SELECT * FROM @ParLessonType

DECLARE @VarLessonType_MemOptimized AS LessonType_MemOptimized
 
INSERT INTO @VarLessonType_MemOptimized
VALUES ( 4, N'ذخیره و بازیابی '
       )
INSERT INTO @VarLessonType_MemOptimized
VALUES ( 5, N'آمار و احتمال '
       )
INSERT INTO @VarLessonType_MemOptimized
VALUES ( 6, N'گرافیک '
       )
    
EXEC Usp_InsertLessonMemOpt @VarLessonType_MemOptimized 
    

SELECT * FROM Lesson

--Compare with Perfmon

TRUNCATE TABLE Lesson
GO
    
DECLARE @Counter AS INT=1
WHILE @Counter <= 10000
BEGIN 
	DECLARE @VarLessonType AS LessonType
    
	SET @Counter = @Counter+1 
    
	INSERT INTO @VarLessonType
	VALUES ( @Counter, 'Math'
			   )
	SET @Counter = @Counter+1
	INSERT INTO @VarLessonType
	VALUES ( @Counter, 'Science'
		   )
	SET @Counter = @Counter+1
	INSERT INTO @VarLessonType
	VALUES ( @Counter, 'Geometry'
		   )
     EXECUTE Usp_InsertLesson @VarLessonType
      
	 DELETE @VarLessonType
END

TRUNCATE TABLE Lesson
GO
    
DECLARE @Counter AS INT=1
WHILE @Counter <= 10000
BEGIN 
	DECLARE @VarLessonType_MemOptimized AS LessonType_MemOptimized
    
	SET @Counter = @Counter+1 
    
	INSERT INTO @VarLessonType_MemOptimized
	VALUES ( @Counter, 'Math'
		   )
	SET @Counter = @Counter+1
 
	INSERT INTO @VarLessonType_MemOptimized
	VALUES ( @Counter, 'Science'
		   )
	SET @Counter = @Counter+1
 
	INSERT INTO @VarLessonType_MemOptimized
	VALUES ( @Counter, 'Geometry'
		   )
	EXECUTE Usp_InsertLessonMemOpt @VarLessonType_MemOptimized
	DELETE @VarLessonType_MemOptimized
END




