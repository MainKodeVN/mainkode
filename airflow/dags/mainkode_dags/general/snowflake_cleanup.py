# """
# Airflow DAG for Snowflake Cleanup
# Automates weekly cleanup tasks in Snowflake, such as purging cloned databases,
# dropping unused development schemas, and deprovisioning stale users.
# """

# # Importing necessary libraries
# import os
# from datetime import datetime, timedelta
# from airflow import DAG
# from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator

# # Import custom utilities and secrets (replace with actual paths or adjust as needed)
# from airflow_utils import DATA_IMAGE, gitlab_defaults, slack_failed_task
# from kube_secrets import (
#     SNOWFLAKE_ACCOUNT,
#     SNOWFLAKE_USER,
#     SNOWFLAKE_PASSWORD,
#     PERMISSION_BOT_USER,
#     PERMISSION_BOT_PASSWORD,
# )

# # Set up environment variables for the tasks
# pod_env_vars = {"CI_PROJECT_DIR": "/analytics", "SNOWFLAKE_PROD_DATABASE": "PROD"}

# # Set up default settings for the DAG
# default_args = {
#     "owner": "airflow",
#     "depends_on_past": False,
#     "on_failure_callback": slack_failed_task,
#     "start_date": datetime(2019, 1, 1),
#     "dagrun_timeout": timedelta(hours=2),
# }

# # Define the DAG (scheduled to run every Sunday at 5 AM)
# dag = DAG(
#     "snowflake_cleanup",
#     default_args=default_args,
#     schedule_interval="0 5 * * 0",
#     catchup=False,
# )

# # Define Task 1: Purge Clones
# purge_clones = KubernetesPodOperator(
#     **gitlab_defaults,
#     image=DATA_IMAGE,
#     task_id="purge-clones",
#     name="purge-clones",
#     secrets=[SNOWFLAKE_USER, SNOWFLAKE_PASSWORD, SNOWFLAKE_ACCOUNT],
#     env_vars=pod_env_vars,
#     arguments=["analytics/orchestration/drop_snowflake_objects.py drop_databases"],
#     dag=dag,
# )

# # Define Task 2: Purge Development Schemas
# purge_dev_schemas = KubernetesPodOperator(
#     **gitlab_defaults,
#     image=DATA_IMAGE,
#     task_id="purge-dev-schemas",
#     name="purge-dev-schemas",
#     secrets=[SNOWFLAKE_USER, SNOWFLAKE_PASSWORD, SNOWFLAKE_ACCOUNT],
#     env_vars=pod_env_vars,
#     arguments=["analytics/orchestration/drop_snowflake_objects.py drop_stale_dev_tables"],
#     dag=dag,
# )

# # Define Task 3: Deprovision Stale Users
# deprovision_users = KubernetesPodOperator(
#     **gitlab_defaults,
#     image=DATA_IMAGE,
#     task_id="deprovision_users",
#     name="deprovision_users",
#     secrets=[PERMISSION_BOT_USER, PERMISSION_BOT_PASSWORD, SNOWFLAKE_ACCOUNT],
#     env_vars=pod_env_vars,
#     arguments=["analytics/orchestration/snowflake_provisioning_automation/provision_users/deprovision_users.py"],
#     dag=dag,
# )
