FROM python:3.11-slim AS build

WORKDIR /app

# Install necessary build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements files
COPY requirements.txt .
COPY .env /app/.env

# Install dependencies without installing the package itself
RUN pip install --no-cache-dir -r requirements.txt

# Install the project
RUN pip install -r requirements.txt --no-cache-dir

# Default: run Streamlit app on http://localhost:8505/
CMD ["streamlit", "run", "/app/src/app-st.py", \
    "--server.port=8505", \
    "--server.address=0.0.0.0", \
    "--server.enableCORS=true", \
    "--server.enableWebsocketCompression=false"]