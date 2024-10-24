# Makefile for SQLFluff linting and fixing in a dbt project

# Default directories and files
MODELS_DIR := models/
DEV_BRANCH := $(DEV)  # Allows passing the branch dynamically as DEV
SQL_FILES := $(shell git diff --name-only $(DEV_BRANCH) -- '*.sql')

# Default target: lint all SQL files
lint:
	@echo "Linting all SQL files in the $(MODELS_DIR) directory..."
	sqlfluff lint $(MODELS_DIR)

# Target to lint only changed SQL files compared to the provided branch (DEV)
lint-changed:
	@if [ -z "$(DEV_BRANCH)" ]; then \
		echo "Error: No branch provided. Use 'make lint-changed DEV=<branch_name>'."; \
		exit 1; \
	fi
	@echo "Linting changed SQL files compared to $(DEV_BRANCH)..."
	@if [ -z "$(SQL_FILES)" ]; then \
		echo "No changed SQL files to lint."; \
	else \
		echo "$(SQL_FILES)" | xargs sqlfluff lint; \
	fi

# Target to fix all SQL files
fix:
	@echo "Fixing all SQL files in the $(MODELS_DIR) directory..."
	sqlfluff fix $(MODELS_DIR)

# Target to fix only changed SQL files compared to the provided branch (DEV)
fix-changed:
	@if [ -z "$(DEV_BRANCH)" ]; then \
		echo "Error: No branch provided. Use 'make fix-changed DEV=<branch_name>'."; \
		exit 1; \
	fi
	@echo "Fixing changed SQL files compared to $(DEV_BRANCH)..."
	@if [ -z "$(SQL_FILES)" ]; then \
		echo "No changed SQL files to fix."; \
	else \
		echo "$(SQL_FILES)" | xargs sqlfluff fix; \
	fi

# Optional: lint a specific model provided via the MODEL variable
lint-model:
	@echo "Linting the provided model: $(MODEL)"
	sqlfluff lint $(MODELS_DIR)/$(MODEL)

# Optional: fix a specific model provided via the MODEL variable
fix-model:
	@echo "Fixing the provided model: $(MODEL)"
	sqlfluff fix $(MODELS_DIR)/$(MODEL)

# Help message for makefile
help:
	@echo "Available targets:"
	@echo "  make lint           - Lint all SQL files in the $(MODELS_DIR) directory"
	@echo "  make lint-changed DEV=<branch_name>   - Lint only the changed SQL files compared to the provided DEV branch"
	@echo "  make fix            - Automatically fix all SQL files in the $(MODELS_DIR)"
	@echo "  make fix-changed DEV=<branch_name>    - Automatically fix only the changed SQL files compared to the provided DEV branch"
	@echo "  make lint-model MODEL=<model>  - Lint a specific model"
	@echo "  make fix-model MODEL=<model>   - Fix a specific model"
