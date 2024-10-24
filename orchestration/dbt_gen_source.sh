#!/bin/bash
# Function to print usage instructions
function usage() {
    echo "Usage: $0 -s <schema_name> -d <database_name> -t <table1,table2,...> -l layer"
    echo ""
    echo "Example:"
    echo "    $0 -s salesforce -d raw_dev -t opportunities,leads -l staging"
    exit 1
}

# Check if required arguments are provided
while getopts ":s:d:t:l:" opt; do
  case $opt in
    s) schema_name="$OPTARG"
    ;;
    d) database_name="$OPTARG"
    ;;
    t) table_names="$OPTARG"
    ;;
    l) layer="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done

# Check if all arguments are provided
if [[ -z "$schema_name" || -z "$database_name" || -z "$table_names" || -z "$layer" ]]; then
    usage
fi

# Convert the table names to JSON list format (split by commas)
table_names_json=$(echo "$table_names" | sed 's/,/","/g')
table_names_json="[\"$table_names_json\"]"

cd "transform/mainkode_analytics"
# Create the directory structure dynamically using schema_name and layer
target_directory="models/$layer/$schema_name"
mkdir -p "$target_directory" || { echo "Error: Could not create directory $target_directory"; exit 1; }

# Run dbt run-operation and capture the result in a new file
dbt_output_file="$target_directory/_${schema_name}__sources.yml"

dbt --quiet run-operation generate_source --no-use-colors --args "{\"schema_name\": \"$schema_name\", \"database_name\": \"$database_name\", \"table_names\": $table_names_json, \"generate_columns\": true}" > "$dbt_output_file"

# Check if the file was created and has content
if [[ -s "$dbt_output_file" ]]; then
    echo "Source YAML generated successfully at $dbt_output_file"
else
    echo "Error: The file was not generated or is empty."
    exit 1
fi
