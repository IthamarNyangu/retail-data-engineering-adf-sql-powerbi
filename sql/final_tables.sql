CREATE TABLE Salespersons (
    SalesPersonID INT PRIMARY KEY,
    SalesPersonName NVARCHAR(255),
    StoreID INT
);

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(255),
    Region NVARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    SaleDate DATE,
    StoreID INT,
    ProductID INT,
    SalesPersonID INT,
    UnitsSold INT,
    Revenue DECIMAL(12,2),
    Cost DECIMAL(12,2),

    CONSTRAINT FK_Sales_Store FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Sales_Salesperson FOREIGN KEY (SalesPersonID) REFERENCES Salespersons(SalesPersonID)
);