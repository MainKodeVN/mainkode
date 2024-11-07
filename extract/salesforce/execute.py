from utils.db.snowflake_manager import SnowflakeManager
from utils.generate_sql_schema_from_csv import generate_table_definition_from_csv
from utils.api.base_api import BaseAPI
from utils.aws.s3_manager import S3Manager
from dotenv import dotenv_values, load_dotenv
import os
import logging

load_dotenv()
s3_manager = S3Manager()
api = BaseAPI(source="salesforce")
config_vars = dotenv_values(".env")
snowflake = SnowflakeManager(config_vars=config_vars, role="LOADER")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],  # Outputs logs to stdout
)


def create_tables():
    table_names = []
    for root, dirs, files in os.walk("./data/salesforce"):
        for file_name in files:
            if file_name.endswith(".csv"):
                try:
                    csv_path = os.path.join(root, file_name)
                    table_name = os.path.relpath(root, "./data/salesforce").split(os.sep)[0]
                    logging.info(f"Processing file '{file_name}' for table '{table_name}'")
                    table_definition = generate_table_definition_from_csv(csv_path)
                    snowflake.create_table("raw_dev", "salesforce", table_name, table_definition)
                    logging.info(f"Table '{table_name}' created successfully.")
                    table_names.append(table_name)

                except Exception as e:
                    logging.error(f"Failed to create table '{table_name}' from file '{file_name}': {e}")

    return table_names


if __name__ == "__main__":
    api.fetch_data()
    saved_data_directory = api.saved_data_directory
    table_names = create_tables()
    snowflake.create_stage(
        "raw_dev.salesforce.salesforce_stage",
        "s3://s3-raw-data-19/salesforce/",
        "s3_int",
        "CSV",
        "skip_header=1",
    )
    for table_name in table_names:
        snowflake.create_snowpipe(
            f"raw_dev.salesforce.salesforce_pipe_{table_name}",
            "raw_dev.salesforce.salesforce_stage",
            f"raw_dev.salesforce.{table_name}",
            "CSV",
            "skip_header=1",
        )
    s3_manager.upload_folder_to_s3(
        folder_path=saved_data_directory,
        bucket_name="s3-raw-data-19",
        s3_folder_prefix="salesforce",
    )


# Run this file:  PYTHONPATH=path-of-project python3 path-of-file-to-execute
