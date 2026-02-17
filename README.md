# Retail Data Engineering Pipeline (Azure Data Factory + SQL Server + Power BI)

End-to-end retail analytics pipeline that ingests raw sales data (CSV + JSON) from Azure Blob Storage using Azure Data Factory (ADF), loads it into SQL Server staging tables, transforms it into a relational/star-schema friendly model, and delivers reporting-ready views consumed by Power BI.

## Architecture

**Blob Storage (Raw files)** → **ADF (Copy + Orchestration)** → **SQL Server (Staging → Final + Views)** → **Power BI (Model + DAX + Visuals)**

## Data Sources
- `SalespersonsData.csv` — salesperson master data
- `StoresData.csv` — store master data (store → region)
- `SalesData.csv` — transactional sales data
- `ProductsData.json` — product catalog

## SQL Model
- **Staging tables** (`stg_*`) mirror source schemas and act as a raw landing zone.
- **Final tables** enforce integrity and support analytics:
  - `Stores`, `Products`, `Salespersons` (dimensions)
  - `Sales` (fact table with foreign keys)

## Key Features
- ADF pipeline loads raw files into staging tables.
- Stored procedures transform/load data into final tables in FK-safe order.
- Reporting views provide clean, joined and summarized datasets:
  - `vw_SalesEnriched` (fact + dimensions + Profit)
  - `vw_StorePerformance`, `vw_CategoryPerformance`, `vw_MonthlyRevenue`, `vw_ProductPerformance`
- Power BI includes:
  - Optimized model with a dedicated Date table
  - Time intelligence measures (YoY, MoM, YTD, Rolling 12M, Cumulative)

## How to Run (High Level)

### 1) SQL Server
1. Create database `RetailDB`
2. Run:
   - `sql/staging_tables.sql`
   - `sql/final_tables.sql`
   - `sql/stored_procedures.sql`
   - `sql/views.sql`

### 2) Azure Data Factory
1. Upload raw files to Azure Blob Storage container (e.g. `raw-data/`)
2. Configure linked services:
   - Blob Storage
   - SQL Server via Self-Hosted Integration Runtime (SHIR)
3. Run pipeline:
   - `PL_Ingest_Retail_Raw_To_Staging` (Copy → Staging → Stored Procedures)

### 3) Power BI
1. Connect to SQL Server `RetailDB`
2. Load reporting views (recommended: `vw_SalesEnriched`)
3. Create Date table and measures (see documentation)

## Notes
- The sample dataset maps one store per region; therefore store-level and region-level revenue may appear similar due to identical aggregation levels in the sample.
- Raw input files are not included in this repository (unless explicitly permitted).

## Documentation
See `documentation/implementation_steps.md` for screenshots and a step-by-step walkthrough.
