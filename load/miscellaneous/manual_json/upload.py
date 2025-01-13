import logging
import os
import re
import sys
from os import environ as env

from snowflake.sqlalchemy import URL as snowflake_URL
from sqlalchemy import create_engine


# Define a function to create a Snowflake engine for different roles
def create_snowflake_engine(role: str) -> create_engine:
    """
    Create a Snowflake engine based on the given role.
    """
    # Define connection parameters for different roles
    role_params = {
        "LOADER": {
            "USER": env["SNOWFLAKE_LOAD_USER"],
            "PASSWORD": env["SNOWFLAKE_LOAD_PASSWORD"],
            "ACCOUNT": env["SNOWFLAKE_ACCOUNT"],
            "DATABASE": env["SNOWFLAKE_LOAD_DATABASE"],
            "WAREHOUSE": env["SNOWFLAKE_LOAD_WAREHOUSE"],
            "ROLE": "LOADER",
        }
    }

    # Get the parameters for the chosen role
    params = role_params[role]

    # Build the Snowflake connection string
    conn_url = snowflake_URL(
        user=params["USER"],
        password=params["PASSWORD"],
        account=params["ACCOUNT"],
        database=params["DATABASE"],
        warehouse=params["WAREHOUSE"],
        role=params["ROLE"],
    )

    return create_engine(conn_url, connect_args={"sslcompression": 0})


# Define a function to load a JSON file into Snowflake
def load_file_to_snowflake(
    file: str, stage: str, table: str, engine: create_engine
) -> None:
    """
    Upload a JSON file to a Snowflake stage and copy its contents to a table.
    """
    # Define SQL commands for uploading, copying, and removing files
    put_cmd = f"PUT file://{file} @{stage};"
    copy_cmd = f"COPY INTO {table} FROM @{stage} file_format=(type='json');"
    remove_cmd = f"REMOVE @{stage};"

    try:
        connection = engine.connect()

        # Execute the commands in Snowflake
        connection.execute(put_cmd)
        connection.execute(copy_cmd)
        connection.execute(remove_cmd)
    finally:
        connection.close()


# Main function to walk through the directory and process files
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    # Establish connection to Snowflake as LOADER
    engine = create_snowflake_engine("LOADER")

    # Walk through a directory and find files to process
    for root, _, files in os.walk("/path/to/files"):
        for file in files:
            if file.endswith(".json"):
                # Load JSON files to Snowflake
                load_file_to_snowflake(
                    file,
                    stage="my_stage",
                    table="my_table",
                    engine=engine,
                )
