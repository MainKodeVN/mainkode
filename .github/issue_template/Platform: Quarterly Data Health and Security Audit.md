# Quarterly Data Health and Security Audit

This audit checks if people have the correct access to systems and ensures data feeds are working well. Each item should be completed quarterly. 

## Checklist

### Snowflake
- [ ] Validate that terminated employees are removed from Snowflake. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/snowflake.md#validate-terminated-employees-have-been-removed-from-snowflake-access)
- [ ] Deactivate accounts inactive for 60+ days. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/snowflake.md#de-activate-any-account-that-has-not-logged-in-within-the-past-60-days-from-the-moment-of-performing-audit-from-snowflake)
- [ ] Ensure no user accounts have passwords set. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/snowflake.md#validate-all-user-accounts-do-not-have-password-set)
- [ ] Drop any unused (orphaned) tables. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/snowflake.md#drop-orphaned-tables)

### DBT Execution
- [ ] Generate a report on the top 25 longest-running dbt models. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/dbt.md)

### Airflow
- [ ] Remove access for former employees. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/airflow.md#validate-off-boarded-employees-have-been-removed-from-airflow-access)
- [ ] Clean up old log files. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/airflow.md#clean-up-old-log-files)

### Tableau
- [ ] Remove access for former employees and purge their data. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/tableau.md#validate-offboarded-employees-have-been-removed-from-tableau-cloud-and-purge-from-systems)
- [ ] Deactivate accounts inactive for 90+ days. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/tableau.md#deprovision-access-if-a-user-has-had-access-for-90-days-but-have-not-logged-in-during-the-past-90-days-from-the-moment-of-performing-audit)
- [ ] Downgrade roles for inactive users. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/tableau.md#downgrade_inactive_role_users)
- [ ] Update Snowflake service account credentials. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/tableau/update_service_account_password.md?ref_type=heads)

### Package Version Inventory
- [ ] Check versions of Python and other tools/libraries. [Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/quarterly_data_health_and_security_audit/package_inventory.md#package-version-inventory)

---

### Labels
Apply the following labels for tracking:
- **~Team::Data Platform**
- **~Snowflake**
- **~TDF**
- **~Data Team**
- **~Priority::1-Ops**
- **~workflow::4 - scheduled**
- **~Quarterly Data Health and Security Audit**
- **~Periscope / Sisense**

---

/confidential