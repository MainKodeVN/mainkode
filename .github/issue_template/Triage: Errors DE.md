## Triage Summary

**Subject**: Format should be `YYYY-MM-DD | task name | Error line from log`  
**Notification Link**: Provide a link to the Airflow log or relevant incident  
**Error Description**: Include detailed error information here  

### Skipped Tasks
- List any downstream Airflow tasks or dbt models that were skipped. If none, write “None.”

## DE Triage Guidelines

For common issues, refer to the [triage handbook](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/triage/#triage-common-issues).

<details>
<summary><b>Source Freshness Failures</b></summary>

1. [ ] Confirm that the error is not due to our internal process. If it’s not, it’s likely an external issue.
2. [ ] Check the [source contact spreadsheet](https://docs.google.com/spreadsheets/d/1VKvqyn7wy6HqpWS9T3MdPnE6qbfH2kGPQDFg2qPcp6U/edit#gid=0) to find the appropriate contact.
3. [ ] Add a label identifying the affected source.

</details>

---
### Labels
Apply the following labels for tracking:
- **~Triage**
- **~Team::Data Platform**
- **~Break-Fix**
- **~Priority::1-Ops**
- **~workflow::1 - triage**