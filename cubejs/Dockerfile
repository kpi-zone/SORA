# ============================================================================
# 🧱 Cube.js Dockerfile — Extended Base Image
#
# This Dockerfile extends the official Cube.js image by installing additional
# tools (e.g., curl) for development, testing, or runtime diagnostics.
# ============================================================================

# Use the official Cube.js image as the base
FROM cubejs/cube:latest

# ------------------------------
# 🔧 Install Utilities
# ------------------------------

# Install curl for health checks, endpoint testing, and diagnostics.
# - apt-get update fetches the latest package index
# - apt-get install installs curl without prompting for user input
# - The layer is kept minimal by omitting unnecessary packages
RUN apt-get update && apt-get install -y curl \
 && rm -rf /var/lib/apt/lists/*
