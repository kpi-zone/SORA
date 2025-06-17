# Vero Quickstart Guide

This guide walks you through setting up **Vero** on your local machine using Docker. In just a few minutes, you’ll have the full analytics stack — including Airbyte, PostgreSQL, Cube.js, the AI Agent, and Metabase — up and running with demo data and models.

## Prerequisites

- [Git](https://git-scm.com/downloads)
- [Docker + Docker Compose](https://docs.docker.com/get-docker/)

## ⚠️ Before You Start: Set Your OpenAI API Key

To enable the AI Agent in Vero (powered by the [Agno AI Framework](https://docs.agno.com)), you must provide a valid OpenAI API key. This allows the agent to process natural language questions and query Cube.js semantically.

1. Create a new `.env` file based on the `.env.example` in in the agno folder.

2. Add your OpenAI API key like so:

   ```
   OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

3. You can obtain an API key at [OpenAI’s platform](https://platform.openai.com/account/api-keys).

4. Optional: To use alternative LLMs like **DeepSeek**, **Grok**, or **Gemini**, follow the [Agno model configuration guide](https://docs.agno.com/models/introduction) and update the model in `src/agents/gemini/cube_agent.py`.

## 1. Clone the Vero Repository

```bash
git clone https://github.com/kpi-zone/Vero.git
cd Vero
```

## 2. Choose the Right Docker Compose File

Vero supports two versions of the Docker Compose configuration.

These two versions are necessary because the default Metabase image (metabase/metabase:latest) does not support ARM64 architecture out-of-the-box. If you're running Vero on an ARM64 machine (like Apple Silicon), you'll need a compatible image to ensure Metabase starts correctly.

| File                        | Description                                                            |
| --------------------------- | ---------------------------------------------------------------------- |
| `docker-compose.yaml`       | Default version for most x86_64 environments                           |
| `docker-compose.arm64.yaml` | Special version for ARM-based systems like Apple Silicon (M1/M2 chips) |

### How to Check Your Architecture

Run this command:

```bash
uname -m
```

- `x86_64` → Use `docker-compose.yaml`
- `arm64` → Use `docker-compose.arm64.yaml`

### Example Usage:

```bash
# For x86_64:
docker compose --env-file .env.dev -f docker-compose.yaml up --build

# For ARM64 (Apple Silicon):
docker compose --env-file .env.dev -f docker-compose.arm64.yaml up --build
```

> This uses `.env.dev` to load development environment variables.
> For production or custom environments, point to a different `.env` file.

## 3. Configure Your Hosts File

To use custom domains like `n8n.localhost`, `metabase.localhost`, and `cubejs.localhost`, you must map them to `127.0.0.1`.

### 🔧 On macOS / Linux

Run:

```
sudo nano /etc/hosts
```

Add:

```
127.0.0.1 cubejs.localhost
127.0.0.1 n8n.localhost
127.0.0.1 metabase.localhost
```

Then save (`Ctrl+O`, `Enter`, then `Ctrl+X` to exit).

### 🪟 On Windows

1. Open Notepad as Administrator
2. Open file: `C:\Windows\System32\drivers\etc\hosts`
3. Add:

```
127.0.0.1 cubejs.localhost
127.0.0.1 n8n.localhost
127.0.0.1 metabase.localhost
```

4. Save the file and restart your browser or `nginx-proxy`.

### 💡 Tip: Environment File Management

> This uses `.env.dev` to load development environment variables.
> For production or custom environments, point to a different `.env` file.

You can use multiple environment files like:

```
# Development
docker compose --env-file .env.dev -f docker-compose.yaml up --build

# Production
docker compose --env-file .env.prod -f docker-compose.yaml up --build
```

#### 🗂 .env.example Files

Each major component (e.g., `n8n`, `metabase`, `agno`) includes a corresponding `.env.example` file.
Use these as a template to create your real environment config:

```
cp ./n8n/.env.example ./n8n/.env.dev
```

Customize values inside as needed — especially ports, credentials, hostnames, and tokens.

------

### 🌐 Custom Per-Domain NGINX Configuration

If you want to override the default proxy behavior for any domain, you can:

- Create a file under `nginx/vhost.d/<yourdomain>.conf`
- Add custom `location` blocks, headers, or SSL options

Example:

```
# ========================================================================
# 📊 NGINX Proxy Configuration for Cube.js
#
# This configuration enables reverse proxy support for Cube.js,
# including handling large requests and WebSocket connections.
#
# ========================================================================

# Allow large POST payloads (e.g., queries with complex filters or data)
client_max_body_size 50m;

# Use HTTP/1.1 to support WebSockets and persistent connections
proxy_http_version 1.1;

# WebSocket headers for real-time query streaming or subscriptions
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";

# Preserve original request headers for logging and upstream context
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

```

These will be automatically picked up by `nginx-proxy`.

## 4. What Gets Built

During the build process, Docker sets up all key components of the [Vero architecture](./architecture.md):

- **Airbyte** – Data ingestion
- **PostgreSQL** – Central data warehouse
- **Cube.js** – Semantic modeling layer
- **MCP AI Server** – Natural language query engine
- **Agno AI Agent** – Frontend chat interface
- **n8n** – Agentic AI Workflow automation
- **Metabase** – Dashboards and visualizations

## 5. Demo Data Initialization

As part of the setup, Vero will:

- Import demo data into **PostgreSQL**
- Apply example **Cube.js models and views**
- Prepare a working AI + BI environment

Once the build completes, you'll need to finish setting up Metabase manually.

## 6. Finalize Metabase Setup

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

> This "fake" connection is a quirk of Metabase when connecting to Cube.js, which acts like a Postgres proxy.

## Accessing the Tools


| Tool       | URL                                                     | Notes                   |
| ---------- | ------------------------------------------------------- | ----------------------- |
| Cube.js    | [http://cubejs.localhost](http://cubejs.localhost/)     | Cube Playground         |
| Metabase   | [http://metabase.localhost](http://metabase.localhost/) | Setup required          |
| n8n        | [http://n8n.localhost](http://n8n.localhost/)           | Requires login          |
| MCP Server | [http://localhost:9000](http://localhost:9000/)         | AI backend API          |
| Agno Agent | [http://localhost:8505](http://localhost:8505/)         | Chat frontend           |
| Postgres   | `localhost:5432`, user: `user`                          | For dev database access |

## That’s it!

You now have a full-featured, local instance of Vero running — complete with AI querying, semantic modeling, and dashboards.
