import pendulum
from airflow.decorators import dag, task


@dag(
    schedule=None,
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=["example"],
)
def example_kubernetes_dag():
    @task.kubernetes(
        image="python:3.9",
        name="k8s_test",
        namespace="default",
        in_cluster=False,
        config_file="/opt/kube/airflow-kube.yaml",
    )
    def execute_in_k8s_pod():
        print("Hello from k8s pod")

    execute_in_k8s_pod()


example_kubernetes_dag()
