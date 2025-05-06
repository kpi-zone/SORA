# Vero Architecture Overview

**Vero** is a modular, open-source analytics framework that enables users to analyze, visualize, and interact with business KPIs using both traditional dashboards and natural language AI agents.

The architecture is designed around five key layers: **Data Ingestion, Data Warehouse, Semantic Modeling, AI Agent, and BI & Visualization**. Each layer is decoupled and replaceable, allowing flexibility for various use cases.

## High-Level Architecture Diagram

            +-----------------------------+
            |      End Users & Analysts   |
            +-------------+---------------+
                          |
        +----------------+----------------+
        |                                 |

+-------v--------+ +---------v----------+
| Natural Language| | Metabase | <- Dashboards & Visuals
| (Agno Agent) | | (via Cube.js) |
+-------+--------+ +----------+----------+
| |
+-------v--------+ |
| MCP AI Server | |
| NLP → Query | |
| Translation | |
+-------+--------+ |
| |
+-------v--------+<----------------------+
| Cube.js | <- Semantic Models, Pre-Aggregation, APIs
+-------+--------+
|
+-------v--------+
| PostgreSQL | <- Central Analytical Database
+-------+--------+
|
+-------v--------+
| Airbyte | <- ETL: Source Data Ingestion
+----------------+

## Component Overview

### 1. Data Ingestion Layer – **Airbyte**

**Purpose:** Connect to a variety of external data sources (APIs, databases, files) and sync them into a central warehouse.

- **Sources Supported**: MySQL, Stripe, Salesforce, REST APIs, Google Sheets, and 300+ others
- **Destination**: PostgreSQL (default)
- **Sync Modes**: Full refresh, incremental loading
- **Transformations**: Optional dbt-powered normalization after ingestion

Airbyte cleanly separates **extraction logic from storage**, allowing you to add or swap data sources with minimal rework.

> Want to swap PostgreSQL for another destination? No problem — Airbyte supports a wide range of targets.

### 2. Data Warehouse Layer – **PostgreSQL**

**Purpose:** Serve as the central storage and query engine for raw, normalized, and modeled data.

- **Schema Layers**:
  - Raw source tables (direct from ingestion)
  - Transformed views and materialized KPIs
- **Performance Features**: Indexing, partitioning, query optimization
- **Security**: Optional role-based access control

PostgreSQL acts as the **single source of truth** for all downstream systems — including Cube.js (semantic modeling).

> **Scalability Note:** PostgreSQL is great for most use cases, but if you need horizontal scaling or real-time analytics, you can swap it out for high-performance engines like **Apache Doris**, **ClickHouse**, or **BigQuery**.

### 3. Semantic Layer – **Cube.js**

**Purpose:** Define KPIs, dimensions, and business logic in a structured, queryable format.

- **Schema Abstractions**:
  - **Measures** (e.g., total revenue)
  - **Dimensions** (e.g., customer country)
  - **Joins** and **Segments**
- **Pre-Aggregations**: Dramatically improve performance by caching heavy queries
- **API Endpoints**: Expose models via REST, GraphQL, or SQL
- **Authorization**: Built-in support for row-level security via JWTs

Cube.js allows you to **model once and query anywhere**, powering both dashboards and AI interfaces with consistent definitions.

### 4. AI Agent Layer – **Agno UI + MCP AI Server**

**Purpose:** Let users ask business questions in plain language and return accurate, contextual answers — powered by your semantic layer.

- **Frontend – Agno Agent**:
  - Lightweight web-based chat UI
  - Pluggable into internal tools or portals
- **Backend – MCP AI Server**:
  - Parses natural language, detects intent
  - Constructs queries against Cube.js
- **LLM Support**: Works with GPT, Claude, or your own self-hosted model
- **Extensibility**:
  - Plugin system for adding new “skills” (custom query logic)
  - Hooks for system prompts, guardrails, and fallback logic

The AI layer uses Cube’s metadata to ground every question in your actual data model — no hallucinated KPIs or misleading guesses.

### 5. BI & Visualization Layer – **Metabase**

**Purpose:** Build dashboards, run queries, and share visual insights across your organization.

- **Connects to**: PostgreSQL directly or Cube.js via the REST SQL proxy
- **UI Features**:
  - Drag-and-drop dashboard builder
  - Filters, charts, pivot tables
- **Sharing**: Embedded charts, public dashboards, scheduled reports
- **Advanced Tools**:
  - Raw SQL editor
  - Saved questions and alerts

Metabase provides a **no-code, intuitive frontend** for stakeholders who prefer visual workflows over chat-based exploration.

graph TD
subgraph Data Ingestion
A[Airbyte]
end

    subgraph Data Warehouse
        B[PostgreSQL]
    end

    subgraph Semantic Layer
        C[Cube.js]
    end

    subgraph AI Agent
        D1[Agno UI]
        D2[MCP AI Server]
    end

    subgraph BI & Visualization
        E[Metabase]
    end

    A --> B
    B --> C
    C --> D2
    D2 --> D1
    C --> E
