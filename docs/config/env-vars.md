# Environment Variables Guide

This guide explains how environment variables are used across the Vero stack, how to configure them for development and production, and what each key variable does. While the `.env.example`files and inline comments provide basic reference, this document adds structure and context.

## Environment Strategy

Vero uses `.env` files to externalize configuration for:

- Container runtime behavior (e.g., ports, API secrets)
- Database connections
- AI model endpoints and credentials

Each service has its own `.env.dev` file and a corresponding `.env.example` for reference. These are passed into the containers via the `env_file` option in `docker-compose.yml`.

> ⚠️ **Important**: Never commit real secrets or production credentials into your `.env` files. Always use `.env.example` as a template.

> 💡 **Note**: The `.env.dev` files are intended **only for local development**. For more mature environments such as **development (dev), quality assurance (QA), or production (prod)**, you should create separate, environment-specific `.env` files for each system.
>
> To create a new environment file, simply copy the corresponding `.env.example` file:
>
> ```bash
> cp cubejs/.env.example cubejs/.env.qa
> cp mcp-server/.env.example mcp-server/.env.prod
> ```
>
> Then adjust the values as needed for your environment.
>
> When running the Vero stack with Docker Compose, you must also provide the root-level .env file. This file contains essential configuration values required at runtime, particularly for starting the MCP server (e.g., MCP_ENDPOINT, MCP_API_SECRET).
>
> ```bash
> docker compose --env-file .env.dev up
> ```

## Key Environment Files

| File                      | Purpose                                                  |
| ------------------------- | -------------------------------------------------------- |
| `.env.dev`                | Central development env file                             |
| `cubejs/.env.dev`         | Config for Cube.js (e.g., DB credentials, port settings) |
| `cubejs/.env.example`     | Template for creating new Cube.js env files              |
| `db/.env.dev`             | PostgreSQL database config                               |
| `db/.env.example`         | Template for PostgreSQL environment setup                |
| `mcp-server/.env.dev`     | AI middleware config (e.g., API key, endpoint)           |
| `mcp-server/.env.example` | Template for creating new MCP server env files           |
| `metabase/.env.dev`       | Metabase runtime configuration                           |
| `metabase/.env.example`   | Template for creating new Metabase env files             |

## Best Practices

- Keep `.env.dev` for local development only
- Use `.env.prod` or a secrets manager (like HashiCorp Vault or AWS SSM) for production
- Add all default keys to `.env.example` and document them here
- Never check in sensitive data (API keys, passwords)

## Overriding Variables

You can override variables by passing them inline before the `docker compose` command:

```bash
CUBEJS_DB_NAME=mydb docker compose up
```

Or by creating `.env.local` and using it with `--env-file`:

```bash
docker compose --env-file .env.local up
```
