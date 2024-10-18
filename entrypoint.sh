#!/bin/bash
set -e

# Print environment variables for debugging
echo "Running entrypoint script..."
echo "DBT_ARTIFACT: $DBT_ARTIFACT"
echo "S3_TARGET_PATH: $S3_TARGET_PATH"

# execute DBT with arguments from container launch
dbt "$@"

# Check if S3_TARGET_PATH is provided and copy file if it is
if [ -n "$S3_TARGET_PATH" ]; then
    echo "source: $DBT_ARTIFACT, target: $S3_TARGET_PATH"
    echo "Copying file..."
    aws s3 cp "$DBT_ARTIFACT" "$S3_TARGET_PATH"
else
    echo "S3_TARGET_PATH is not set, skipping file copy."
fi
