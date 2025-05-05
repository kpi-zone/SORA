FROM postgres:latest

# Create import directory inside container
RUN mkdir -p /docker-entrypoint-initdb.d/data

# Copy init script and data
COPY ./init/init.sql /docker-entrypoint-initdb.d/init.sql
COPY ./init/data/*.csv /docker-entrypoint-initdb.d/data/