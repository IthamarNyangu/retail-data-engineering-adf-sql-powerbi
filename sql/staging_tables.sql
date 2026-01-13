USE RetailDB;
GO

CREATE TABLE stg_Salespersons (
    SalesPersonID INT,
    SalesPersonName NVARCHAR(255),
    StoreID INT
);

CREATE TABLE stg_Stores (
    StoreID INT,
    StoreName NVARCHAR(255),
    Region NVARCHAR(100)
);

CREATE TABLE stg_Sales (
    SalesID INT,
    SaleDate DATE,
    StoreID INT,
    ProductID INT,
    SalesPersonID INT,
    UnitsSold INT,
    Revenue DECIMAL(12,2),
    Cost DECIMAL(12,2)
);

CREATE TABLE stg_Products (
    ProductID INT,
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    Price DECIMAL(10,2)
);

