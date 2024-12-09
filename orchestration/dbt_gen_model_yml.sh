#!/bin/bash
# Function to print usage instructions
function usage() {
    echo "Usage: $0 -m <model1,model2,...> -l <layer> -s <source_name>"
    echo ""
    echo "Example:"
    echo "    $0 -m opportunities,leads -l staging -s salesforce"
    exit 1
}

# Check if required arguments are provided
while getopts ":m:l:s:" opt; do
  case $opt in
    m) model_names="$OPTARG"
    ;;
    l) layer="$OPTARG"
    ;;
    s) source_name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done

# Check if all arguments are provided
if [[ -z "$model_names" || -z "$layer" || -z "$source_name" ]]; then
    usage
fi

# Convert the model names to JSON list format (split by commas)
model_names_json=$(echo "$model_names" | sed 's/,/","/g')
model_names_json="[\"$model_names_json\"]"

cd "transform/mainkode_analytics"

# Set the output file using layer and source_name
yaml_output_file="models/$layer/$source_name/_${source_name}__models.yml"

# Generate the model YAML for all models in one command
dbt --quiet run-operation generate_model_yaml --no-use-colors --args "{\"model_names\": $model_names_json}" > "$yaml_output_file"

# Check if the model YAML file was created and has content
if [[ -s "$yaml_output_file" ]]; then
    echo "Model YAML generated successfully at $yaml_output_file"
else
    echo "Error: The file was not generated or is empty."
    exit 1
fi
