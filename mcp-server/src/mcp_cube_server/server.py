from __future__ import annotations
from typing import Annotated, Any, Literal, Optional, Union
from mcp.server.fastmcp import FastMCP
from mcp.types import TextContent, EmbeddedResource, TextResourceContents
import jwt
from pydantic import BaseModel, Field
import requests
import json
import logging
import yaml
import uuid
import time
import os

# Set the log level to INFO by default; can be overridden with the LOG_LEVEL env variable.
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
numeric_level = getattr(logging, log_level, logging.INFO)
logging.basicConfig(level=numeric_level)

def data_to_yaml(data: Any) -> str:
    logging.info("Converting data to YAML format")
    return yaml.dump(data, indent=2, sort_keys=False)


class CubeClient:
    Route = Literal["meta", "load"]
    max_wait_time = 10
    request_backoff = 1

    def __init__(self, endpoint: str, api_secret: str, token_payload: dict, logger: logging.Logger):
        self.endpoint = endpoint
        self.api_secret = api_secret
        self.token_payload = token_payload
        self.token = None
        self.logger = logger
        self.logger.info("Initializing CubeClient with endpoint: %s", self.endpoint)
        self._refresh_token()
        self.meta = self.describe()  # Calling describe during initialization
        self.logger.info("CubeClient initialized successfully. Meta data loaded.")

    def _generate_token(self):
        self.logger.info("Generating token using token payload: %s", self.token_payload)
        token = jwt.encode(self.token_payload, self.api_secret, algorithm="HS256")
        self.logger.info("Token generated successfully")
        return token

    def _refresh_token(self):
        self.logger.info("Refreshing token")
        self.token = self._generate_token()
        self.logger.info("Token refresh complete")

    def _request(self, route: CubeClient.Route, **params):
        request_time = time.time()
        self.logger.info("Starting request to route: %s with params: %s", route, params)
        headers = {"Authorization": self.token}
        endpoint = self.endpoint[:-1] if self.endpoint.endswith('/') else self.endpoint
        url = f"{endpoint}/{route}"
        self.logger.info("Constructed URL for request: %s", url)
        serialized_params = {k: json.dumps(v) for k, v in params.items()}
        self.logger.info("Serialized params for request: %s", serialized_params)

        try:
            response = requests.get(url, headers=headers, params=serialized_params)
            self.logger.info("Initial request sent. Status code: %s", response.status_code)
            json_response = response.json()
            self.logger.info("Initial response JSON: %s", json_response)

            # Handle "continue wait" responses
            while json_response.get("error") == "Continue wait":
                elapsed = time.time() - request_time
                if elapsed > self.max_wait_time:
                    self.logger.error("Request timed out after %s seconds", self.max_wait_time)
                    return {"error": "Request timed out. Something may have gone wrong or the request may be too complex."}
                self.logger.info("Request incomplete (elapsed %.2f seconds), polling again in %s second(s)", elapsed, self.request_backoff)
                time.sleep(self.request_backoff)
                response = requests.get(url, headers=headers, params=serialized_params)
                self.logger.info("Polling request sent. Status code: %s", response.status_code)
                json_response = response.json()
                self.logger.info("Polling response JSON: %s", json_response)

            # Handle 403 responses by trying to refresh the token once
            if response.status_code == 403:
                self.logger.info("Received 403 response, attempting token refresh")
                self._refresh_token()
                response = requests.get(url, headers={"Authorization": self.token}, params=serialized_params)
                self.logger.info("Retried request after token refresh. Status code: %s", response.status_code)
                json_response = response.json()
                self.logger.info("Response JSON after token refresh: %s", json_response)

            # Log non-200 statuses
            if response.status_code != 200:
                error_message = str(json_response.get("error"))
                self.logger.error("Request failed with non-200 status. Error: %s", error_message)

            self.logger.info("Request successful. Total time: %.2f seconds", time.time() - request_time)
            return json_response

        except Exception as e:
            self.logger.exception("Exception during request: %s", str(e))
            return {"error": f"Request failed: {str(e)}"}

    def describe(self):
        self.logger.info("Calling describe to retrieve metadata")
        meta = self._request("meta")
        self.logger.info("Describe returned metadata: %s", meta)
        return meta

    def _cast_numerics(self, response):
        self.logger.info("Attempting to cast numeric fields for response: %s", response)
        if response.get("data") and response.get("annotation"):
            # Identify numeric keys
            numeric_keys = set()
            dimensions = response["annotation"].get("dimensions", {})
            measures = response["annotation"].get("measures", {})
            dimensions_and_measures = {**dimensions, **measures}
            for column_name, column in dimensions_and_measures.items():
                if column.get("type") == "number":
                    numeric_keys.add(column_name)
                    self.logger.info("Identified numeric key: %s", column_name)
            # Cast numeric values to appropriate types
            for row in response["data"]:
                for key in numeric_keys:
                    try:
                        original = row.get(key)
                        row[key] = float(row[key])
                        # Convert to int if whole number
                        if row[key].is_integer():
                            row[key] = int(row[key])
                        self.logger.info("Casted %s from %s to %s", key, original, row[key])
                    except (ValueError, TypeError):
                        self.logger.info("Could not cast key: %s with value: %s", key, row.get(key))
        return response

    def query(self, query, cast_numerics=True):
        self.logger.info("Executing query: %s", query)
        response = self._request("load", query=query)
        self.logger.info("Query response before casting numerics: %s", response)
        if cast_numerics:
            response = self._cast_numerics(response)
            self.logger.info("Query response after casting numerics: %s", response)
        self.logger.info("Query completed")
        return response


class Filter(BaseModel):
    dimension: str = Field(..., description="Name of the time dimension")
    granularity: Literal["second", "minute", "hour", "day", "week", "month", "quarter", "year"] = Field(
        ..., description="Time granularity"
    )
    dateRange: Union[list[str], str] = Field(
        ...,
        description="Pair of ISO date strings or a relative range description (e.g., 'last 7 days', 'today', etc.)",
    )

    model_config = {"exclude_none": True}


class TimeDimension(BaseModel):
    dimension: str = Field(..., description="Name of the time dimension")
    granularity: Literal["second", "minute", "hour", "day", "week", "month", "quarter", "year"] = Field(
        ..., description="Time granularity"
    )
    dateRange: Union[list[str], str] = Field(
        ...,
        description="Pair of ISO date strings or a relative range description (e.g., 'last 7 days', 'today', etc.)",
    )

    model_config = {"exclude_none": True}


class Query(BaseModel):
    measures: list[str] = Field([], description="Names of measures to query")
    dimensions: list[str] = Field([], description="Names of dimensions to group by")
    timeDimensions: list[TimeDimension] = Field([], description="Time dimensions to group by")
    # filters: list[Filter] = Field([], description="Filters to apply to the query")
    limit: Optional[int] = Field(500, description="Maximum number of rows to return. Defaults to 500")
    offset: Optional[int] = Field(0, description="Number of rows to skip. Defaults to 0")
    order: dict[str, Literal["asc", "desc"]] = Field(
        {}, description="Optional ordering of the results. The order is sensitive to the key order."
    )
    ungrouped: bool = Field(
        False,
        description="Return results without grouping by dimensions. Instead, return all rows. Useful for fetching a single row by its ID.",
    )

    model_config = {"exclude_none": True}


def main(credentials, logger):
    logger.info("Starting Cube MCP server initialization")
    mcp = FastMCP("Cube.dev")
    logger.info("FastMCP instance created")

    client = CubeClient(**credentials, logger=logger)
    logger.info("CubeClient instance created")

    @mcp.resource("context://data_description")
    def data_description() -> str:
        """Describe the data available in Cube."""
        logger.info("Resource 'context://data_description' called")
        meta = client.describe()
        logger.info("Data description retrieved: %s", meta)
        if error := meta.get("error"):
            logger.error("Error in data_description: %s", error, exc_info=True)
            logger.error("Full error response: %s", json.dumps(meta))
            return f"Error: Description of the data is not available: {error}, {meta}"

        description = [
            {
                "name": cube.get("name"),
                "title": cube.get("title"),
                "description": cube.get("description"),
                "dimensions": [
                    {
                        "name": dimension.get("name"),
                        "title": dimension.get("shortTitle") or dimension.get("title"),
                        "description": dimension.get("description"),
                    }
                    for dimension in cube.get("dimensions", [])
                ],
                "measures": [
                    {
                        "name": measure.get("name"),
                        "title": measure.get("shortTitle") or measure.get("title"),
                        "description": measure.get("description"),
                    }
                    for measure in cube.get("measures", [])
                ],
            }
            for cube in meta.get("cubes", [])
        ]
        yaml_desc = yaml.dump(description, indent=2, sort_keys=True)
        logger.info("Resource 'context://data_description' completed successfully")
        logger.info("YAML description: %s", yaml_desc)
        return "Here is a description of the data available via the read_data tool:\n\n" + yaml_desc

    @mcp.tool("describe_data")
    def describe_data() -> str:
        """Describe the data available in Cube."""
        logger.info("Tool 'describe_data' invoked")
        description_text = data_description()
        logger.info("Tool 'describe_data' output: %s", description_text)
        return {"type": "text", "text": description_text}

    @mcp.tool("read_data")
    def read_data(query: Query) -> str:
        """Read data from Cube."""
        try:
            logger.info("Tool 'read_data' invoked with query: %s", query)
            query_dict = query.model_dump(by_alias=True, exclude_none=True)
            logger.info("Query dict after model dump: %s", query_dict)
            response = client.query(query_dict)
            logger.info("Received response from query: %s", response)
            if error := response.get("error"):
                logger.error("Error in read_data: %s", error, exc_info=True)
                logger.error("Full response: %s", json.dumps(response))
                return f"Error: {error}"
            data = response.get("data", [])
            logger.info("Tool 'read_data' returned %s rows", len(data))

            data_id = str(uuid.uuid4())
            logger.info("Generated unique data resource ID: %s", data_id)

            @mcp.resource(f"data://{data_id}")
            def data_resource() -> str:
                logger.info("Resource 'data://%s' called", data_id)
                return json.dumps(data)

            logger.info("Data resource added with ID: %s", data_id)

            output = {
                "type": "data",
                "data_id": data_id,
                "data": data,
            }
            yaml_output = data_to_yaml(output)
            json_output = json.dumps(output)
            logger.info("Prepared output in YAML: %s", yaml_output)
            logger.info("Tool 'read_data' completed successfully")
            return [
                TextContent(type="text", text=yaml_output),
                EmbeddedResource(
                    type="resource",
                    resource=TextResourceContents(uri=f"data://{data_id}", text=json_output, mimeType="application/json"),
                ),
            ]

        except Exception as e:
            logger.exception("Unhandled exception in read_data: %s", str(e))
            return f"Error: {str(e)}"

    # Log all exposed services before starting the server.
    exposed_services = [
        "Resource: context://data_description",
        "Tool: describe_data",
        "Tool: read_data"
    ]
    logger.info("Exposing the following service endpoints:")
    for service in exposed_services:
        logger.info("  - %s", service)

    logger.info("Starting Cube MCP server !!")

 # Set the HTTP binding parameters in the settings.
    mcp.settings.host = "0.0.0.0"
    mcp.settings.port = 8000
    
    mcp.run(transport="sse")
