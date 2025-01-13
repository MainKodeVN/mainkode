import logging

from dotenv import load_dotenv
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine, text

load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],  # Outputs logs to stdout
)

role_dict = {
    "LOADER": {
        "USER": "SNOWFLAKE_LOAD_USER",
        "PASSWORD": "SNOWFLAKE_LOAD_PASSWORD",
        "ACCOUNT": "SNOWFLAKE_ACCOUNT",
        "DATABASE": "SNOWFLAKE_LOAD_DATABASE",
        "WAREHOUSE": "SNOWFLAKE_LOAD_WAREHOUSE",
        "ROLE": "SNOWFLAKE_LOAD_ROLE",
    },
    "TRANSFORMER": {
        "USER": "SNOWFLAKE_USER",
        "PASSWORD": "SNOWFLAKE_PASSWORD",
        "ACCOUNT": "SNOWFLAKE_ACCOUNT",
        "DATABASE": "SNOWFLAKE_TRANSFORM_DATABASE",
        "WAREHOUSE": "SNOWFLAKE_TRANSFORM_WAREHOUSE",
        "ROLE": "SNOWFLAKE_TRANSFORM_ROLE",
    },
}


class SnowflakeManager:
    def __init__(
        self,
        config_vars,
        role,
        load_warehouse="LOADING",
    ):
        self.config_args = config_vars
        self.role = role
        self.load_warehouse = load_warehouse
        selected_role = role_dict[role]
        warehouse = selected_role.get("WAREHOUSE", self.load_warehouse)

        self.engine = create_engine(
            URL(
                user=self.config_args[selected_role["USER"]],
                password=self.config_args[selected_role["PASSWORD"]],
                account=self.config_args[selected_role["ACCOUNT"]],
                database=self.config_args[selected_role["DATABASE"]],
                warehouse=warehouse,
                role=self.config_args[selected_role["ROLE"]],
            )
        )

    # ---- Schema Methods ----

    def create_schema(self, database_name, schema_name: str):
        create_schema_query = (
            f"CREATE SCHEMA IF NOT EXISTS {database_name}.{schema_name} ;"
        )
        logging.info(f"Creating schema '{database_name}.{schema_name}'.")

        try:
            with self.engine.connect() as connection:
                connection.execute(text(create_schema_query))
                logging.info(
                    f"Schema '{database_name}.{schema_name}' created successfully."
                )
        except Exception as e:
            logging.error(f"Error creating schema '{database_name}.{schema_name}': {e}")

    # ---- Table Methods ----

    def create_table(
        self,
        database_name: str,
        schema_name: str,
        table_name: str,
        table_definition: str,
    ):
        create_table_query = f"CREATE OR REPLACE TABLE {database_name}.{schema_name}.{table_name} ({table_definition});"
        logging.info(
            f"Creating table '{table_name}' in schema '{schema_name}' "
            f"in database '{database_name}' with definition '{table_definition}'."
        )

        try:
            with self.engine.connect() as connection:
                connection.execute(text(create_table_query))
                logging.info(
                    f"Table '{table_name}' created successfully in schema '{schema_name}' in database {database_name} ."
                )
        except Exception as e:
            logging.error(
                f"Error creating table '{table_name}' in schema '{schema_name} in database {database_name}': {e}"
            )

    def create_stage(
        self,
        stage_name: str,
        s3_url: str,
        storage_integration: str,
        file_format: str = "CSV",
        file_format_options: str = "",
    ):

        create_stage_query = f"""
        CREATE STAGE IF NOT EXISTS {stage_name}
        URL='{s3_url}'
        STORAGE_INTEGRATION = {storage_integration}
        FILE_FORMAT=(TYPE={file_format} ,{file_format_options})
        """
        logging.info(f"Creating S3 stage '{stage_name}' with S3 URL '{s3_url}'.")

        try:
            with self.engine.connect() as connection:
                connection.execute(text(create_stage_query))
                logging.info(f"S3 stage '{stage_name}' created successfully.")
        except Exception as e:
            logging.error(f"Error creating S3 stage '{stage_name}': {e}")

    def drop_stage(self, stage_name: str):
        """
        Method to drop an S3-based external stage in Snowflake.

        Args:
            stage_name: The name of the stage to drop.
        """
        drop_stage_query = f"DROP STAGE IF EXISTS {stage_name};"
        logging.info(f"Dropping S3 stage '{stage_name}'.")

        try:
            with self.engine.connect() as connection:
                connection.execute(text(drop_stage_query))
                logging.info(f"S3 stage '{stage_name}' dropped successfully.")
        except Exception as e:
            logging.error(f"Error dropping S3 stage '{stage_name}': {e}")

    def list_stages(self):
        list_stages_query = "SHOW STAGES;"
        logging.info("Listing all external stages in the current schema.")

        try:
            with self.engine.connect() as connection:
                result = connection.execute(text(list_stages_query))
                stages = result.fetchall()
                for stage in stages:
                    logging.info(stage)
                return stages
        except Exception as e:
            logging.error(f"Error listing external stages: {e}")

    def grant_all_on_future_tables(self, schema_name: str):
        """
        Grants ALL privileges on future tables in the specified schema.

        Args:
            schema_name: The name of the schema where privileges will be granted.
        """
        grant_query = f"GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA {schema_name} TO ROLE LOADER;"
        logging.info(
            f"Granting ALL PRIVILEGES on future tables in schema '{schema_name}'."
        )

        try:
            with self.engine.connect() as connection:
                connection.execute(text(grant_query))
                logging.info(
                    f"Granted ALL PRIVILEGES on future tables in schema '{schema_name}'."
                )
        except Exception as e:
            logging.error(
                f"Error granting ALL PRIVILEGES on future tables in schema '{schema_name}': {e}"
            )

    def grant_create_table_usage_on_schema(self, schema_name: str):
        """
        Grants CREATE TABLE and USAGE privileges on the specified schema.

        Args:
            schema_name: The name of the schema where privileges will be granted.
        """
        grant_query = (
            f"GRANT CREATE TABLE, USAGE ON SCHEMA {schema_name} TO ROLE LOADER;"
        )
        logging.info(
            f"Granting CREATE TABLE, USAGE privileges on schema '{schema_name}'."
        )

        try:
            with self.engine.connect() as connection:
                connection.execute(text(grant_query))
                logging.info(
                    f"Granted CREATE TABLE, USAGE privileges on schema '{schema_name}'."
                )
        except Exception as e:
            logging.error(
                f"Error granting CREATE TABLE, USAGE privileges on schema '{schema_name}': {e}"
            )

    def grant_create_schema_usage_on_database(self, database_name: str):
        """
        Grants CREATE SCHEMA and USAGE privileges on the specified database.

        Args:
            database_name: The name of the database where privileges will be granted.
        """
        grant_query = (
            f"GRANT CREATE SCHEMA, USAGE ON DATABASE {database_name} TO ROLE LOADER;"
        )
        logging.info(
            f"Granting CREATE SCHEMA, USAGE privileges on database '{database_name}'."
        )

        try:
            with self.engine.connect() as connection:
                connection.execute(text(grant_query))
                logging.info(
                    f"Granted CREATE SCHEMA, USAGE privileges on database '{database_name}'."
                )
        except Exception as e:
            logging.error(
                f"Error granting CREATE SCHEMA, USAGE privileges on database '{database_name}': {e}"
            )

    def close(self):
        logging.info("Closing Snowflake engine connection.")
        self.engine.dispose()
