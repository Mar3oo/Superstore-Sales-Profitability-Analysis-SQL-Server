-- Create a DataBase for the data 
IF DB_ID('SuperStore') IS NULL
BEGIN
    CREATE DATABASE SuperStore;
END;
GO

USE SuperStore;
GO

-- DDL

-- =============================================
-- 1. ORDERS TABLE
-- =============================================
CREATE TABLE dbo.orders
(
    [Row_ID]          INT,
    [Order_ID]        VARCHAR(20),
    [Order_Date]      DATE,
    [Ship_Date]       DATE,
    [Ship_Mode]       VARCHAR(50),
    [Customer_ID]     VARCHAR(20),
    [Customer_Name]   VARCHAR(100),
    [Segment]         VARCHAR(50),
    [Country/Region]  VARCHAR(100),
    [City]            VARCHAR(100),
    [State/Province]  VARCHAR(100),
    [Postal_Code]     VARCHAR(20),
    [Region]          VARCHAR(50),
    [Product_ID]      VARCHAR(30),
    [Category]        VARCHAR(50),
    [Sub_Category]    VARCHAR(50),
    [Product_Name]    VARCHAR(255),
    [Sales]           DECIMAL(12, 3),
    [Quantity]        INT,
    [Discount]        DECIMAL(5, 2),
    [Profit]          DECIMAL(12, 4)
);
GO

-- =============================================
-- 2. PEOPLE TABLE
-- =============================================
CREATE TABLE dbo.people
(
    [Regional_Manager] VARCHAR(100),
    [Region]           VARCHAR(50)
);
GO

-- =============================================
-- 3. RETURNS TABLE
-- =============================================
CREATE TABLE dbo.returns
(
    [Order_ID] VARCHAR(20),
    [Returned] VARCHAR(10)
);
GO



-- Load THE DATA

BULK INSERT dbo.orders
FROM 'D:\Data Analytics\_Projects\Superstore-Sales-Profitability-Analysis-SQL-Server\datasets\orders.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO

BULK INSERT dbo.people
FROM 'D:\Data Analytics\_Projects\Superstore-Sales-Profitability-Analysis-SQL-Server\datasets\people.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO

BULK INSERT dbo.returns
FROM 'D:\Data Analytics\_Projects\Superstore-Sales-Profitability-Analysis-SQL-Server\datasets\returns.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    TABLOCK
);
GO


-- QUICK CHECK 
SELECT TOP (10) * FROM dbo.orders;
SELECT TOP (10) * FROM dbo.people;
SELECT TOP (10) * FROM dbo.returns;