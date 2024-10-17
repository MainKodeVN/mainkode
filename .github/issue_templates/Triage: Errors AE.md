## Triage Summary

**Subject**: Use format `YYYY-MM-DD | task name | Error line from log`  
**Notification Link**: Link to the Airflow log  
**Error Description**: Provide details from the log

### Skipped Tasks
- List any downstream tasks or models that were skipped. If none, write “None.”

## AE Triage Guidelines

<details>
<summary><b>Identifying Failing DBT Models</b></summary>

If the Airflow job log does not show which models failed, use these SQL queries:

**To find failing models:**
```sql
SELECT
  model_unique_id,
  status,
  message,
  generated_at,
  SPLIT_PART(model_unique_id, '.', 3) AS model_name
FROM prep.dbt.DBT_RUN_RESULTS_SOURCE
WHERE status NOT IN ('success') 
  AND TO_DATE(generated_at)='YYYY-MM-DD'
ORDER BY generated_at DESC;
```

**To find failing tests:**
```sql
WITH test_results AS (
  SELECT
    *,
    SPLIT_PART(test_unique_id, '.', 3) AS test_name
  FROM "PREP"."DBT"."DBT_TEST_RESULTS_SOURCE"
)
SELECT
  *
FROM test_results
WHERE DATE_TRUNC('day', uploaded_at) BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD'
  AND status = 'fail'
ORDER BY uploaded_at DESC, status;
```

</details>

<details>
<summary><b>DBT Model/Test Failure Resolution</b></summary>

**DBT Run Triage Checklist**:
1. [ ] Check dbt audit columns to see who created or last updated the model.
1. [ ] If the model is less than one month old, assign the failure to the creator for resolution.
1. [ ] For older models, run the model locally to confirm the error.
1. [ ] Review the git log for recent changes. 
   - [ ] If it’s a simple fix (e.g., syntax error), create an MR with the correction.
   - [ ] For complex issues, tag the CODEOWNER for assistance.
   - [ ] If a deep investigation is needed, escalate to the Lead Analytics Engineer.

1. [ ] Notify the **#data** Slack channel about the error, and update when resolved.

**DBT Test Triage Checklist**:
1. [ ] Confirm if there is a monitor for the failure.
1. [ ] For tests like row count, consider moving to an alternative monitoring tool if more effective.
1. [ ] Evaluate whether to migrate test failures based on effectiveness.

**Chronic Failure Resolution Checklist**:
1. [ ] Identify if the root cause is related to an upstream system.
1. [ ] Check if the issue relates to a timeout or recurring error.
1. [ ] For multiple tests failing due to the same cause, consider deprecating redundant tests.

</details>

---

### Labels
Apply the following labels for tracking:
- **~Triage**
- **~Break-Fix**
- **~Priority::1-Ops**
- **~workflow::1 - triage**
- **~Triage::Analytics**