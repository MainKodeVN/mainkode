# """
# Backup DAG for handling snapshot housekeeping
# This DAG will automate the backup of database snapshots and tables, likely to Google Cloud Storage.
# """

# from datetime import datetime, timedelta
# import yaml

# # Essential Airflow imports
# from airflow import DAG
# from airflow.operators.bash_operator import (
#     BashOperator,
# )  # Simple BashOperator for initial setup

# # Basic configuration for the DAG
# default_args = {
#     "depends_on_past": False,
#     "owner": "airflow",
#     "start_date": datetime(2024, 1, 1),  # Adjust start date as needed
#     "retries": 1,
#     "retry_delay": timedelta(minutes=10),
# }

# # Define the DAG with a basic schedule
# dag = DAG(
#     "simple_dbt_backups",
#     default_args=default_args,
#     schedule_interval="5 4 * * *",  # Runs daily at 04:05 AM
#     catchup=False,
# )


# # Simple function to load table backup list from a YAML file
# def load_backup_config(file_path: str) -> dict:
#     with open(file_path, "r") as yaml_file:
#         return yaml.safe_load(yaml_file)


# # Path to a basic YAML configuration file
# backup_config_path = "/path/to/your/backup_manifest.yaml"
# config_dict = load_backup_config(backup_config_path)

# # Loop through each task in the config and create a backup task
# for task_name, task_details in config_dict.items():
#     backup_list = task_details.get("TABLE_LIST_BACKUP", [])
#     # Format list as a string for Bash command
#     backup_str = ",".join(backup_list)

#     # Define a simple Bash task for running backups
#     backup_task = BashOperator(
#         task_id=f"backup_{task_name}",
#         bash_command=(
#             f"echo 'Backing up tables: {backup_str}' && "
#             f"dbt run-operation backup_to_s3 "
#             f"--args '{{TABLE_LIST_BACKUP: {backup_list}}}'"
#         ),
#         dag=dag,
#     )
