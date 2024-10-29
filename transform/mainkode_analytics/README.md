Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


1. Query Data Using a Timestamp or Offset with AT
You can specify a timestamp or offset (in seconds, minutes, etc.) from the current time.

sql
Copy code
SELECT *
FROM your_table
AT (TIMESTAMP => 'YYYY-MM-DD HH:MI:SS');
or with an offset (in seconds, minutes, etc.):

sql
Copy code
SELECT *
FROM your_table
AT (OFFSET => -10 * 60); -- 10 minutes ago