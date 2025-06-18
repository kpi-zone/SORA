# ============================================================================
# 🐍 Python 3.11 Slim Dockerfile — MCP Cube Server
#
# This Dockerfile builds and runs a Python project using PEP 517/518 tooling 
# (`pyproject.toml`) with Hatchling, packaged into a minimal container.
# ============================================================================

# Use the official Python 3.11 slim image as base
FROM python:3.11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# ------------------------------
# 🔧 Install Build Dependencies
# ------------------------------

# Install minimal build tools required for compilation (e.g., native extensions)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# ------------------------------
# 📦 Dependency Installation
# ------------------------------

# Copy the project metadata file used by modern Python build tools
COPY pyproject.toml /app/

# Upgrade pip and install hatchling (PEP 517 build backend)
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir hatchling

# ------------------------------
# 🧱 Application Code & Installation
# ------------------------------

# Copy the source code (assumes structure like src/your_package/)
COPY src /app/src

# Install the project locally into the environment
RUN pip install --no-cache-dir /app

# ------------------------------
# 🚀 Runtime Entry Point
# ------------------------------

# Run the installed command-line entry point defined in pyproject.toml
ENTRYPOINT ["mcp_cube_server"]
