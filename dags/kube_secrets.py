"""
Simplified file containing Kubernetes secrets for use across multiple Airflow DAGs.
"""

from airflow.kubernetes.secret import Secret

# Snowflake Credentials
SNOWFLAKE_ACCOUNT = Secret("env", "SNOWFLAKE_ACCOUNT", "airflow", "SNOWFLAKE_ACCOUNT")
SNOWFLAKE_USER = Secret("env", "SNOWFLAKE_USER", "airflow", "SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = Secret("env", "SNOWFLAKE_PASSWORD", "airflow", "SNOWFLAKE_PASSWORD")

