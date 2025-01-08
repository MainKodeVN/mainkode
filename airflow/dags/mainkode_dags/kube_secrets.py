from airflow.providers.cncf.kubernetes.secret import Secret

AWS_ACCESS_KEY_ID = Secret(
    deploy_type="env",  # Type of deployment (environment variable)
    deploy_target="AWS_ACCESS_KEY_ID",  # Name of the environment variable
    secret="aws-secret",  # Name of the Kubernetes Secret
    key="aws_access_key_id",  # Key in the Kubernetes Secret
)

AWS_SECRET_ACCESS_KEY = Secret(
    deploy_type="env",
    deploy_target="AWS_SECRET_ACCESS_KEY",
    secret="aws-secret",
    key="aws_secret_access_key",
)
SNOWFLAKE_ACCOUNT = Secret(
    "env",
    "SNOWFLAKE_ACCOUNT",
    "dbt",
    "SNOWFLAKE_ACCOUNT",
)
SNOWFLAKE_TRANSFORM_USER = Secret(
    "env",
    "SNOWFLAKE_TRANSFORM_USER",
    "dbt",
    "SNOWFLAKE_TRANSFORM_USER",
)
SNOWFLAKE_TRANSFORM_PASSWORD = Secret(
    "env",
    "SNOWFLAKE_TRANSFORM_PASSWORD",
    "dbt",
    "SNOWFLAKE_TRANSFORM_PASSWORD",
)
SNOWFLAKE_TRANSFORM_ROLE = Secret(
    "env",
    "SNOWFLAKE_TRANSFORM_ROLE",
    "dbt",
    "SNOWFLAKE_TRANSFORM_ROLE",
)
SNOWFLAKE_TRANSFORM_WAREHOUSE = Secret(
    "env",
    "SNOWFLAKE_TRANSFORM_WAREHOUSE",
    "dbt",
    "SNOWFLAKE_TRANSFORM_WAREHOUSE",
)
SNOWFLAKE_TRANSFORM_DATABASE = Secret(
    "env",
    "SNOWFLAKE_TRANSFORM_DATABASE",
    "dbt",
    "SNOWFLAKE_TRANSFORM_DATABASE",
)
