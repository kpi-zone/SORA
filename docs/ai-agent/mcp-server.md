# MCP Server: AI Agent Backend in Vero

The MCP Server is the **AI orchestration layer** in the Vero architecture. It enables natural language querying of data through Cube.js, acting as a bridge between the user-facing AI agent (Agno) and the structured data exposed by Cube’s semantic models.

This service is based on the open-source project [mcp_cube_server](https://github.com/isaacwasserman/mcp_cube_server), designed to comply with the **Model Context Protocol (MCP)** — a standard for integrating AI agents with external tools and structured data services.

> In the Vero setup, the MCP Server is **slightly adapted** to run within a Docker container and support **Server-Sent Events (SSE)**. This enables seamless communication with the Agno AI agent frontend, allowing real-time, streamable responses from AI-generated queries.

## What Is an MCP Server?

An **MCP server** in the agentic AI context is a protocol-compliant service that acts as a bridge between AI agents (e.g., LLMs with tool-use capabilities) and structured data or actions in external systems.

### Key Features

- **Standardized Interface:** Advertises available tools/resources for use by AI agents
- **Tool Access:** Interfaces with Cube.js, returning structured data and metadata

## Architecture Role in Vero

MCP Server connects these components:

```bash
User → Agno (chat UI) → MCP Server → Cube.js → PostgreSQL → Results
```

## Based on: `mcp_cube_server`

GitHub: [isaacwasserman/mcp_cube_server](https://github.com/isaacwasserman/mcp_cube_server)

### 📁 Key Resources Exposed

| Resource                     | Description                                                      |
| ---------------------------- | ---------------------------------------------------------------- |
| `context://data_description` | Describes the data available in Cube (semantic model + metadata) |
| `data://{data_id}`           | Contains the actual result of a `read_data` call in JSON format  |

### 🛠️ Key Tools Provided

| Tool            | Purpose                                                                                |
| --------------- | -------------------------------------------------------------------------------------- |
| `read_data`     | Accepts a Cube.js-compatible query and returns YAML + a data ID                        |
| `describe_data` | Returns a machine-readable description of the semantic model (similar to `context://`) |

> These tools are used by AI agents to discover what data is available, query it, and retrieve results — without needing any manual SQL writing.

## Docker Setup

```yaml
mcp-server:
  build:
    context: ./mcp-server
  ports:
    - "9000:9000"
  env_file:
    - ./mcp-server/.env.dev
  command:
    - --endpoint
    - ${MCP_ENDPOINT}
    - --api_secret
    - ${MCP_API_SECRET}
```

### Environment Variables (`.env.dev`)

```env
MCP_ENDPOINT=http://cubejs:4000
MCP_API_SECRET=secret123
```

- Points to Cube.js backend (REST API)
- Secures access with a shared secret

The MCP Server is your gateway to enabling AI-powered, explainable, and auditable access to business KPIs and data. It’s a lightweight but powerful way to make your semantic models usable by a new generation of LLM-enabled tools and users.
