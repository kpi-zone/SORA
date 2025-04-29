FROM python:3.11-slim AS build

WORKDIR /app

# Install necessary build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy the project files
COPY pyproject.toml /app/

# Install dependencies without installing the package itself
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir hatchling

# Copy the source code
COPY src /app/src

# Install the project
RUN pip install --no-cache-dir /app

# Run the server
ENTRYPOINT ["mcp_cube_server"]
