"""
This file contains simple helper functions and common settings
that you can use in multiple Airflow DAGs.
"""

import os
import urllib.parse
from airflow.providers.slack.operators.slack_webhook import SlackWebhookOperator

# Base path depending on if you're running in the cloud or locally
REPO_BASE_PATH = os.environ.get("AIRFLOW_HOME", "/dags/repo")

# Docker images you might use
DATA_IMAGE = "registry.gitlab.com/gitlab-data/data-image/data-image:v1.0.31"
DBT_IMAGE = "registry.gitlab.com/gitlab-data/dbt-image:v0.0.7"

# Helper to send notifications to Slack on task failure
def slack_failed_task(context):
    """
    Sends a Slack notification if a task fails.
    """
    base_url = "http://airflow-logs-url.com"
    dag_id = context["dag"].dag_id
    task_id = context["task_instance"].task_id
    execution_date = context["execution_date"]

    # Link to Airflow logs
    log_link = f"{base_url}/log?{urllib.parse.urlencode({'dag_id': dag_id, 'task_id': task_id, 'execution_date': execution_date})}"

    # Message details for Slack
    message = f"Task failed in DAG: {dag_id}, Task: {task_id}. [Logs]({log_link})"

    # Sending the message to Slack
    slack_alert = SlackWebhookOperator(
        task_id="slack_failed",
        http_conn_id="slack_connection",  # Pre-configured Airflow Slack connection
        message=message,
        username="Airflow",
        channel="#alerts",  # Change this to your Slack channel
    )
    slack_alert.execute(context)

# Default environment variables for worker pods
gitlab_pod_env_vars = {
    "CI_PROJECT_DIR": "/analytics",
    "EXECUTION_DATE": "{{ next_execution_date }}",
}

# Simple clone command to use in tasks
clone_repo_cmd = f"git clone https://gitlab.com/gitlab-data/analytics.git && cd analytics"

# A basic dbt command to install dependencies
dbt_install_deps_cmd = f"{clone_repo_cmd} && dbt deps"

