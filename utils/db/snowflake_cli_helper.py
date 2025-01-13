import logging
import os

import click
import pandas as pd
from dotenv import load_dotenv
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine, text

# Load environment variables from .env file
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


@click.group()
@click.option(
    "-a",
    "--account",
    envvar="SNOWFLAKE_ACCOUNT",
    required=True,
    help="The name of the Snowflake account",
)
@click.option(
    "-d",
    "--database",
    envvar="SNOWFLAKE_TRANSFORM_DATABASE",
    required=True,
    help="The Snowflake database",
)
@click.option(
    "-s",
    "--schema",
    envvar="SNOWFLAKE_TRANSFORM_SCHEMA",
    help="The Snowflake schema (optional)",
)
@click.option(
    "-u",
    "--user",
    envvar="SNOWFLAKE_TRANSFORM_USER",
    required=True,
    help="User for connecting to Snowflake",
)
@click.option(
    "-p",
    "--password",
    envvar="SNOWFLAKE_TRANSFORM_PASSWORD",
    required=True,
    prompt=True,
    hide_input=True,
    help="Password for connecting to Snowflake",
)
@click.option(
    "-w",
    "--warehouse",
    envvar="SNOWFLAKE_TRANSFORM_WAREHOUSE",
    help="Warehouse to use when connecting to Snowflake",
)
@click.option(
    "-r",
    "--role",
    envvar="SNOWFLAKE_TRANSFORM_ROLE",
    help="Role to use when connecting to Snowflake",
)
@click.pass_context
def snowflake(
    ctx: click.Context,
    account: str,
    database: str,
    schema: str,
    user: str,
    password: str,
    warehouse: str,
    role: str,
) -> None:
    """
    Snowflake helper. Provides commands for cloning and dropping databases and schemas in Snowflake.
    """
    ctx.ensure_object(dict)
    url_params = {
        "account": account,
        "user": user,
        "password": password,
        "database": database,
        "warehouse": warehouse,
        "role": role,
    }

    if schema:
        url_params["schema"] = schema

    ctx.obj["engine"] = create_engine(URL(**url_params))


@snowflake.command()
@click.argument("target_db", type=str)
@click.argument("source_db", type=str)
@click.option(
    "--schema",
    "source_schema",
    default=None,
    help="Specify a source schema to clone (optional)",
)
@click.option(
    "--target_schema",
    default=None,
    help="Specify a target schema if cloning a schema (optional)",
)
@click.pass_context
def clone(
    ctx: click.Context,
    target_db: str,
    source_db: str,
    source_schema: str,
    target_schema: str,
) -> None:
    """
    Clones a Snowflake database or schema. If `source_schema` is provided, clones only that schema.
    """
    engine = ctx.obj["engine"]
    clone_query = (
        f"CREATE DATABASE IF NOT EXISTS {target_db} CLONE {source_db};"
        if not source_schema
        else (
            f"CREATE SCHEMA IF NOT EXISTS {target_db}.{target_schema or source_schema} "
            f"CLONE {source_db}.{source_schema};"
        )
    )
    logging.info(f"Executing clone: {clone_query}")

    try:
        with engine.connect() as conn:
            conn.execute(text(clone_query))
            logging.info("Clone successful.")
    except Exception as e:
        logging.error(f"Error executing clone: {e}")
    finally:
        engine.dispose()


@snowflake.command()
@click.argument("target_db", type=str)
@click.option(
    "--schema",
    "target_schema",
    default=None,
    help="Specify a target schema to drop (optional)",
)
@click.pass_context
def drop(ctx: click.Context, target_db: str, target_schema: str) -> None:
    """
    Drops a Snowflake database or schema. If `target_schema` is provided, drops only that schema.
    """
    engine = ctx.obj["engine"]
    drop_query = (
        f"DROP DATABASE IF EXISTS {target_db} CASCADE;"
        if not target_schema
        else f"DROP SCHEMA IF EXISTS {target_db}.{target_schema} CASCADE;"
    )
    logging.info(f"Executing drop: {drop_query}")

    try:
        with engine.connect() as conn:
            conn.execute(text(drop_query))
            logging.info("Drop successful.")
    except Exception as e:
        logging.error(f"Error executing drop: {e}")
    finally:
        engine.dispose()


@snowflake.command()
@click.option("-t", "--table-name", default="None", help="The table to query")
@click.option(
    "-o",
    "--output-file",
    default="output/dbt-results.md",
    help="The file to write the Markdown output to",
)
@click.pass_context
def generate_dbt_markdown(
    ctx: click.Context, table_name: str, output_file: str
) -> None:
    """
    Queries a DBT_RESULTS table and generates a Markdown report in a readme.md file.
    """
    engine = ctx.obj["engine"]
    query = f"SELECT * FROM {table_name};"
    logging.info(f"Querying table '{table_name}' to generate Markdown report.")

    try:
        with engine.connect() as conn:
            result = conn.execute(text(query))
            rows = result.fetchall()
            columns = result.keys()

            # Convert results to a Pandas DataFrame
            df = pd.DataFrame(rows, columns=columns)

            # Convert DataFrame to Markdown table
            markdown_table = df.to_markdown(index=False)

            os.makedirs(os.path.dirname(output_file), exist_ok=True)

            # Write the Markdown table to the output file
            with open(output_file, "w") as f:
                f.write("# DBT Results\n\n")
                f.write(markdown_table)

            logging.info(
                f"Markdown report generated successfully and saved to '{output_file}'."
            )
    except Exception as e:
        logging.error(
            f"Error querying table '{table_name}' or generating Markdown: {e}"
        )
    finally:
        engine.dispose()


if __name__ == "__main__":
    snowflake()
