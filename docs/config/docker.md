# Docker & Compose Configuration for Vero

This document explains how Docker and Docker Compose are used to orchestrate the full Vero analytics stack. It complements the inline comments in `docker-compose.yml` and helps you understand the purpose of each container, how the services communicate, and how to troubleshoot or modify the setup.

## Architecture Overview

The Docker Compose setup includes the following core services:

| Service     | Role                            | Port(s)             |
| ----------- | ------------------------------- | ------------------- |
| Cube.js     | Semantic layer & API            | 4000, 15432         |
| PostgreSQL  | Central data warehouse          | 5432                |
| MCP Server  | AI agent backend/API middleware | 8000                |
| Metabase    | BI dashboards & visualization   | 3000                |
| Metabase-DB | Internal database for Metabase  | 5433 (maps to 5432) |

All services share the `vero` network for internal communication and use named volumes for persistent data.

## Service Overview

### `cubejs`

- **Image**: `cubejs/cube:latest`
- **Purpose**: Hosts the semantic modeling layer for KPIs, exposes REST and PostgreSQL-compatible endpoints.
- **Volumes**:
  - `./cubejs/model` for schema definitions
  - `./cubejs/views` for view-layer logic
- **Ports**:
  - `4000`: Cube.js Playground & API
  - `15432`: SQL wire protocol (for Metabase)
- **Healthcheck**: Uses `curl` to verify readiness

### `postgres`

- **Image**: `postgres:latest`
- **Purpose**: Stores ingested and modeled data, queried by Cube.js.
- **Init Logic**: Custom `init.sql` and CSV files are loaded via the Dockerfile.
- **Volumes**:
  - `db-data`: Ensures persistence across restarts
- **Port**: `5432`

### `mcp-server`

- **Purpose**: Handles AI agent requests, translating natural language to structured queries using Cube.js metadata.
- **Custom Build**: Uses a `python:3.11-slim` base image, installs via `hatchling`, and runs a custom Python app.
- **Command-line args**:
  - `--endpoint`, `--api_secret` (injected via `.env.dev` or Compose env)
- **Port**: `8000`

### `metabase`

- **Image**: Community ARM64-compatible image (`stephaneturquay/metabase-arm64`)
- **Purpose**: Web UI for exploring data and building dashboards
- **Volume**: `metabase-data` for persisted Metabase state
- **Depends on**: `metabase-db` service for internal storage
- **Port**: `3000`

### `metabase-db`

- **Image**: `postgres:13`
- **Purpose**: Internal metadata database for Metabase
- **Volume**: `metabase-db-data`
- **Healthcheck**: Uses `pg_isready` to confirm readiness
- **Port mapping**: Host port `5433` → container port `5432`

## Docker Networking

All services are connected via the `vero` Docker bridge network. This allows containers to resolve each other by service name (e.g., `cubejs`, `postgres`, `mcp-server`).

---

## Volumes

| Volume Name        | Purpose                               |
| ------------------ | ------------------------------------- |
| `db-data`          | Persist PostgreSQL data               |
| `metabase-db-data` | Persist Metabase internal DB state    |
| `metabase-data`    | Persist Metabase UI state and configs |

Volumes are declared at the bottom of `docker-compose.yml` and mounted individually per service.

## Tips & Troubleshooting

- **Port Conflicts**: Make sure ports `3000`, `4000`, `5432`, `5433`, and `8000` are free
- **Data Reinitialization**: To reset demo data, delete named volumes with `docker volume rm`
- **Build Failures**: Use `--no-cache` or inspect logs with `docker compose logs`
- **Healthcheck Failures**: Ensure dependencies are met (e.g., `cubejs` waits on `postgres`)

## For Production

- Replace `.env.dev` files with `.env.prod` or secure secrets managers
- Use persistent external storage for databases
- Harden containers (e.g., non-root users, TLS termination)
- Add Docker Compose overrides or K8s manifests if scaling is required

## Common Docker Commands

Here are some useful Docker Compose commands you can use while working with Vero:

### Start Services

```bash
docker compose --env-file .env.dev up --build
```

### Stop Services

```bash
docker compose down
```

### View Logs

```bash
docker compose logs -f
```

### Restart a Specific Service

```bash
docker compose restart <service-name>
```

### Remove All Containers, Networks, and Volumes

```bash
docker compose down -v
```

### Prune All Unused Docker Resources

```bash
docker system prune -a
```
