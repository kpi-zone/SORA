import argparse
import asyncio
import json
import logging
import os

import dotenv

from . import server


def args_to_kwargs(unknown):
    extras = {}
    i = 0
    while i < len(unknown):
        if unknown[i].startswith("--"):
            key = unknown[i][2:]  # Remove '--' prefix
            if i + 1 >= len(unknown) or unknown[i + 1].startswith("--"):
                extras[key] = True  # Flag argument
                i += 1
            else:
                extras[key] = unknown[i + 1]  # Key-value pair
                i += 2
        else:
            i += 1

    return extras


def main():
    """Main entry point for the package."""
    parser = argparse.ArgumentParser(description="Cube MCP Server")
    parser.add_argument(
        "--log_dir", required=False, default=None, help="Directory to log to"
    )
    parser.add_argument(
        "--log_level", required=False, default="INFO", help="Logging level"
    )

    dotenv.load_dotenv()

    required = {
        "endpoint": os.getenv("CUBE_ENDPOINT"),
        "api_secret": os.getenv("CUBE_API_SECRET"),
        "token_payload": os.getenv("CUBE_TOKEN_PAYLOAD", "{}"),
    }

    parser.add_argument(
        "--endpoint", required=not required["endpoint"], default=required["endpoint"]
    )
    parser.add_argument(
        "--api_secret",
        required=not required["api_secret"],
        default=required["api_secret"],
    )

    args, unknown = parser.parse_known_args()
    additional_kwargs = args_to_kwargs(unknown)

    token_payload = json.loads(required["token_payload"])
    for key, value in additional_kwargs.items():
        token_payload[key] = value

    logger = logging.getLogger(__name__)
    logger.propagate = False
    logger.setLevel(args.log_level)
    console_handler = logging.StreamHandler()
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    if args.log_dir:
        file_handler = logging.FileHandler(
            os.path.join(args.log_dir, "mcp_cube_server.log")
        )
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    try:
        credentials = {
            "endpoint": args.endpoint,
            "api_secret": args.api_secret,
            "token_payload": token_payload,
        }
    except json.JSONDecodeError:
        logger.error("Invalid JSON in token_payload: %s", args.token_payload)
        return

    server.main(
        credentials,
        logger,
    )


# Optionally expose other important items at package level
__all__ = ["main", "server"]

if __name__ == "__main__":
    main()
