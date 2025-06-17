# Docker & Compose Configuration for Vero

This document explains how Docker and Docker Compose are used to orchestrate the full Vero analytics stack. It complements the inline comments in `docker-compose.yml` and helps you understand the purpose of each container, how the services communicate, and how to troubleshoot or modify the setup.

## Architecture Overview

The Docker Compose setup includes the following core services:

| Service     | Role                            | Port(s)             |
| ----------- | ------------------------------- | ------------------- |
| Cube.js     | Semantic layer & API            | 4000, 15432         |
| PostgreSQL  | Central data warehouse          | 5432                |
| MCP Server  | AI agent backend/API middleware | 9000                |
| Metabase    | BI dashboards & visualization   | 3000                |
| Metabase-DB | Internal database for Metabase  | 5433 (maps to 5432) |
| n8n         | Agentic AI Workflow Engine      | 5678                |
| n8n-db      | PostgreSQL for n8n              | internal only       |
| NGINX Proxy | Service Router (local/prod)     | 80, 443             |
| ACME Helper | TLS certificate management      | N/A                 |

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

### `data-warehouse` (PostgreSQL)

- **Image**: `postgres:16`
- **Purpose**: Stores ingested and modeled data, queried by Cube.js.
- **Volumes**: `data-warehouse-db-data`
- **Port**: `5432`

### `mcp-server`

- **Purpose**: Handles AI agent requests, translating natural language to structured queries using Cube.js metadata.
- **Build**: Custom Python server via `hatchling`
- **Port**: `9000`

### `metabase`

- **Image**: `stephaneturquay/metabase-arm64:latest`
- **Purpose**: Web UI for exploring data and building dashboards
- **Volume**: `metabase-data`
- **Depends on**: `metabase-db`
- **Port**: `3000`

### `metabase-db`

- **Image**: `postgres:13`
- **Volume**: `metabase-db-data`
- **Port mapping**: `5433:5432`

### `agno`

- **Purpose**: AI frontend interface (Streamlit-based)
- **Port**: `8505`
- **Volumes**: source code and logs mounted for local dev

### `n8n`

- **Image**: `n8nio/n8n:latest`
- **Purpose**: Automates workflows from AI outputs and triggers
- **Volumes**: `n8n-data`
- **Port**: `5678`
- **Healthcheck**: `/healthz` endpoint

### `n8n_db`

- **Image**: `postgres:15`
- **Purpose**: Persistent DB for n8n workflows
- **Volumes**: `n8n-db-data`

### `nginx`

- **Image**: `nginxproxy/nginx-proxy`
- **Purpose**: Reverse proxy to all services via subdomain routing (e.g., `cubejs.localhost`, `metabase.localhost`)
- **Ports**: `80`, `443`

### `letsencrypt`

- **Image**: `nginxproxy/acme-companion`
- **Purpose**: Automatically issues TLS certs from Let's Encrypt
- **Used in production** only

------

## Networking

All services are connected via the `vero` Docker bridge network. This allows containers to resolve each other by service name (e.g., `cubejs`, `postgres`, `mcp-server`).

------

## Volumes

| Volume Name        | Purpose                          |
| ------------------ | -------------------------------- |
| `db-data`          | PostgreSQL data for Cube.js      |
| `metabase-db-data` | PostgreSQL metadata for Metabase |
| `metabase-data`    | Application config and user data |
| `n8n-data`         | n8n configuration and workflows  |
| `n8n-db-data`      | Database for n8n                 |

------

## Environment Files & Modes

### Environment Files

Each service uses an external environment file (referenced via `env_file:`):

- `CUBEJS_ENV_FILE` → `./cubejs/.env.dev` (or `.env.prod`)
- `METABASE_ENV_FILE` → `./metabase/.env.dev`
- `MCP_ENV_FILE` → `./mcp-server/.env.dev`
- `AGNO_ENV_FILE` → `./agno/.env.dev`
- `N8N_ENV_FILE` → `./n8n/.env.dev`

> **Tip**: Use the provided `.env.example` files to generate your actual `.env.dev` or `.env.prod` files.
> Example: `cp ./n8n/.env.example ./n8n/.env.dev`

### Switching Environments

```bash
# Development
docker compose --env-file .env.dev -f docker-compose.yaml up --build

# Production
docker compose --env-file .env.prod -f docker-compose.yaml up --build
```

------

## NGINX Proxy & HTTPS (Production vs Development)

### Development Mode (HTTP only)

Uses only `nginxproxy/nginx-proxy`.

- No TLS required
- No public DNS needed

### Production Mode (with HTTPS)

Adds `nginxproxy/acme-companion`:

- Requires valid public domain (e.g., `vero.example.com`)
- Automatically fetches Let's Encrypt certificates

Ensure you set:

```env
LETSENCRYPT_HOST=your.domain.com
LETSENCRYPT_EMAIL=you@domain.com
```

------

## Custom NGINX Overrides

For advanced customization, create override configs in:

```bash
./nginx/vhost.d/<service>.conf
```

Example for `n8n.localhost`:

```nginx
location / {
  proxy_pass http://n8n:5678;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
}
```

------

## Localhost Access (DNS Mapping)

Add these lines to your local `hosts` file to access services via domain names:

### On macOS or Linux

Edit `/etc/hosts` (requires `sudo`):

```bash
127.0.0.1 cubejs.localhost
127.0.0.1 metabase.localhost
127.0.0.1 n8n.localhost
```

### On Windows

Edit `C:\Windows\System32\drivers\etc\hosts` as Administrator:

```bash
127.0.0.1 cubejs.localhost
127.0.0.1 metabase.localhost
127.0.0.1 n8n.localhost
```

------

## Common Docker Commands

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