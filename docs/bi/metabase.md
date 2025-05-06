# Metabase: Dashboards and Visualization in Vero

Metabase is the **BI and visualization layer** in the Vero stack. It provides a user-friendly interface to explore data, build dashboards, and share insights with stakeholders — all without writing code.

In Vero, Metabase connects to Cube.js using the **SQL-over-Postgres API**, enabling governed, semantic access to your business metrics.

> 🔗 [Metabase GitHub](https://github.com/metabase/metabase)
> 🔗 [Metabase Documentation](https://www.metabase.com/docs)

## Role of Metabase in Vero

Metabase serves as:

- A **visual analytics tool** for dashboards, charts, tables, KPIs
- A **self-service platform** for analysts and business users
- A frontend that queries **Cube.js’s semantic layer**, not raw databases

With Metabase, your users can:

- Explore metrics defined in Cube.js views
- Build dashboards with drag-and-drop ease
- Create pivot tables, filters, and KPIs
- Share visual reports via public links or scheduled emails

> **Note**: Vero also supports other BI tools such as **Apache Superset**, **Power BI**, **Tableau**, or any platform that supports Postgres-compatible SQL connections. Different teams or departments can use different BI tools — and still query the same semantic models in Cube.js. This ensures **consistent KPIs and business logic across your organization**, regardless of frontend preference.

## Setup & Configuration

Metabase is included in the Vero Docker setup. It runs at:

```bash
http://localhost:3000
```

It uses `metabase-db` (PostgreSQL) as its internal application database.

Environment variables are defined in:

```
metabase/.env.dev        # Runtime config
metabase/.env.example    # Template for new environments
```

### Docker Images Used:

Depending on your architecture, Vero uses one of two Docker images for Metabase:

| Architecture | Docker Image                            | Notes                           |
| ------------ | --------------------------------------- | ------------------------------- |
| `x86_64`     | `metabase/metabase:latest`              | Default official image          |
| `arm64`      | `stephaneturquay/metabase-arm64:latest` | Optimized for Apple M1/M2 chips |

Make sure to use the correct image by selecting the appropriate Docker Compose file (`docker-compose.yaml` or `docker-compose.arm64.yaml`).

## First-Time Setup

When you open Metabase for the first time:

1. **Create an admin user** (email + password)
2. **Add your first data source**:

   - Database: **PostgreSQL**
   - Host: `cubejs`
   - Port: `15432`
   - Database name: _any dummy name, e.g. `demodb`_
   - Username: `user`
   - Password: `password`

> ⚠️ You are not connecting to Postgres directly — this connects to **Cube.js’s SQL-over-Postgres API**.

## 📁 Folder Structure

```bash
metabase/
├── .env.dev          # Metabase runtime configuration
```

Metabase data is persisted via Docker volume `metabase-data`.

## Using Metabase with Cube.js

Once Metabase is connected:

- Use the **native query editor** or **GUI query builder**
- Only fields exposed via Cube.js views (i.e., `public: true`) will be visible
- Grouped folders and field aliases defined in Cube views appear in the UI

> Best practice: define metrics, logic, and joins in Cube.js, not Metabase.

## Dashboards & Features

Metabase supports:

- Time series, bar, line, pie, KPI widgets
- Filters: time, dropdown, number ranges
- Drill-throughs and click-to-filter
- Dashboard embedding & public sharing
- Scheduled email reports & Slack delivery

Dashboards can be grouped by topic or domain (e.g., sales, marketing, ops).

## Governance Model

Metabase respects the visibility rules set in Cube.js:

- Only `public: true` views are queryable
- Raw cubes with `public: false` are **hidden**
- Field-level visibility is controlled via Cube.js `includes`/`excludes`

Use Cube.js views to curate exactly what business users can access.

## Tips & Best Practices

- Create "saved questions" as building blocks for dashboards
- Avoid raw SQL — use Cube views for consistency and reuse
- Use folders in Cube views to simplify UI navigation
- Consider enabling JWT authentication for embedded dashboards
- Pre-aggregations in Cube.js can dramatically improve performance

## Admin Features

Metabase offers:

- Role-based access control (RBAC)
- Email + Slack report scheduling
- Native dashboard embedding (with/without JWTs)
- Usage stats and audit logging (in pro/enterprise tiers)

Need more? Visit the [Metabase Docs](https://www.metabase.com/docs) or the [GitHub repo](https://github.com/metabase/metabase) to dive deeper into customization, embedding, and advanced configurations.
