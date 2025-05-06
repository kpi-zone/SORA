# app/main.py
import os
import asyncio
import logging
import datetime
import streamlit as st
from dotenv import load_dotenv

# Import your custom MCP streaming client and agent creator
from mcp.client.sse import sse_client
from mcp import ClientSession  
from agents.gemini.cube_agent import create_cube_agent

load_dotenv()

# Configure logging with timestamps, log level, and message.
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
    filename="/app/logs/agent-log.log",
    filemode="a"
)
logger = logging.getLogger(__name__)

# Check required environment variables.
if not os.getenv("OPENAI_API_KEY"):
    logger.error("Missing OpenAI API Key")
    st.stop()

if os.getenv("CUBE_MCP_SERVER_URL"):
    mcp_cube_server = os.getenv("CUBE_MCP_SERVER_URL")
    logger.info("CUBE_MCP_SERVER_URL: " + mcp_cube_server)
else:
    logger.error("Missing Cube MCP Server URL")
    st.stop()

mcp_cube_server="http://mcp-server:9000/sse"

st.set_page_config(page_title="KPI Agent", page_icon="📊")
st.title("📊 The Vero AI-Agent")

st.markdown("✅ App started.")

# Initialize session state keys if they don't exist.
if "counter" not in st.session_state:
    st.session_state["counter"] = 0
if "chat_sessions" not in st.session_state:
    st.session_state["chat_sessions"] = []
if "messages" not in st.session_state:
    st.session_state.messages = [{
        "role": "assistant",
        "content": (
            "Welcome to the Vero AI assistant!\n\n"
            "Here are some example queries to get you started:\n"
            "- How high is the turnover per brand in America?\n"
            "- Which product colour is most popular in america?\n"
            "- Which colour is most popular with women in germany?\n"
        )
    }]
if "chat_archived" not in st.session_state:
    st.session_state.chat_archived = False  # Flag to archive chat only once

def get_chat_name():
    """Extract the first user query (truncated if needed) and combine it with a timestamp."""
    first_user_msg = next((msg["content"] for msg in st.session_state.messages if msg["role"] == "user"), "")
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    if first_user_msg:
        truncated_query = first_user_msg if len(first_user_msg) <= 50 else first_user_msg[:50] + "..."
        return f"Chat on {timestamp} - '{truncated_query}'"
    else:
        return f"Chat on {timestamp}"

# Sidebar: conversation statistics and chat history features.
with st.sidebar:
    st.checkbox("Stream output (required)", value=True, disabled=True)
    st.session_state["counter"] += 1
    st.caption(f"Queries processed: {st.session_state['counter']}")
    st.markdown("---")
    st.header("Chat History")
    
    # "New Chat" button archives the current chat (if there are more than just the default welcome message)
    # and then resets the conversation.
    if st.button("New Chat"):
        if len(st.session_state.messages) > 1:
            if not st.session_state.chat_archived:
                chat_name = get_chat_name()
                st.session_state.chat_sessions.append({
                    "name": chat_name,
                    "messages": st.session_state.messages.copy()
                })
        st.session_state.messages = [{
            "role": "assistant",
            "content": (
                "Welcome to the 📊 KPI assistant!\n\n"
                "Here are some example queries to get you started:\n"
                "- Give me a summary of all accounts?\n"
            )
        }]
        st.session_state.chat_archived = False

    # List recent chats as clickable buttons.
    if st.session_state.chat_sessions:
        st.subheader("Recent Chats")
        for chat in reversed(st.session_state.chat_sessions):
            if st.button(chat["name"]):
                st.session_state.messages = chat["messages"]

# Render the existing chat messages.
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

async def run_query(query: str, placeholder) -> str:
    """
    Runs the asynchronous agent query and streams the response.
    
    Args:
        query (str): The user's query.
        placeholder: The Streamlit placeholder for live updates.
        
    Returns:
        The full response string.
    """
    try:
        async with sse_client(mcp_cube_server) as streams:
            async with ClientSession(streams[0], streams[1]) as session:
                await session.initialize()
                agent = await create_cube_agent(session)
                # Call the agent's method with streaming enabled.
                response_stream = await agent.arun(query, stream=True)
                full_response = ""
                # Stream each incoming chunk and update the placeholder.
                async for chunk in response_stream:
                    full_response += chunk.content
                    placeholder.markdown(full_response + "▌")
                # Final update once streaming is complete.
                placeholder.markdown(full_response)
                return full_response

    except Exception as e:
        logger.error("❌ MCP connection failed.", exc_info=True)
        placeholder.markdown("An error occurred while processing your request.")
        return "An error occurred while processing your request."

# Display the chat input at the bottom.
prompt = st.chat_input("Try one of these example queries or type your own...")

if prompt:
    # Append and display the user message.
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Process the assistant's response.
    with st.chat_message("assistant"):
        assistant_placeholder = st.empty()
        response = asyncio.run(run_query(prompt, assistant_placeholder))
        st.session_state.messages.append({"role": "assistant", "content": response})
    
    # Immediately archive the conversation after the first assistant response,
    # if it hasn't been archived yet.
    if len(st.session_state.messages) > 1 and not st.session_state.chat_archived:
        chat_name = get_chat_name()
        st.session_state.chat_sessions.append({
            "name": chat_name,
            "messages": st.session_state.messages.copy()
        })
        st.session_state.chat_archived = True

st.markdown("---")
st.caption("Built with ❤️ and Ango.")
