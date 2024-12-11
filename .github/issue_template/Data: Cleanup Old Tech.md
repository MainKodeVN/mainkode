# Cleanup Scope
Refer to the [removal and deletion process](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/#removal-and-deletion-process) for guidance.  
*Describe in detail what will be deleted.*

# Risk Score

Check the [handbook](https://about.gitlab.com/handbook/business-technology/data-team/how-we-work/#calculate-a-risk-score) for calculating risk scores.

## Likelihood of Breaking Something

Questions:
- How complex is the code change?
- How sure are we that the component is no longer in use?

**Likelihood Score**: `1/2/3`  
*Explain why you chose this score.*

## Impact of Mistakes

Questions:
- What would break if the deletion goes wrong?
- Can it be easily reversed?
- How many users would be affected?

**Impact Score**: `1/2/3`  
*Explain why you chose this score.*

## Overall Risk Score

Fill in:  
`Probability` * `Impact` = **Risk Score**

## Next Steps
*List the next actions to take, as per the handbook.*

### Labels
Apply the following labels for tracking:
- **~Team::Data Platform**
- **~Priority::3-Other**
- **~workflow::1 - triage**