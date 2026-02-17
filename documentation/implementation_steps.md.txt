# Implementation Steps – Retail Data Engineering Pipeline

## 1. Environment Setup

- SQL Server Express installed locally
- Azure Data Factory (ADF) created in Azure
- Azure Blob Storage created for raw data
- Self-Hosted Integration Runtime (SHIR) configured to allow ADF to access local SQL Server

---

## 2. Database Design (SQL Server)

### Staging Layer
Created staging tables mirroring raw file structure:
- stg_Salespersons
- stg_Stores
- stg_Sales
- stg_Products

Staging tables match raw schema exactly to ensure clean ingestion.

### Final Layer
Created relational model with referential integrity:
- Stores
- Products
- Salespersons
- Sales (fact table with foreign keys)

Foreign keys enforce data integrity between fact and dimensions.

---

## 3. Azure Data Factory (ADF)

### Linked Services
- Azure Blob Storage
- SQL Server (via SHIR)

### Pipeline Logic

1. Truncate staging tables
2. Copy raw CSV/JSON into staging tables
3. Truncate final tables
4. Load dimension tables
5. Load fact table (FK-safe order)

Pipeline runs end-to-end without duplicates.

See screenshots:
- adf_pipeline_overview.png
- adf_linked_services.png
- shir_running.png

---

## 4. Data Transformation (SQL)

Stored procedures:
- sp_TruncateStaging
- sp_TruncateFinal
- sp_LoadStores
- sp_LoadProducts
- sp_LoadSalespersons
- sp_LoadSales

Load order ensures foreign key integrity.

Views created for reporting:
- vw_SalesEnriched
- vw_StorePerformance
- vw_CategoryPerformance
- vw_MonthlyRevenue
- vw_ProductPerformance

---

## 5. Power BI Model

- Connected to SQL Server RetailDB
- Imported reporting views
- Created Date dimension table
- Established 1-to-many relationship:
  Date[Date] → vw_SalesEnriched[SaleDate]
- Created DAX measures
- Organized measures into folders:
  - Sales Metrics
  - Profit Metrics
  - Time Intelligence

Time intelligence measures include:
- YoY Growth
- MoM Growth
- YTD Revenue
- Rolling 12M
- Cumulative Revenue

See screenshots:
- powerbi_model.png
- powerbi_dashboard.png
- powerbi_measures.png

---

## 6. Key Insights

- Identified top-performing store by revenue
- Identified dominant product category
- Analyzed monthly trends and seasonality
- Compared regional performance
- Evaluated salesperson performance

Note: Sample dataset contains one store per region; therefore store and region revenue rankings align.
