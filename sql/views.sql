USE RetailDB;
GO

CREATE OR ALTER VIEW vw_SalesEnriched
AS
SELECT
    s.SalesID,
    s.SaleDate,
    s.UnitsSold,
    s.Revenue,
    s.Cost,
    (s.Revenue - s.Cost) AS Profit,

    st.StoreID,
    st.StoreName,
    st.Region,

    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,

    sp.SalesPersonID,
    sp.SalesPersonName
FROM Sales s
INNER JOIN Stores st
    ON s.StoreID = st.StoreID
INNER JOIN Products p
    ON s.ProductID = p.ProductID
INNER JOIN Salespersons sp
    ON s.SalesPersonID = sp.SalesPersonID;
GO


CREATE OR ALTER VIEW vw_ProductPerformance
AS
SELECT
    ProductID,
    ProductName,
    Category,
    SUM(UnitsSold) AS TotalUnitsSold,
    SUM(Revenue) AS TotalRevenue,
    SUM(Revenue - Cost) AS TotalProfit
FROM vw_SalesEnriched
GROUP BY ProductID, ProductName, Category;
GO

CREATE OR ALTER VIEW vw_MonthlyRevenue
AS
SELECT
    DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1) AS MonthStart,
    SUM(Revenue) AS TotalRevenue,
    SUM(Revenue - Cost) AS TotalProfit,
    SUM(UnitsSold) AS TotalUnitsSold
FROM vw_SalesEnriched
GROUP BY DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1);
GO

CREATE OR ALTER VIEW vw_CategoryPerformance
AS
SELECT
    Category,
    SUM(Revenue) AS TotalRevenue,
    SUM(UnitsSold) AS TotalUnitsSold,
    SUM(Revenue - Cost) AS TotalProfit
FROM vw_SalesEnriched
GROUP BY Category;
GO

CREATE OR ALTER VIEW vw_StorePerformance
AS
SELECT
    StoreID,
    StoreName,
    Region,
    SUM(Revenue) AS TotalRevenue,
    SUM(Cost) AS TotalCost,
    SUM(Revenue - Cost) AS TotalProfit,
    SUM(UnitsSold) AS TotalUnitsSold
FROM vw_SalesEnriched
GROUP BY StoreID, StoreName, Region;
GO
