USE RetailDB;
GO

-- 1) Truncate staging (safe to rerun pipeline without duplicates)
CREATE OR ALTER PROCEDURE sp_TruncateStaging
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE stg_Sales;
    TRUNCATE TABLE stg_Salespersons;
    TRUNCATE TABLE stg_Stores;
    TRUNCATE TABLE stg_Products;
END;
GO

-- 2) Truncate final (so final tables don’t duplicate on reload)
USE RetailDB;
GO

CREATE OR ALTER PROCEDURE sp_TruncateFinal
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete fact rows first (child table)
    DELETE FROM Sales;

    -- Then delete dimension rows (parents)
    DELETE FROM Salespersons;
    DELETE FROM Products;
    DELETE FROM Stores;
END;
GO


-- 3) Load dimensions first
CREATE OR ALTER PROCEDURE sp_LoadStores
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
GO

CREATE OR ALTER PROCEDURE sp_LoadProducts
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
GO

CREATE OR ALTER PROCEDURE sp_LoadSalespersons
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
GO

-- 4) Load fact last (FK-safe)
USE RetailDB;
GO

CREATE OR ALTER PROCEDURE sp_LoadSales
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Sales (
        SalesID, SaleDate, StoreID, ProductID, SalesPersonID,
        UnitsSold, Revenue, Cost
    )
    SELECT
        s.SalesID,
        s.SaleDate,
        s.StoreID,
        s.ProductID,
        s.SalesPersonID,
        s.UnitsSold,
        s.Revenue,
        s.Cost
    FROM stg_Sales s
    INNER JOIN Stores st       ON st.StoreID = s.StoreID
    INNER JOIN Products p      ON p.ProductID = s.ProductID
    INNER JOIN Salespersons sp ON sp.SalesPersonID = s.SalesPersonID
    WHERE s.SalesID IS NOT NULL;
END;
GO

