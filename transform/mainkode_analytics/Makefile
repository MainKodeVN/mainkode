# Default directories and files
MODELS_DIR := models/
TARGET_BRANCH := $(BRANCH)  # Allows passing the branch dynamically as BRANCH
SQL_FILES := $(shell (git diff --name-only --diff-filter=ACMRT $(TARGET_BRANCH) -- '*.sql'; git ls-files --others --exclude-standard -- '*.sql') | sed -n 's|.*$(MODELS_DIR)|$(MODELS_DIR)|p')

# Default target: lint all SQL files
lint:
	@echo "Linting all SQL files in the $(MODELS_DIR) directory..."
	sqlfluff lint $(MODELS_DIR)

# Target to lint both changed and new (untracked) SQL files
lint-changed-new:
	@if [ -z "$(TARGET_BRANCH)" ]; then \
		echo "Error: No branch provided. Use 'make lint-changed-new BRANCH=<branch_name>'."; \
		exit 1; \
	fi
	@echo "Linting changed and new SQL files compared to $(TARGET_BRANCH)..."
	@if [ -z "$(SQL_FILES)" ]; then \
		echo "No changed or new SQL files to lint."; \
	else \
		echo "$(SQL_FILES)" | xargs sqlfluff lint; \
	fi

# Target to fix both changed and new (untracked) SQL files
fix-changed-new:
	@if [ -z "$(TARGET_BRANCH)" ]; then \
		echo "Error: No branch provided. Use 'make fix-changed-new BRANCH=<branch_name>'."; \
		exit 1; \
	fi
	@echo "Fixing changed and new SQL files compared to $(TARGET_BRANCH)..."
	@if [ -z "$(SQL_FILES)" ]; then \
		echo "No changed or new SQL files to fix."; \
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

# Target to fix all SQL files
fix:
	@echo "Fixing all SQL files in the $(MODELS_DIR) directory..."
	sqlfluff fix $(MODELS_DIR)

# Help message for makefile
help:
	@echo "Available targets:"
	@echo "  make lint           - Lint all SQL files in the $(MODELS_DIR) directory"
	@echo "  make lint-changed-new BRANCH=<branch_name>   - Lint both changed and new (untracked) SQL files compared to the provided TARGET_BRANCH"
	@echo "  make fix            - Automatically fix all SQL files in the $(MODELS_DIR)"
	@echo "  make fix-changed-new BRANCH=<branch_name>    - Automatically fix both changed and new (untracked) SQL files compared to the provided TARGET_BRANCH"
	@echo "  make lint-model MODEL=<model>  - Lint a specific model"
	@echo "  make fix-model MODEL=<model>   - Fix a specific model"
