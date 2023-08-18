--PART-1
--1. Create a database <yourfirstname>vertical.
CREATE DATABASE Rohitvertical
go

--2. Create a table “Product” table with the following columns: id, name, description, price, category, brand, and quantity. 
--(Note: Insert 10 rows of data in this table)
CREATE TABLE Product
(
	Id int IDENTITY (1,1) NOT NULL,
	Name varchar (100),
	Description varchar (100),
	Price decimal(10,2),
	Category varchar (20),
	Brand varchar (20),
	Quantity int
	CONSTRAINT Product_PK PRIMARY KEY CLUSTERED (Id)
)
go

INSERT INTO dbo.Product(Name,Description, Price, Category, Brand, Quantity)
VALUES
('Farm Egg', 'Farm Egg by Fresco', 8.50, 'Dairy' , 'Fresco', 1),
('Bread', 'Bread by Costco', 2.50, 'Dairy' , 'Costco', 5),
('Rice', 'Basmati Rice by Food basics', 13.50, 'Food' , 'Food Basics', 3),
('Fam Curd', 'Farm Curd by Fresco', 4.50, 'Dairy' , 'Fresco', 2),
('Flour', 'Indian Flour by Walmart', 17.50, 'Food' , 'Walmart', 1),
('Body Lotion', 'Lotion by Jonhson', 7.00, 'Beauty' , 'Jonhson', 18),
('Jeans', 'Jeans by Zara', 22.50, 'Clothes' , 'Zara', 1),
('Chicken', 'Frozen Chicken by Fresco', 9.50, 'Dairy' , 'Fresco', 1),
('Shirt', 'Shirt by Lee', 12.50, 'Clothes' , 'Lee', 1),
('Shoes', 'Shoes by Nike', 21.50, 'Shoes' , 'Nike', 1)
go

SELECT * FROM dbo.Product
go

--3. Apply vertical partitioning by dividing the above table into two partition tables:
--i. “ProductBasic” table (Columns: id, name, description and category)
--ii. “ProductDetails” table (Columns: id, price, brand, quantity)
CREATE TABLE ProductBasic
(
Id int FOREIGN KEY REFERENCES Product (Id),
Name varchar(100),
Description varchar (100),
Category varchar (20),
Brand varchar (20),
CONSTRAINT PK_ProductBasic PRIMARY KEY CLUSTERED (Id)
)
go

INSERT INTO dbo.ProductBasic(Id,Name, Description, Category, Brand)
VALUES
(1,'Farm Egg', 'Farm Egg by Fresco', 'Dairy' , 'Fresco'),
(2,'Bread', 'Bread by Costco', 'Dairy' , 'Costco'),
(3,'Rice', 'Basmati Rice by Food basics', 'Food' , 'Food Basics'),
(4,'Fam Curd', 'Farm Curd by Fresco','Dairy' , 'Fresco'),
(5,'Flour', 'Indian Flour by Walmart', 'Food' , 'Walmart'),
(6,'Body Lotion', 'Lotion by Jonhson','Beauty' , 'Jonhson'),
(7,'Jeans', 'Jeans by Zara', 'Clothes' , 'Zara'),
(8,'Chicken', 'Frozen Chicken by Fresco', 'Dairy' , 'Fresco'),
(9,'Shirt', 'Shirt by Lee', 'Clothes' , 'Lee'),
(10,'Shoes', 'Shoes by Nike', 'Shoes' , 'Nike')
go

SELECT * FROM dbo.ProductBasic
go

CREATE TABLE ProductDetails
(
Id int NOT NULL,
Price decimal(10,2),
Brand varchar (20),
Quantity int
CONSTRAINT PK_ProductDetails PRIMARY KEY CLUSTERED (Id)
)
go

INSERT INTO dbo.ProductDetails(Id,Price, Brand, Quantity)
VALUES
(1,8.50, 'Fresco', 1),
(2,2.50, 'Costco', 5),
(3,13.50,'Food Basics', 3),
(4,4.50, 'Fresco', 2),
(5,17.50,'Walmart', 1),
(6,7.00, 'Jonhson', 18),
(7,22.50,'Zara', 1),
(8,9.50, 'Fresco', 1),
(9,12.50, 'Lee', 1),
(10,21.50,'Nike', 1)
go

SELECT * FROM dbo.ProductDetails
go

--4. Calculate the query performance of each table by retrieving the same ‘id’ from three tables.
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT Id
FROM dbo.Product
WHERE Id = 1;
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
go

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT Id
FROM dbo.ProductBasic
WHERE Id = 1
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
go

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT Id
FROM dbo.ProductDetails
WHERE Id = 1
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
go


--5. Retrieve basic information of all products in a specific category from the “ProductBasic” table.
SELECT * FROM dbo.ProductBasic
WHERE 
Category = 'Dairy'
go

--6. Retrieve the price and brand of a specific product from the “ProductDetails” table.
SELECT Price, Brand FROM ProductDetails
WHERE
Brand = 'Fresco'
go

--PART-2
--1. Create a database <yourfirstname>horizontal.
CREATE DATABASE Rohithorizontal
go

--2. Create a table “Birthday” table with the following columns: s.no, name, date, month (01 - 06) and year. 
--(Note: Insert 20 rows of data in this table)
CREATE TABLE Birthday
(
	Sno int IDENTITY (1,1) NOT NULL,
	Name varchar (100),
	Date int ,
	Month int,
	Year int
)
go

INSERT INTO dbo.Birthday(Name, Date, Month, Year)
VALUES
('Rohit', 26, 7, 1990),
('Abhirup', 26, 4, 1991),
('Ratnakar', 16, 7, 1992),
('Rohan', 6, 8, 1993),
('Rahul', 31, 7, 1994),
('Rajesh', 30, 8, 1995),
('Deepak', 26, 2, 1996),
('Kunal', 26, 7, 1997),
('Virat', 22, 12, 1998),
('Anushka', 26, 11, 1999),
('Priyanka', 11, 7, 1990),
('Katrina', 15, 5, 1990),
('Salman', 17, 7, 1992),
('Remo', 26, 7, 1993),
('John', 12, 8, 1994),
('Jerry', 15, 8, 1995),
('Laura', 8, 9, 1996),
('Tom', 26, 7, 1997),
('Arun', 24, 7, 1998),
('Dhruv', 26, 8, 1999)
go

SELECT * FROM dbo.Birthday
go


--3. Create filegroups within the database to divide them by month.
ALTER DATABASE Rohithorizontal ADD FILEGROUP January
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP February
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP March
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP April
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP May
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP June
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP July
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP August
GO
ALTER DATABASE Rohithorizontal ADD FILEGROUP September
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP October
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP November
go
ALTER DATABASE Rohithorizontal ADD FILEGROUP December
go

-- To show the created file group
SELECT data_space_id, name AS AvailableFilegroups, type_desc FROM sys.filegroups
WHERE type = 'FG'
go

--Assigning hardware locations to partitions
ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Jan],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_1.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [January]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Feb],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_2.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [February]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Mar],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_3.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [March]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Apr],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_4.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [April]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [May],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_5.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [May]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Jun],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_6.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [June]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Jul],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_7.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [July]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Aug],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_8.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [August]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Sep],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_9.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [September]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Oct],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_10.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [October]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Nov],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_11.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [November]
go

ALTER DATABASE [Rohithorizontal]
    ADD FILE 
    (
    NAME = [Dec],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Rohithorizontal_12.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    )  TO FILEGROUP [December]
go


--To check files created added to the filegroups
SELECT 
name as [FileName],
physical_name as [FilePath] 
FROM sys.database_files
where type_desc = 'ROWS'
go


--4. Create a partition function <yourfirstname>ByMonth (Note: The datatype of the month to be integer)
CREATE PARTITION FUNCTION [RohitByMonth] (int)
AS RANGE RIGHT FOR VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
go

--5. Create a partition scheme <yourfirstname>ByMonthADT
CREATE PARTITION SCHEME RohitByMonthADT
AS PARTITION RohitBymonth
TO (January, January, February, March, 
    April, May, June, July, 
    August, September, October, 
    November, December)
go

--6. create or modify a table and specify the partition scheme as the storage location to segment the data out 
--and store it within the appropriate file group.
CREATE TABLE BirthdayMonth
(Id int IDENTITY (1,1) NOT NULL,
 BirthdayMonth int NOT NULL,
 PRIMARY KEY (BirthdayMonth, Id))
	ON RohitByMonthADT(BirthdayMonth);
go

INSERT dbo.BirthdayMonth VALUES 
(1),
(2),
(3),
(4),
(5),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12)
GO

SELECT * from dbo.BirthdayMonth
GO

--7. Write a query to check the number of records in each partition.
SELECT $PARTITION.RohitByMonth(BirthdayMonth) AS Partition, COUNT(*) AS [COUNT] FROM dbo.BirthdayMonth
GROUP BY $PARTITION.RohitByMonth(BirthdayMonth) ORDER BY Partition
GO

--8. Execute the records in partition number 3.
SELECT * FROM dbo.BirthdayMonth
WHERE $PARTITION.RohitByMonth(BirthdayMonth) = 3
go