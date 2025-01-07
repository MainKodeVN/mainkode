from datetime import datetime, timedelta
from airflow import DAG
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
# from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator


from mainkode_dags.airflow_utils import (
    DBT_IMAGE,
    dbt_install_deps_cmd,
    pod_defaults
)
from mainkode_dags.kube_secrets import (
    SNOWFLAKE_ACCOUNT,
    SNOWFLAKE_TRANSFORM_PASSWORD,
    SNOWFLAKE_TRANSFORM_ROLE,
    SNOWFLAKE_TRANSFORM_DATABASE,
    SNOWFLAKE_TRANSFORM_WAREHOUSE,
    SNOWFLAKE_TRANSFORM_USER,
)

# Default arguments for the DAG
default_args = {
    "catchup": False,
    "depends_on_past": False,
    "owner": "airflow",
    "retries": 0,
    "retry_delay": timedelta(minutes=1),
    "start_date": datetime.now(),
}

# Create the DAG
dag = DAG("dbt", default_args=default_args)

# dbt-run
dbt_run_cmd = f"""
    {dbt_install_deps_cmd} &&
    dbt run --profiles-dir=./profiles --target prod
"""

dbt_run = KubernetesPodOperator(
    **pod_defaults,
    image=DBT_IMAGE,
    task_id="dbt-run",
    name="dbt-run",
    secrets=[
        SNOWFLAKE_ACCOUNT,
        SNOWFLAKE_TRANSFORM_USER,
        SNOWFLAKE_TRANSFORM_PASSWORD,
        SNOWFLAKE_TRANSFORM_ROLE,
        SNOWFLAKE_TRANSFORM_WAREHOUSE,
        SNOWFLAKE_TRANSFORM_DATABASE,
    ],
    arguments=[dbt_run_cmd],
    dag=dag,
)

dbt_run