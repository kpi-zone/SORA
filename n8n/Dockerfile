# Use the official n8n Docker image as the base
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install curl using Alpine's apk package manager
RUN apk update && apk add --no-cache curl

# Switch back to the default node user
USER node