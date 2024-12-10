# Data Triage Process

This guide outlines the steps for managing data triage tasks. It includes daily tasks for Data Analysts, Analytics Engineers, and Data Engineers to ensure data issues are identified, addressed, and documented efficiently.

## Getting Started

1. **Title the Issue**: Format as "YYYY-MM-DD Data Triage" (e.g., **2020-07-09 Data Triage**).
2. **Assign Team Members**: Assign the issue to the Data Analyst, Analytics Engineer, and Data Engineer handling triage.
3. **Add a Weight**: Add a priority weight to the issue (see [issue pointing guide](https://about.gitlab.com/handbook/business-ops/data-team/how-we-work/#issue-pointing)).
4. **Link Issues**: 
   - Link any related issues.
   - Connect today’s triage issue to the previous day’s triage issue for continuity.

---

## Tasks by Role

### Data Analyst

1. **Slack Channel Monitoring**: 
   - Respond to messages in the **#data** Slack channel. 
   - Provide relevant links to handbook pages or visualizations.
   - Direct complex requests to the Data team project or relevant triage group.

2. **Friends and Family Days**: 
   - If a no-merge day is coming up, notify the team in **#data** by Tuesday.
   - Example message: 
     ```
     Reminder: Due to the upcoming family and friends day, the last day to merge MRs this week is Wednesday.
     ```

### Analytics Engineer

1. **Monitor DBT Models**: 
   - Check the **#analytics-pipelines** channel for DBT model issues.
   - For each issue, add `Workflow::start (triage)`, `Triage`, and other relevant labels.
   - Assign issues based on DBT model owners or ask the Data Manager if unsure.

2. **Create Issues for DBT Failures**: 
   - For DBT model or test failures, create issues using the [AE issue template](https://gitlab.com/gitlab-data/analytics/issues/new?issuable_template=Triage%3A%20Errors%20AE).
   - Post links to the issues in **#analytics-pipelines**.

3. **Address Active Failures**: 
   - Investigate active failures and update the Monte Carlo status on Slack.
   - If a failure is critical, create an incident issue for immediate action.

4. **End-of-Day Reporting**: 
   - Post a summary in **#analytics-pipelines** and **#data-triage** with a link to the issue for the next triager.

### Data Engineer

1. **Respond to Pipeline Alerts**: 
   - Check **#data-pipelines** and **#data-prom-alerts** for alerts.
   - Update Monte Carlo status and create issues for failures.

2. **Monitor Schema Changes**: 
   - Review merge requests for any database changes.
   - Address unresolved alerts on Monte Carlo.

3. **Send Delay Notifications**: 
   - If there are data delays, use pre-written templates to notify stakeholders in Slack.

4. **End-of-Day Reporting**: 
   - Post a summary in **#data-pipelines** with a link to the issue, marking all alerts as handled.

---

## Additional Guidelines

- **Sensitive Data**: Some columns may be nullified for privacy. Refer to the [Sensitive Data Handbook](https://internal.gitlab.com/handbook/enterprise-data/platform/sensitive-data/) for more information.
- **Closing the Day**: Apply labels and assign the issue for tracking. This helps with documentation and ensures follow-up on unresolved items.

### Labels
Apply the following labels for tracking:
- **~workflow::In dev**
- **~Housekeeping**
- **~Data Team**
- **~Documentation**
- **~Triage**
- **~Priority::1-Ops**
