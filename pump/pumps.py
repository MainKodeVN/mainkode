# import logging
# import os
# from datetime import datetime

# # Simplified import for connecting to Snowflake
# from sqlalchemy import create_engine


# # Function to generate Snowflake connection
# def simple_snowflake_engine():
#     """
#     Creates a simple Snowflake engine for the connection.
#     """
#     # Substitute these with your Snowflake credentials or environment variables
#     return create_engine(
#         "snowflake://{user}:{password}@{account}/{database}/{schema}?warehouse={warehouse}".format(
#             user=os.getenv("SNOWFLAKE_USER"),
#             password=os.getenv("SNOWFLAKE_PASSWORD"),
#             account=os.getenv("SNOWFLAKE_ACCOUNT"),
#             database="MY_DB",
#             schema="PUBLIC",
#             warehouse="MY_WAREHOUSE",
#         )
#     )


# # Function to generate the SQL copy command
# def generate_copy_command(model, inc_end):
#     """
#     Generate a basic Snowflake COPY INTO command for exporting data to stage.
#     """
#     # Define target filename based on the timestamp
#     file_stamp = datetime.fromisoformat(inc_end).strftime("%Y_%m_%d__%H%M%S")
#     target_name = f"{model}/{file_stamp}.csv"

#     # Simple copy command setup
#     copy_command = f"""
#         COPY INTO @MY_STAGE/{target_name}
#         FROM MY_DB.PUBLIC.{model}
#         FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY = '"', COMPRESSION = NONE)
#         HEADER = TRUE
#         SINGLE = TRUE
#         OVERWRITE = TRUE
#     """
#     logging.info(f"Generated Copy Command: {copy_command}")
#     return copy_command


# # Main function to execute the copy command
# def execute_copy(model, inc_end):
#     """
#     Connect to Snowflake and execute the copy command.
#     """
#     engine = simple_snowflake_engine()
#     copy_command = generate_copy_command(model, inc_end)
#     logging.info("Connecting to Snowflake and executing the copy command...")

#     with engine.connect() as connection:
#         result = connection.execute(copy_command)
#         logging.info("Copy Command executed successfully.")

#     engine.dispose()


# # Entry point for running the script directly
# if __name__ == "__main__":
#     logging.basicConfig(level=logging.INFO)
#     # Example usage: provide model and inc_end parameters directly
#     execute_copy(model="my_table", inc_end="2024-10-15T23:59:59")
