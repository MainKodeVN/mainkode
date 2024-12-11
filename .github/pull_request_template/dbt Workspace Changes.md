# DBT Workspace Change Template

For dbt code changes in a `workspace` folder. Review the [workspace guidelines](https://about.gitlab.com/handbook/business-ops/data-team/platform/dbt-guide/index.html#workspaces) for more details.

## Issue
- Link the Issue this MR closes: `Closes #`

## Workspace Code Checks

- [ ] Code is in the correct workspace folder (`/transform/snowflake-dbt/models/workspace_<yourspace>`).
- [ ] Validate that no sensitive data is exposed.
- [ ] Ensure the code runs successfully. Use [CI jobs](https://about.gitlab.com/handbook/business-technology/data-team/platform/ci-jobs) to check table exports.
- [ ] Determine if updates to `dbt_project.yml` are needed.
- [ ] Consider if any CODEOWNERS need to be added.
- [ ] Add tests if useful (not required for workspace models).
- [ ] Update `dbt_analytics` role in `roles.yml` for new schemas to grant read access.
- [ ] Run the `permifrost_spec_test` pipeline if there are new schemas or updates to `permissions.yml`.

## Submission Checklist

- [ ] Set the branch to delete after merging (do not squash commits).
- [ ] Latest CI pipeline passes. Provide an explanation if not.
- [ ] Logic reviewed by a functional analyst. Provide an explanation if not.
- [ ] Confirm this MR is ready for final review and merge.
- [ ] Remove the `Draft:` prefix from the MR title.
- [ ] Assign to a reviewer and specify it’s for a team workspace model, requiring minimal Data team review.

## Reviewer Checklist

- [ ] Confirm that the code runs successfully.
- [ ] Validate that there are no major issues in the code.
- [ ] Approve and merge the MR.