CREATE PROCEDURE sp_LoadSalespersons
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Salespersons (SalesPersonID, SalesPersonName, StoreID)
    SELECT DISTINCT
        SalesPersonID,
        SalesPersonName,
        StoreID
    FROM stg_Salespersons
    WHERE SalesPersonID IS NOT NULL;
END;

CREATE PROCEDURE sp_LoadStores
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Stores (StoreID, StoreName, Region)
    SELECT DISTINCT
        StoreID,
        StoreName,
        Region
    FROM stg_Stores
    WHERE StoreID IS NOT NULL;
END;

CREATE PROCEDURE sp_LoadProducts
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Products (ProductID, ProductName, Category, Price)
    SELECT DISTINCT
        ProductID,
        ProductName,
        Category,
        Price
    FROM stg_Products
    WHERE ProductID IS NOT NULL;
END;

CREATE PROCEDURE sp_LoadSales
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Sales (
        SalesID, SaleDate, StoreID, ProductID, SalesPersonID,
        UnitsSold, Revenue, Cost
    )
    SELECT
        SalesID, SaleDate, StoreID, ProductID, SalesPersonID,
        UnitsSold, Revenue, Cost
    FROM stg_Sales
    WHERE SalesID IS NOT NULL;
END;
