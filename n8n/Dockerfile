# ============================================================================
# 🧪 Dockerfile — Custom n8n Runtime with curl
#
# Extends the official n8n image to include curl for development,
# debugging, or health checks.
# ============================================================================

# Use the official n8n image as the base
FROM n8nio/n8n:latest

# ------------------------------
# ⚙️ Install Additional Tools (as root)
# ------------------------------

# Switch to root user to install system packages
USER root

# Install curl using Alpine's package manager
# - `--no-cache` prevents writing package index to disk
# - `apk update` ensures latest package info
RUN apk update && apk add --no-cache curl

# ------------------------------
# 🔐 Revert to Non-Privileged User
# ------------------------------

# Return to the default non-root 'node' user for security
USER node
