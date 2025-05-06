# Vero

Vero is a modern, open-source analytics stack designed to help small and mid-sized organizations work data-driven — without relying on opaque third-party SaaS platforms or complex enterprise BI tools.

It brings together best-in-class open technologies in a modular architecture, enabling you to **ingest, model, visualize, and query data — both with dashboards and natural language**.

## Why Vero?

> **Make it easy for small and mid-sized organizations to adopt a modern, open, and self-hosted analytics stack — without giving up control.**

Too many organizations face the same challenges:

- Complex and costly vendor ecosystems
- Rigid tools that don’t adapt to your workflow
- “Black box” SaaS platforms that obscure what's really happening under the hood
- **Pushing sensitive internal data to external vendors just to generate a chart**
- A lack of data sovereignty and limited infrastructure ownership

Vero was built to solve that — with a **clean reference architecture** and a commitment to open, modular design.

### 🚀 Our Goals:

- **Easy replication**: Provide a production-grade analytics stack that’s understandable, testable, and easy to deploy.
- **Open-source + vendor-neutral**: Use well-documented OSS tools — no hidden fees or lock-in.
- **Data sovereignty**: Run everything on your own servers. Keep internal data internal.
- **Modern stack**: Built on today’s best practices — modular, scalable, and cloud-friendly.
- **Accessible to teams**: Usable by data engineers, analysts, and non-technical stakeholders alike.

With Vero, you’re not just consuming analytics — you **own the full pipeline**, from ingestion to insight.

## 🧱 Architecture Overview

Vero is made up of five layers:

1. **Data Ingestion** – powered by [Airbyte](https://airbyte.com)
2. **Data Warehouse** – default: PostgreSQL (replaceable with Apache Doris or DuckDB)
3. **Semantic Modeling** – [Cube.js](https://cube.dev)
4. **AI Agent Interface** – Agno + custom [MCP server](https://github.com/isaacwasserman/mcp_cube_server)
5. **BI & Dashboards** – [Metabase](https://metabase.com) (optional: Superset, Tableau, Power BI, etc.)

Each layer is loosely coupled and can be replaced or extended as needed.

## 📦 What's Included?

- Prebuilt **Docker environment** for local or on-prem deployment
- Sample dataset based on the **Contoso Retail** model
- Ready-to-use semantic models and views in Cube.js
- Natural language query agent powered by GPT or Claude
- Traditional dashboards and visualizations via Metabase

## 🧪 Quickstart

```bash
# 1. Clone the repository
$ git clone https://github.com/kpi-zone/Vero.git
$ cd Vero

# 2. Start the stack with Docker Compose (for local dev)
$ docker compose --env-file .env.dev up --build

# 3. Access the tools
- Metabase: http://localhost:3000
- Cube.js Playground: http://localhost:4000
- Postgres: localhost:5432 (user: username, pass: Nearness4PrincessNext)
```

> See [`docs/quickstart.md`](./docs/quickstart.md) for full instructions and environment setup.

## 📚 Documentation

- [Architecture Overview](./docs/architecture.md)
- [Quickstart](./docs/quickstart.md)
- [Docker & Runtime Config](./docs/conf/docker.md)
- [Environment Variables](./docs/conf/environment.md)
- [Semantic Modeling (Cube.js)](./docs/semantic/cubejs.md)
- [BI Layer (Metabase)](./docs/bi/metabase.md)
- [AI Agent / MCP Server](./docs/ai/mcp-server.md)
- [Warehouse Layer (PostgreSQL)](./docs/warehouse/postgres.md)

## ❤️ Contributions Welcome

This is a community-friendly reference project. We welcome:

- Feature suggestions and bug reports
- Docs, UX, and onboarding improvements
- New data sources, transformations, and AI plugins

Feel free to open a PR or issue!

## 📄 License

Vero is licensed under the MIT License. All included third-party projects follow their respective licenses.

For support, ideas, or integration help, reach out via GitHub Discussions or open an issue. We’re building Vero to be the foundation for modern, self-managed analytics — for everyone.
