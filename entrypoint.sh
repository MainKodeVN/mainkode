#!/bin/bash
set -e

# Print environment variables for debugging
echo "Running entrypoint script..."
echo "S3_TARGET_PATH: $S3_TARGET_PATH"

# execute DBT with arguments from container launch
dbt "$@"

# Check if S3_TARGET_PATH is provided and copy file if it is
if [ -n "$S3_TARGET_PATH" ]; then
    echo "Copying file..."
    aws s3 cp mainkode_analytics/target/manifest.json "$S3_TARGET_PATH"
else
    echo "S3_TARGET_PATH is not set, skipping file copy."
fi
