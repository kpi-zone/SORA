# Use the official Cube.js Docker image as the base
FROM cubejs/cube:latest

# Install curl (used for healthchecks or testing endpoints)
# - apt-get update fetches the latest package list
# - apt-get install -y curl installs curl without interactive prompts
RUN apt-get update && apt-get install -y curl