from airflow.contrib.operators.slack_webhook_operator import SlackWebhookOperator
from airflow.models import Variable
from kubernetes.client import models as k8s

DBT_IMAGE = "shrestic/dbt-image:latest"
DEFAULT_AIRFLOW_NAMESPACE = "airflow-dev"
IS_DEV_MODE = Variable.get("environment")
S3_MANIFEST_PATH = Variable.get("s3_manifest_path")
SLACK_CONN_ID = "slack_conn"

# Default settings for all DAGs
pod_defaults = {
    "get_logs": True,
    "image_pull_policy": "IfNotPresent",
    "log_pod_spec_on_failure": False,
    "in_cluster": True,
    "on_finish_action": "delete_pod",
    "namespace": Variable.get("namespace", DEFAULT_AIRFLOW_NAMESPACE),
    "cmds": ["/bin/bash", "-c"],
    "container_resources": k8s.V1ResourceRequirements(
        requests={
            "cpu": "50m",
            "memory": "100Mi",
        },
        limits={
            "cpu": "500m",
            "memory": "500Mi",
        },
    ),
}

if IS_DEV_MODE == "docker-compose":
    # Override defaults for dev mode
    pod_defaults["in_cluster"] = False
    pod_defaults["config_file"] = "/opt/kube/airflow-kube.yaml"

clone_repo_cmd = "git clone -b master --single-branch --depth 1 https://github.com/MainKodeVN/mainkode.git"


setup_dbt_project = f"""
    {clone_repo_cmd} &&
    cd mainkode/transform/mainkode_analytics/"""

dbt_install_deps_cmd = f"""
    {setup_dbt_project} &&
    dbt deps --profiles-dir=./profiles --target=prod"""


def task_slack_alert(is_fail_case, context):
    badge = ":x:" if is_fail_case else ":white_check_mark:"

    slack_msg = f"""
    Task {('Failed' if is_fail_case else 'Succeeded')} {badge}.
    *DAG*: {context.get("dag").dag_id}
    *Task*: {context.get("task_instance").task_id}
    *Dag*: {context.get("task_instance").dag_id}
    *Execution Time*: {context.get("execution_date")}
    *Log Url*: {context.get("task_instance").log_url}
    """

    alert = SlackWebhookOperator(
        task_id="slack_alert", slack_webhook_conn_id=SLACK_CONN_ID, message=slack_msg
    )
    return alert.execute(context=context)
