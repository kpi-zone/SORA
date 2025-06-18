# n8n: Agentic Workflow Automation in Vero

n8n is the **workflow automation engine** in the Vero stack. It enables both technical and non-technical users to create powerful, agent-driven data pipelines, automations, and integrations — with minimal code.

()
![n8n](/docs/images/n8n.png "n8n Overview")

In Vero, n8n acts as the orchestration layer for agentic AI workflows, triggered by events, schedules, or direct user input.

> 🔗 [n8n GitHub](https://github.com/n8n-io/n8n)
> 📚 [Documentation](https://docs.n8n.io/)
> 🔧 [400+ Integrations](https://n8n.io/integrations)
> 💡 [Example Workflows](https://n8n.io/workflows)
> 🤖 [AI & LangChain Guide](https://docs.n8n.io/langchain/)
> 👥 [Community Forum](https://community.n8n.io/)
> 📖 [Community Tutorials](https://community.n8n.io/c/tutorials/28)

## Role of n8n in Vero

n8n serves as:

- An **AI automation engine** for orchestrating agents and tasks
- A **visual workflow builder** with support for hundreds of integrations
- A bridge between **MCP**, **Agno**, and external APIs, databases, and services

With n8n, you can:

- Trigger workflows based on events, time, or user input
- Automate multi-step agent interactions
- Connect Vero agents to external systems (e.g., Slack, Airtable, CRMs)
- Visually monitor, debug, and iterate on automations

## Setup & Configuration

n8n is included in the Vero Docker environment. It runs at:

```bash
http://n8n.localhost
```

By default, it is configured to run behind an **NGINX reverse proxy**, with optional **Let's Encrypt SSL** support for production deployments.

Environment variables are defined in:

```bash
n8n/.env.dev        # Runtime config
n8n/.env.example    # Template for new environments
```

The `.env.example` file includes:

- `VIRTUAL_HOST` — hostname used for reverse proxy routing
- `LETSENCRYPT_HOST` — optional, enables HTTPS via Let's Encrypt
- `LETSENCRYPT_EMAIL` — email used for certificate issuance

### Example Configuration:

```env
VIRTUAL_HOST=n8n.yourdomain.com
LETSENCRYPT_HOST=n8n.yourdomain.com
LETSENCRYPT_EMAIL=admin@yourdomain.com
```

> ⚠️ Make sure your domain is correctly pointed to the server running Vero, and that ports 80/443 are open for Let's Encrypt validation.

## First-Time Setup

When you open n8n for the first time:

1. **Create an owner account** with your email and password
2. **Verify your email** to unlock access to additional free features
3. You’ll receive a **license key** via email — follow the link and enter your key in the UI

> n8n runs in “multi-user mode” by default in Vero. All configuration is persisted via Docker volume `n8n-data`.

## 📁 Folder Structure

```bash
n8n/
├── .env.dev          # Runtime configuration
├── .env.example      # Reference template
```

Workflow data and credentials are stored in the `n8n-data` Docker volume for persistence across restarts.

## Using n8n in Vero

n8n workflows can:

- Call the MCP AI Server for language model queries
- Invoke the Agno frontend agent for interactive chat experiences
- Trigger custom logic, webhooks, and external tools
- Integrate with over 300+ built-in services and APIs

> Example: You can create a workflow that monitors a shared inbox, routes queries to the MCP server, then posts summarized responses to Slack — all without writing backend code.

## Production Deployment Notes

When running Vero in production:

- n8n is secured behind **NGINX** with automated HTTPS via **nginx-proxy** and **Let's Encrypt**
- The hostname must be set via `VIRTUAL_HOST` in the environment file
- SSL is enabled by including both `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL`
- You’ll need to create a custom **virtual host configuration file** for n8n:

```bash
nginx/vhost.d/n8n.yourdomain.com
```

Or simply rename the existing template file in `nginx/vhost.d/` to match your domain.
This setup ensures your n8n instance is both accessible and encrypted without manual certificate management.

> 📁 **vhost.d/** contains per-domain NGINX configuration overrides. You can define custom headers, proxy settings, or security policies per service.

## Admin Features

n8n provides:

- Role-based user management
- Encrypted credential storage
- Workflow execution logs and visual tracing
- Support for self-hosted or cloud deployment
- Community and enterprise plugins for advanced use cases

For advanced usage, check out the full n8n documentation or the [GitHub repo](https://github.com/n8n-io/n8n).