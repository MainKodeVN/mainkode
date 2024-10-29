# DBT Change Template

For changes to the `/transform` directory, including dbt models, tests, seeds, and docs. Refer to the [dbt change workflow](https://handbook.gitlab.com/handbook/business-technology/data-team/how-we-work/dbt-change-workflow/) for detailed steps.

## Plan

### Scope
- **Issue**: Link the issue this MR closes.
- **Description**: Briefly describe the planned changes. Include links to related MRs/issues.

### Tests
- Define the tests needed to verify the changes’ impact and coverage.

### Environment
- List the models and setup needed for local testing.

## Create

- Set up your local environment based on the plan, implement changes, and perform local testing.
- Document local test results here.

## Verify

- Use the CI environment for remote testing.
- Document remote test results for review.

### Review Checklist

1. [ ] Check for Entity Relationship Diagram updates, if needed.
2. [ ] Ensure changes have been adequately tested.
3. [ ] Confirm all CI jobs have run and passed.
4. [ ] Evaluate impacts on downstream tables and reports.
5. [ ] Review masking policies on any affected columns.
6. [ ] Assess changes against the dbt and SQL style guides.

#### Compliance Review
- [ ] Pipelines completed successfully.
- [ ] Documentation updated where applicable.
- [ ] Check SQL style and performance impact.
- [ ] Ensure compliance with CI/testing requirements.

## References

- **EDM Documentation**: Reflect changes in ERDs and `schema.yml` files.
- **Testing**: Implement component and integration tests per guidelines.
- **Style & Structure**: Follow the [dbt Style Guide](https://handbook.gitlab.com/handbook/business-technology/data-team/platform/dbt-guide/#style-and-usage-guide).
- **Pipelines**: Select and run the appropriate CI job. Refer to [CI job guidance](https://handbook.gitlab.com/handbook/business-technology/data-team/platform/ci-jobs/#build_changes).
- **Performance**: Follow the [dbt Model Performance runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/dbt_performance/model_build_performance.md).

<details>
<summary><b>Additional Guidelines</b></summary>

- **Incremental Models**: A full refresh may be needed if the structure or business logic changes.
- **Salesforce Models**: Check if changes affect `sfdc_*` models and if a full refresh is required.
- **Schema/Model Name Changes**: Evaluate downstream impacts and ensure data observability permissions are updated.
- **Snapshot Models**: Ensure GitLab.com data complies with GDPR deletion requirements.

</details>
