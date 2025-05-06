# Agno AI Agent: Natural Language Access to Cube.js in Vero

![Verno AI Agent](/docs/images/ai-agent.gif "erno AI Agent")

The **Agno AI Agent** is Vero's natural language interface, enabling users to ask business-related data questions conversationally — powered by an LLM and structured knowledge from Cube.js. It's built on top of the open-source [Agno AI Agent framework](https://github.com/agno-agi/agno), designed for LLM-agent interoperability.

> 📘 Framework Docs: [Agno Documentation](https://docs.agno.com/introduction)

## MVP Status: Proof of Work

> **This implementation is an MVP** designed to **illustrate interoperability** between:
>
> - [Cube.js](https://cube.dev) (semantic data modeling),
> - an [MCP Server](https://github.com/isaacwasserman/mcp_cube_server) (tool interface for agents), and
> - the [Agno Agent framework](https://docs.agno.com) (LLM-based reasoning and query execution).
>
> The goal is to demonstrate how **natural language interaction** can be layered over your data stack — with full transparency and control — using open, modular building blocks.

This MVP provides:

- A reference implementation of how to build a semantic-aware LLM agent pipeline
- A hands-on example of how to query Cube.js using metadata, not brittle SQL
- A foundation for extending to more sophisticated agents, use cases, and models

## Purpose and Architecture

In this MVP, a simple Streamlit-based chat UI is used to:

1. Accept user input in natural language
2. Pass that input to an agent
3. Use an LLM (OpenAI GPT-4 by default) to interpret the intent
4. Query Cube.js via an MCP server to fetch relevant data
5. Return and display results as chat responses

The agent uses Cube metadata — measures, dimensions, joins — to construct valid, semantically aligned queries using Cube’s SQL API.

## How It Works

- The agent is implemented using **Agno**, which supports modular, skill-based agents.
- A dedicated agent skill (`cube_agent`) is configured to:

  - Retrieve Cube metadata via MCP server (`/sse` endpoint)
  - Plan step-by-step execution for metadata lookup and query building
  - Generate a valid Cube-compatible query
  - Return the structured results to the frontend UI

> The agent logic lives in `src/agents/gemini/cube_agent.py` (or other variants for different models).

## 🤖 Default LLM: GPT-4

The default LLM configured in the MVP is **OpenAI Chat GPT-4**. You must provide an OpenAI API key to run the agent.

### Required `.env` Variable:

```
OPENAI_API_KEY=your-openai-key-here
```

Set this in the `.env.dev` file or inject it into your container via Docker Compose.

> Never hardcode secrets in source files. Use `.env` or a secrets manager.

## Using Other LLMs (Optional)

The Agno agent framework supports many LLM providers. To switch:

1. Refer to the [Agno model documentation](https://docs.agno.com/models/introduction)
2. Replace the model in `cube_agent.py` with your desired LLM:

   - Options include **DeepSeek**, **Grok**, **Gemini**, **Claude**, and others

3. Update your `.env` file with the appropriate API key and model config

> Example (for Gemini):

```python

export GOOGLE_GENAI_USE_VERTEXAI="true"
export GOOGLE_CLOUD_PROJECT="your-gcloud-project-id"
export GOOGLE_CLOUD_LOCATION="your-gcloud-location"

agent = Agent(
    model=Gemini(
        id="gemini-1.5-flash",
        vertexai=True,
        project_id="your-gcloud-project-id",
        location="your-gcloud-location",
    ),
)
```

## Frontend: Streamlit Chat Interface

- Located at: `src/app-st.py`
- UI Features:

  - Chat history
  - Message archiving and reuse
  - Live streaming of agent responses via SSE

> All chat input is passed to the cube-aware agent, which returns structured results directly from the Cube semantic layer.

## Cube + MCP Integration

The agent uses the **MCP server** as a bridge between the LLM agent and Cube.js:

- Metadata is accessed via `describe_data`
- Queries are constructed and sent via `read_data`

This allows the LLM agent to understand your Cube schema without being hardcoded to SQL or DB schemas directly.

## Development Notes

- The app must be run inside Docker (see Quickstart docs)
- Ensure that the MCP server and Cube.js are up and reachable by the agent
- Logs are written to `/app/logs/agent-log.log` (mount this via Docker volume)
- `PYTHONPATH=/app/src` must be set so Python can find `mcp` and `agents`

For full setup and integration instructions, see the Vero [Quickstart](../quickstart.md) and [AI Layer docs](../ai/mcp-server.md).
