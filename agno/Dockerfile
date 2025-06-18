# ============================================================================
# 🐍 Python 3.11 Slim Image — Build Stage
#
# This Dockerfile sets up a lightweight Python 3.11 environment for running
# a Streamlit-based application in development or production.
# ============================================================================

FROM python:3.11-slim AS build

# Set working directory inside the container
WORKDIR /app

# ------------------------------
# 🔧 Install Build Tools & System Dependencies
# ------------------------------

# Install only the minimal necessary build tools (non-interactive mode),
# and clean up package list cache to reduce image size.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------
# 📦 Python Dependencies
# ------------------------------

# Copy dependency definitions and environment config
COPY requirements.txt .
COPY .env /app/.env

# Upgrade pip and install Python packages listed in requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# ------------------------------
# 🚀 Default Startup Command (Streamlit)
# ------------------------------

# This command launches the Streamlit app on port 8505 and allows external access.
CMD ["streamlit", "run", "/app/src/app-st.py", \
    "--server.port=8505", \
    "--server.address=0.0.0.0", \
    "--server.enableCORS=true", \
    "--server.enableWebsocketCompression=false"]