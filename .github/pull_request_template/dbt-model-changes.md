# DBT Change Template
<!---
See a demo of this PR template in use: https://github.com/DataRecce/jaffle_shop_duckdb/pull/1
Adapted from the official dbt pull request template: https://docs.getdbt.com/blog/analytics-pull-request-template
For a detailed explanation of this template please refer to: https://medium.com/inthepipeline/de06f12fc38d
-->

<!---
Provide a short summary in the Title above. Examples of good PR titles:
* "Feature: add so-and-so models"
* "Fix: deduplicate such-and-such"
* "Update: dbt version 0.13.0"
-->

## Description & motivation
<!---
Describe your changes, and why you're making them. Include what your expected outcomes and impact on the data will be.
-->

## Related Issues
<!---
Link to any related GitHub issues, internal tickets, or team chats that will help clarify the background of this PR and add more context to your work.
-->

## Type of Change
<!-- 
Classify the type of change you're working on to help the reviewer know what they should look out for
-->
- [ ] New model
- [ ] Bugfix
- [ ] Refactoring
- [ ] Breaking change
- [ ] Documentation

## To-do before merge
<!---
(Optional -- remove this section if not needed)
Include any notes about things that need to happen before this PR is merged, e.g.:
- [ ] Change the base branch
- [ ] Update dbt Cloud jobs
- [ ] Ensure PR #56 is merged
-->

## Lineage DAG:
<!---
Include a screenshot of the relevant section of the updated DAG. You can access
your version of the DAG by running `dbt docs generate && dbt docs serve`.
Include a DataRecce.io Lineage Diff to only show the modified and potentially impacted section of the DAQ.  
-->

## Validation of models:
<!---
Include any output that confirms that the models do what is expected. This might
be a link to an in-development dashboard in your BI tool, or a query that
compares an existing model with a new one.

Use screenshots of queries and results that demonstrate the impact of your changes. 

Use the DataRecce.io toolkit to show how models have changed between dev and prod. Include ad-hoc queries, data profiling results, or schema and row count diffs where relevant.
-->

## dbt test results:
<!---
Post the output from your dbt tests here.
-->

## Impact Considerations:
<!---
If there are any downstream models impacted as a result of your work, include validation
that these models have/have not been impacted and what considerations are required,
such as notifying stakeholders.
As with validation of models, use screenshots and queries to illustrate the impact.
-->

## Changes to existing models:
<!---
Include this section if you are changing any existing models. Link any related
pull requests on your BI tool, or instructions for merge (e.g. whether old
models should be dropped after merge, or whether a full-refresh run is required)
-->

## Checklist:
<!---
This checklist is mostly useful as a reminder of small things that can easily be
forgotten – it is meant as a helpful tool rather than hoops to jump through.
Put an `x` in all the items that apply, make notes next to any that haven't been
addressed, and remove any items that are not relevant to this PR.
-->
- [ ] My pull request represents one logical piece of work.
- [ ] My commits are related to the pull request and look clean.
- [ ] My models follows the [How we style our dbt models](https://docs.getdbt.com/best-practices/how-we-style/1-how-we-style-our-dbt-models).
- [ ] `dbt build` completes successfully and dbt tests pass (if not, detail why)
- [ ] I have materialized my models appropriately.
- [ ] I have added appropriate tests and documentation to any new models.
- [ ] I have updated the README file.
- [ ] I have confirmed all CI jobs have run and passed.
- [ ] I have evaluated impacts on downstream tables and reports.
- [ ] I have reviewed masking policies on any affected columns.