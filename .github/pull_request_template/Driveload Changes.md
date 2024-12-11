# Driveload File Change Template

Use this template for adding or updating a driveload file. For more guidance, refer to the relevant handbook pages.

## Issue
- Link the Issue this MR closes: `Closes #`

## Solution
- **Data Source Link**: Provide link to CSV/GSheet: `____`
- **Sensitive Data**: Does the data contain sensitive information? (Check our [Data Classification Policy](https://about.gitlab.com/handbook/engineering/security/data-classification-standard.html#data-classification-levels))
  - [ ] Yes
  - [ ] No
  - [ ] Unsure
- **Data Retention**: How long should the data reside in the warehouse? Expiration Date: `______`

## Adding/Updating a Driveload File

<details><summary>Click to Expand the Process</summary>

1. [ ] **Step 1**: Create a Google Drive folder and upload the file (.csv only).
2. [ ] **Step 2**: Share the folder with required service accounts [here](https://docs.google.com/document/d/1m8kky3DPv2yvH63W4NDYFURrhUwRiMKHI-himxn1r7k/edit?usp=sharing).
   - Ensure sharing with both runner and Airflow service accounts.
3. [ ] **Step 3**: Edit the `drives.yml` file in `extract/sheetload/` to add file and folder details.
4. [ ] **Step 4**: Update `sources.yml` in `transform/snowflake-dbt/models/sources/driveload/`.
5. [ ] **Step 5**: Add the base model `.sql` file for the new driveload file.
6. [ ] **Step 6**: Update `schema.yml` with model descriptions.
7. [ ] **Step 7**: If necessary, create a workspace folder and update `schema.yaml` to add your model.
8. [ ] **Step 8**: Add description details to `schema.yaml` for the workspace model.

Refer to the [source models](https://about.gitlab.com/handbook/business-ops/data-team/platform/dbt-guide/#source-models) vs [staging models](https://about.gitlab.com/handbook/business-ops/data-team/platform/dbt-guide/#staging) guide for more clarity.

</details>

## Testing

<details><summary>Click to Expand Testing Steps</summary>

1. [ ] **Test**: Add necessary dbt tests in a `schema.yml` file (unique, not nullable, foreign key constraints).
2. [ ] **Trusted Data Framework**: Integrate into the [TDF](https://about.gitlab.com/handbook/business-technology/data-team/platform/#tdf).
3. [ ] **Data Test**: If using Data Tests, run `dbt test` locally and paste results below.

</details>

## CI Jobs to Run

- [ ] `❄️ Snowflake: clone_raw_specific_schema` (Pass `SCHEMA_NAME` as `driveload`)
- [ ] `Extract: driveload`
- [ ] `⚙️ dbt Run: build_changes`

## Final Steps

- [ ] Assign MR to a project maintainer for review and iterations.
- [ ] Merge dbt models after review.
- [ ] Trigger driveload DAG in Airflow if data is needed urgently.
- [ ] Validate table in Sisense with a simple query:
  ```sql
  SELECT * FROM [new-dbt-model-name] LIMIT 10
  ```

## MR Checklist

- [ ] Follows the [SQL style guide](https://about.gitlab.com/handbook/business-ops/data-team/platform/sql-style-guide/).
- [ ] Label hygiene on issue.
- [ ] Branch set to delete, commits unsquashed.
- [ ] Latest CI pipeline passes, with explanation for any failures.
- [ ] MR is ready for final review.
- [ ] All threads resolved, `Draft:` removed from MR title, and assigned to reviewer.

## Reviewer Checklist

- [ ] Ensure all checks are passed before merging.

## Further Changes

- [ ] **AUTHOR**: Uncheck all boxes before taking further action.
