# New Data Source Request

Please review the [new data source request handbook page](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/new-data-source/) before submitting this request. For questions, reach out in the **#data** Slack channel.

## Business Use Case
- **Who Benefits**: Team/Department/Division/Multiple Divisions/Enterprise
- **Time Criticality**: ASAP, Urgent, Next Quarter, Next 6 Months, Next Year, Nice to Have
- **Revenue/Efficiency Impact**: <$5K, <$50K, <$500K, <$5M, >$5M
- **Legal Requirements**: None, Nice to Have, Must Have, Brand Damage (up to > $10M)
- **Additional Details**: 

## Request Checklist
- [ ] Prefix issue name with ‘New Data Source:’, e.g., ‘New Data Source: NetSuite AP data’
- [ ] Confirm if this is:
  - [ ] A new pipeline
  - [ ] A change/extension to an existing pipeline
- [ ] Does this source need snapshots? Open separate issues if yes.
- [ ] Does it contain [MNPI](https://handbook.gitlab.com/handbook/legal/safe-framework/#sensitive) or [Personal Data](https://handbook.gitlab.com/handbook/security/data-classification-standard/#data-classification-definitions)?
- [ ] Impact severity:
  - [ ] Critical (S1)
  - [ ] High (S2)
  - [ ] Medium (S3)
  - [ ] Low (S4)
- [ ] Who will use the data, and where (e.g., dashboards, Snowflake)?
- [ ] Data volume needed for the initial load (e.g., All time, 12 months, etc.)?
- [ ] List any confidential data (classified as Red or Orange).

## People Matrix
| Role                                    | Name            | GitLab Handle     |
|-----------------------------------------|-----------------|-------------------|
| System Owner                            |                 |                   |
| Data-Related Technical Contact          |                 |                   |
| Infrastructure-Related Technical Contact|                 |                   |
| Data Access Approval                    |                 |                   |
| Business Users (for data outages)       |                 |                   |

## Integration Preparation
- **Access Required**:
  - [ ] Yes
  - [ ] No
  - [ ] Unsure  
*If yes, provide access to a service account and specify where access is needed.*

## Data Engineer Tasks

### Triage
- [ ] Choose extraction solution per [diagram](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/new-data-source/#extraction-solution)
- [ ] Estimate [issue points](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/#issue-pointing)
- [ ] Confirm source in [tech_stack.yml](https://gitlab.com/gitlab-com/www-gitlab-com/-/blob/master/data/tech_stack.yml). If data is classified Red, additional approvals are needed.
- [ ] For Personal Data, coordinate with Legal Privacy for approval.

### Admin
- [ ] Create issue for data extraction setup (not needed for Stitch/FiveTran)
- [ ] Create issue for dbt models
- [ ] Update relevant documentation and link MRs

**Data Access Contact**:
- [ ] Ensure [contact sheet](https://docs.google.com/spreadsheets/d/1VKvqyn7wy6HqpWS9T3MdPnE6qbfH2kGPQDFg2qPcp6U/edit#gid=0) is updated.

---

### Labels
Apply the following labels for tracking:
- **~new data source**
- **~workflow::1 - triage**
- **~Team::Data Platform**
- **~Priority::3-Other**