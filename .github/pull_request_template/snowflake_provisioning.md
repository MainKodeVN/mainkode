## Snowflake User Management Template

### Add/Remove Users

1. [ ] Link to Snowflake Access Request: `<>`
1. [ ] Update [snowflake_users.yml](https://gitlab.com/gitlab-data/analytics/-/blob/master/permissions/snowflake/snowflake_users.yml?ref_type=heads) with the new user(s):
   - Exclude `@gitlab.com` from usernames.
   - Add users in **alphabetical order** to minimize conflicts.
1. [ ] Run CI Job: `snowflake_provisioning_roles_yaml`
1. [ ] Assign to CODEOWNER for review.

### Reviewer Checklist

1. [ ] Verify MR aligns with the Access Request.
   - If a role beyond `snowflake_analyst` is requested, update `roles.yml` manually or via CI job [details here](https://handbook.gitlab.com/handbook/business-technology/data-team/platform/ci-jobs/#further-explanation-1).
1. **Run CI Jobs Concurrently**:
   - [ ] Trigger a new CI pipeline manually to unlock CI jobs.
     <details><summary>Screenshot for Manual Trigger</summary>

     ![image](/uploads/2a5ecbdf3adc6093069bf8951282af43/image.png){width=525 height=116}
     </details>
   - [ ] Run CI Job: `snowflake_provisioning_snowflake_users`
   - [ ] Run CI Job: `🧊permifrost_spec_test`
1. [ ] Merge the MR.
1. [ ] Update the [Snowflake Okta Google Group](https://groups.google.com/a/gitlab.com/g/okta-snowflake-users/members?pli=1) by adding/removing user emails.
1. [ ] Comment in the Access Request:
   ```md
   Snowflake provisioning is complete. Changes will be effective at 1:30AM UTC / 5:30PM PST.

   Refer to this [handbook section](https://handbook.gitlab.com/handbook/business-technology/data-team/platform/#logging-in-and-using-the-correct-role) for login guidance.
   ```

### Runbook
For further guidance, refer to the [Snowflake Provisioning Runbook](https://gitlab.com/gitlab-data/runbooks/-/blob/main/snowflake_provisioning_automation/snowflake_provisioning_automation.md).

---

#### Issue Labels for Tracking

Apply the following labels to the issue for better tracking and categorization:
- **~Priority::1-Ops**
- **~Team::Data Platform**
- **~Snowflake**
- **~Provisioning**