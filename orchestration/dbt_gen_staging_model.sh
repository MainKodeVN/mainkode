#!/bin/bash
# Function to print usage instructions
function usage() {
    echo "Usage: $0 -s <schema_name> -t <table1,table2,...>"
    echo ""
    echo "Example:"
    echo "    $0 -s salesforce -t opportunities,leads"
    exit 1
}

# Check if required arguments are provided
while getopts ":s:d:t:p:" opt; do
  case $opt in
    s) schema_name="$OPTARG"
    ;;
    t) table_names="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done

# Check if all arguments are provided
if [[ -z "$schema_name" || -z "$table_names" ]]; then
    usage
fi

# Convert the table names to JSON list format (split by commas)
table_names_json=$(echo "$table_names" | sed 's/,/","/g')
table_names_json="[\"$table_names_json\"]"

cd "transform/mainkode_analytics"
# Create the directory structure dynamically using schema_name
target_directory="models/staging/$schema_name"
mkdir -p "$target_directory" || { echo "Error: Could not create directory $target_directory"; exit 1; }

# Generate the base models for each table
IFS=',' read -ra tables <<< "$table_names"
for table_name in "${tables[@]}"; do
    base_model_output_file="$target_directory/stg_${schema_name}__${table_name}.sql"
    
    dbt --quiet run-operation generate_base_model --no-use-colors --args "{\"source_name\": \"$schema_name\", \"table_name\": \"$table_name\"}" > "$base_model_output_file"
    
    # Check if the base model SQL file was created and has content
    if [[ -s "$base_model_output_file" ]]; then
        echo "Staging model SQL generated successfully at $base_model_output_file"
    else
        echo "Error: The file was not generated or is empty."
        exit 1
    fi
done
