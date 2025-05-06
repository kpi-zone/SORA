# PostgreSQL: Vero's Central Data Warehouse

PostgreSQL serves as the **core data warehouse** in the Vero architecture. It stores raw source data, transformed views, and pre-modeled tables that power the semantic layer (Cube.js), BI tools, and AI agents.

## Role of PostgreSQL in Vero

PostgreSQL acts as the **single source of truth** for all downstream components:

- **Ingested data** from Airbyte
- **KPI and semantic models** used by Cube.js
- **Raw SQL exploration** via external tools (if enabled)

It is designed to be:

- Modular and replaceable (e.g., swap for Apache Doris or DuckDB)
- Accessible via standard Postgres clients and libraries
- Transparent and standards-based (SQL-first)

> For higher-scale installations or environments with heavy analytical loads, PostgreSQL can be replaced by more scalable data warehouse technologies like **Apache Doris**. This transition is fully transparent to BI tools and clients because they all connect to **Cube.js**, not directly to the underlying database.

## Demo Data: Contoso Retail Dataset

As part of the demo setup, PostgreSQL is initialized with a sample dataset modeled after the **Microsoft Contoso Retail** data model.

```sql
-- ========================================================================
-- 📊 Contoso Retail Dataset – PostgreSQL Table Definitions and Imports
-- ========================================================================
--
-- These CREATE TABLE statements define the schema for importing the
-- dummy data included in this project (based on the 100K row sample).
--
-- The data follows the format of Microsoft's Contoso Retail model and
-- includes standard tables like Customers, Products, Orders, and Sales.
--
-- 📦 This schema is compatible with the sample data bundled in this repo.
--
-- 🔄 For larger datasets (e.g., 10M or 100M rows), download from:
-- 👉 https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
--
-- Tables:
-- - dim_date
-- - currencyexchange
-- - customer
-- - store
-- - product
-- - orders
-- - orderrows
-- - sales
--
-- Notes:
-- - Foreign key relationships and primary keys are defined.
-- - The "dim_date" table replaces the original "date" table name
--   to avoid conflicts with SQL reserved keywords.
-- - All CSV files must reside in /docker-entrypoint-initdb.d/data/
--   for the COPY commands to work during Docker build/init.
-- ========================================================================
```

These tables are automatically created and populated during container startup using the `init.sql` and `/data/*.csv` files located in the `db/init/` directory.

You can explore more or download large-scale demo data sets directly from the official SQLBI GitHub repository:
🔗 [Contoso Ready-to-Use Data (SQLBI GitHub)](https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data)

## 🔐 Credentials & Connection

Default development settings:

```env
POSTGRES_USER=username
POSTGRES_PASSWORD=Nearness4PrincessNext
POSTGRES_DB=demodb
```

Access PostgreSQL using any client (e.g., DBeaver, psql, DataGrip):

- Host: `localhost`
- Port: `5432`
- User: `username`
- Password: `Nearness4PrincessNext`
- Database: `demodb`

## ✏️ Customizing the Warehouse

You can extend the warehouse by:

- Adding indexes and constraints for performance
- Creating views and materialized views
- Using dbt or SQL scripts in the `init.sql` workflow

To bootstrap your own schema, place SQL and CSV files in `db/init/` and rebuild the container.
