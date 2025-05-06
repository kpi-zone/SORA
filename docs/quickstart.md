# 🚀 Vero Quickstart Guide

This guide walks you through setting up **Vero** on your local machine using Docker. In just a few minutes, you’ll have the full analytics stack — including Airbyte, PostgreSQL, Cube.js, the AI Agent, and Metabase — up and running with demo data and models.

---

## 💾 Prerequisites

- [Git](https://git-scm.com/downloads)
- [Docker + Docker Compose](https://docs.docker.com/get-docker/)

---

## 📅 1. Clone the Vero Repository

```bash
git clone https://github.com/kpi-zone/Vero.git
cd Vero
```

---

## 🐳 2. Start the Stack with Docker

Run the following command from the **Vero project root**:

```bash
docker compose --env-file .env.dev up --build
```

> ✅ This uses `.env.dev` to load development environment variables.
> 📌 For production or custom environments, point to a different `.env` file.

---

## 🧱 3. What Gets Built

During the build process, Docker sets up all key components of the [Vero architecture](./architecture.md):

- **Airbyte** – Data ingestion
- **PostgreSQL** – Central data warehouse
- **Cube.js** – Semantic modeling layer
- **MCP AI Server** – Natural language query engine
- **Agno AI Agent** – Frontend chat interface
- **Metabase** – Dashboards and visualizations

---

## 🧪 4. Demo Data Initialization

As part of the setup, Vero will:

- Import demo data into **PostgreSQL**
- Apply example **Cube.js models and views**
- Prepare a working AI + BI environment

Once the build completes, you'll need to finish setting up Metabase manually.

---

## ✅ 5. Finalize Metabase Setup

1. Open [http://localhost:3000](http://localhost:3000) in your browser.
2. Create an **admin user**.
3. When prompted to connect to a database:

   - Choose **PostgreSQL**
   - Use these values to connect to Cube.js:

     - **Host**: `cubejs`
     - **Port**: `15432`
     - **User**: `user`
     - **Password**: `password`
     - **Database name**: _(any dummy name, e.g., `demodb`)_

> 💡 This "fake" connection is a quirk of Metabase when connecting to Cube.js, which acts like a Postgres proxy.

---

## 🔗 Accessing the Tools

| Tool       | URL                                                                                                                  | Notes                         |
| ---------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| Cube.js    | [http://localhost:4000](http://localhost:4000)                                                                       | Cube Playground               |
| Metabase   | [http://localhost:3000](http://localhost:3000)                                                                       | Final setup required          |
| PostgreSQL | Host: `localhost`<br>Port: `5432`<br>Username: `username`<br>Password: `Nearness4PrincessNext`<br>Database: `demodb` | Accessible via any SQL client |

---

## 🎉 That’s it!

You now have a full-featured, local instance of Vero running — complete with AI querying, semantic modeling, and dashboards.
