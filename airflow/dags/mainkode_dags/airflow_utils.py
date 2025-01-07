from kubernetes.client import models as k8s
from airflow.models import Variable

DBT_IMAGE = "shrestic/dbt-image:latest"
DEFAULT_AIRFLOW_NAMESPACE = "airflow-dev"
IS_DEV_MODE = Variable.get("environment")
# Default settings for all DAGs
pod_defaults = {
    "get_logs": True,
    "image_pull_policy": "IfNotPresent",
    "log_pod_spec_on_failure": False,
    "in_cluster": True,
    "on_finish_action": 'delete_pod',
    "namespace": Variable.get('namespace', DEFAULT_AIRFLOW_NAMESPACE),
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

if IS_DEV_MODE == 'docker-compose':
    # Override defaults for dev mode
    pod_defaults["in_cluster"] = False
    pod_defaults["config_file"] = "/opt/kube/airflow-kube.yaml"
    

clone_repo_cmd = f"git clone -b master --single-branch --depth 1 https://github.com/MainKodeVN/mainkode.git"


setup_dbt_project = f"""
    {clone_repo_cmd} &&
    cd mainkode/transform/mainkode_analytics/"""

dbt_install_deps_cmd = f"""
    {setup_dbt_project} &&
    dbt deps --profiles-dir=./profiles --target=prod"""
