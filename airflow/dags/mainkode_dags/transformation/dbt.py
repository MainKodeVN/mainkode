from datetime import datetime, timedelta

from airflow.contrib.operators.kubernetes_pod_operator import (
    KubernetesPodOperator,  # type: ignore; type: ignore
)

# from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from mainkode_dags.airflow_utils import (
    DBT_IMAGE,
    S3_MANIFEST_PATH,
    dbt_install_deps_cmd,
    pod_defaults,
    task_slack_alert,
)
from mainkode_dags.kube_secrets import (
    AWS_ACCESS_KEY_ID,
    AWS_SECRET_ACCESS_KEY,
    SNOWFLAKE_ACCOUNT,
    SNOWFLAKE_TRANSFORM_DATABASE,
    SNOWFLAKE_TRANSFORM_PASSWORD,
    SNOWFLAKE_TRANSFORM_ROLE,
    SNOWFLAKE_TRANSFORM_USER,
    SNOWFLAKE_TRANSFORM_WAREHOUSE,
)

from airflow import DAG

# Default arguments for the DAG
default_args = {
    "catchup": False,
    "depends_on_past": False,
    "owner": "airflow",
    "retries": 0,
    "retry_delay": timedelta(minutes=1),
    "start_date": datetime.now(),
    "on_failure_callback": lambda context: task_slack_alert(
        is_fail_case=True, context=context
    ),
    "on_success_callback": lambda context: task_slack_alert(
        is_fail_case=False, context=context
    ),
}

# Create the DAG
dag = DAG("dbt", default_args=default_args)


# aws upload manifest.json from dbt to s3 bucket
aws_cmd = f"""
    aws s3 cp ./target/manifest.json  {S3_MANIFEST_PATH}
"""

# dbt-run
dbt_run_cmd = f"""
    {dbt_install_deps_cmd} &&
    dbt run --profiles-dir=./profiles --target prod &&
    {aws_cmd}
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
        AWS_ACCESS_KEY_ID,
        AWS_SECRET_ACCESS_KEY,
    ],
    arguments=[dbt_run_cmd, aws_cmd],
    dag=dag,
)
dbt_run
