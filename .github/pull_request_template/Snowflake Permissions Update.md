# Snowflake Access and Role Management Template

## Issue
Closes #  
<!--- Link the Issue this MR closes --->

## Checklist

### Format Validation

- [ ] YAML validator passes.

### User Management

- [ ] For new users, ensure there is a corresponding user role with `securityadmin` as the owner.

### Role Management

- [ ] For new roles, confirm creation in Snowflake with `securityadmin` as the owner.
- [ ] Ensure the user is granted access only through a user role (unless overridden).

### Database Objects

- [ ] For new tables, ensure they exist in Snowflake or will be introduced and refreshed post-merge.
- [ ] Create schemas with appropriate roles:
  - On `RAW` with the `LOADER` role.
  - On `PREP` and `PROD` with the `TRANSFORMER` role.
- [ ] For new `PROD` schemas, update the [`grant_usage_in_schemas.sql`](https://gitlab.com/gitlab-data/analytics/-/blob/master/transform/snowflake-dbt/macros/warehouse/grant_usage_to_schemas.sql) macro.
- [ ] Run Monte Carlo permissions script for the relevant schema, applying permissions to the `data_observability` role.
- [ ] Verify that any new warehouses are created in Snowflake and appropriately sized.

### Pre-Merge Steps

- [ ] Execute the [permifrost_manual_spec_test](https://about.gitlab.com/handbook/business-technology/data-team/platform/ci-jobs/#permifrost_manual_spec_test) to ensure correct specifications.

### ⚠ Unsupported Permissions Check ⚠

- [ ] For role renaming, run `show grants` to check for task or stage permissions.
