# ============================================================================
# 🐘 PostgreSQL Dockerfile — Preloaded with SQL and CSV Data
#
# This Dockerfile builds on the official PostgreSQL image and includes:
# - A SQL initialization script
# - Preloaded CSV data for seeding on container startup
#
# ➤ Designed for development, testing, or demo environments
# ============================================================================

# Use the official PostgreSQL base image
FROM postgres:latest

# ------------------------------
# 📁 Create Data Directory
# ------------------------------

# Create a directory inside the container to hold CSV data files
# This is nested under the special entrypoint directory so they’re accessible during init
RUN mkdir -p /docker-entrypoint-initdb.d/data

# ------------------------------
# 📦 Copy Initialization Assets
# ------------------------------

# Copy the main SQL script to initialize schema, tables, etc.
COPY ./init/init.sql /docker-entrypoint-initdb.d/init.sql

# Copy all CSV files into the init data directory
# These can be used in the SQL script with COPY ... FROM statements
COPY ./init/data/*.csv /docker-entrypoint-initdb.d/data/
