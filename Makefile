DBT_GEN_MODEL_YML := ./orchestration/dbt_gen_model_yml.sh
DBT_GEN_SOURCE := ./orchestration/dbt_gen_source.sh
DBT_GEN_STAGING_MODEL := ./orchestration/dbt_gen_staging_model.sh

# Target to run dbt_gen_model_yml.sh
.PHONY: generate-model-yml
generate-model-yml:
	@echo "Running dbt_gen_model_yml.sh to generate model YAML files..."
	@echo "Model Names: $(MODEL_NAMES)"
	@echo "Layer: $(LAYER)"
	@echo "Source Name: $(SOURCE_NAME)"
	$(DBT_GEN_MODEL_YML) -m $(MODEL_NAMES) -l $(LAYER) -s $(SOURCE_NAME)

# Target to run dbt_gen_source.sh
.PHONY: generate-source-yml
generate-source-yml:
	@echo "Running dbt_gen_source.sh to generate source YAML files..."
	@echo "Schema Name: $(SCHEMA_NAME)"
	@echo "Database Name: $(DATABASE_NAME)"
	@echo "Table Names: $(TABLE_NAMES)"
	@echo "Layer: $(LAYER)"
	$(DBT_GEN_SOURCE) -s $(SCHEMA_NAME) -d $(DATABASE_NAME) -t $(TABLE_NAMES) -l $(LAYER)

# Target to run dbt_gen_staging_model.sh
.PHONY: generate-staging-model
generate-staging-model:
	@echo "Running dbt_gen_staging_model.sh to generate staging model SQL files..."
	@echo "Schema Name: $(SCHEMA_NAME)"
	@echo "Table Names: $(TABLE_NAMES)"
	$(DBT_GEN_STAGING_MODEL) -s $(SCHEMA_NAME) -t $(TABLE_NAMES)

# Help target for guidance
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  generate-model-yml      - Generate model YAML files for dbt models."
	@echo "  generate-source-yml     - Generate source YAML files for dbt sources."
	@echo "  generate-staging-model  - Generate staging model SQL files for dbt models."
	@echo "  help                    - Show this help message."
	@echo ""
	@echo "Usage Examples:"
	@echo "  make generate-model-yml MODEL_NAMES=\"opportunities,leads\" LAYER=\"staging\" SOURCE_NAME=\"salesforce\""
	@echo "  make generate-source-yml SCHEMA_NAME=\"salesforce\" DATABASE_NAME=\"raw_dev\" TABLE_NAMES=\"opportunities,leads\" LAYER=\"staging\""
	@echo "  make generate-staging-model SCHEMA_NAME=\"salesforce\" TABLE_NAMES=\"opportunities,leads\""
