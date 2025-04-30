# ---------------------------------------------------------------------
# Base Image
# Use the official Superset image as the starting point.
# This includes all dependencies needed to run Superset.
# ---------------------------------------------------------------------
FROM apache/superset:latest

# ---------------------------------------------------------------------
# Switch to root user temporarily
# This is required to install additional Python packages system-wide.
# ---------------------------------------------------------------------
USER root

# ---------------------------------------------------------------------
# Install extra Python packages
# - flask-cors: Enables CORS support (used in custom Superset setups)
# - Pillow: Required for screenshots, image thumbnails, PDF export, etc.
# --no-cache-dir: prevents pip from storing download caches (saves space)
# ---------------------------------------------------------------------
RUN pip install --no-cache-dir flask-cors Pillow psycopg2-binary

# ---------------------------------------------------------------------
# Return to the non-root user 'superset'
# Superset runs as this user by default for security reasons.
# ---------------------------------------------------------------------
USER superset

# ---------------------------------------------------------------------
# Copy preconfigured data source YAML into the container
# This file can be used with `superset import-datasources` at startup
# ---------------------------------------------------------------------
COPY datasources.yaml /app/superset/datasources.yaml
    