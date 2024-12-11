### Offboarding Checklist: Data Team Member

This checklist ensures the secure and thorough offboarding of Data Team members, covering removal from systems, permissions, and resources. Complete each step to ensure compliance with security protocols.

#### Remove User from Systems and Resources

- [ ] Remove from Data Team group and all associated projects.
- [ ] Remove from Codeowners in the handbook.
- [ ] Remove from Triage schedule, if applicable.
- [ ] Remove access from ETL tools:
  - [ ] Stitch
  - [ ] Fivetran
- [ ] Remove access from Snowflake.
- [ ] Update user information in `roles.yml`.
- [ ] Remove from team and project calendars.
- [ ] Remove from Geekbot.
- [ ] Remove access from Airflow.
- [ ] Remove Periscope permissions and revoke Admin license if applicable.
- [ ] Remove from any relevant distribution lists or communication groups:
  - [ ] `[your_tool@domain]`
  - [ ] `[analyticsapi@domain]`
- [ ] Remove from your cloud platform (e.g., AWS, Azure):
  - [ ] Remove service account.
  - [ ] Remove user account.
- [ ] Unassign the user from all issues in GitLab.

#### Security and Credential Management

- [ ] **If the user had access to any shared password managers (e.g., 1Password)**:
  - [ ] Create a [credential cycling issue](https://gitlab.com/gitlab-data/analytics/-/issues/new?issuable_template=Credential%20Cycling) to ensure all shared credentials are updated.

#### Issue Labels for Tracking

Apply the following labels to the issue for better tracking and categorization:
- /label ~Provisioning
- /label ~Housekeeping
- /label ~"Data Team"
- /label ~"engineering::Security"
- /label ~"Priority::1-Ops"