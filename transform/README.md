# Snowflake Time Travel: Querying Historical Data

Snowflake's **Time Travel** feature allows you to query and access data as it existed at a previous point in time. This can be useful for recovering accidentally deleted or updated data, tracking changes, and analyzing historical records.

---

## Methods to Query Historical Data

### 1. Query Data Using a Timestamp or Offset with `AT`

You can specify a specific timestamp or an offset to retrieve data as it existed at that time.  

- **Using a Specific Timestamp**

    ```sql
    SELECT *
    FROM your_table
    AT (TIMESTAMP => 'YYYY-MM-DD HH:MI:SS');
    ```

- **Using an Offset**

    ```sql
    SELECT *
    FROM your_table
    AT (OFFSET => -10 * 60); -- 10 minutes ago
    ```

    The offset value is in seconds; for example, `-10 * 60` represents 10 minutes in the past.

### 2. Query Data Using `BEFORE` a Specific Operation

You can retrieve data as it was before a specific DML (Data Manipulation Language) operation, like an update or delete, by using the `BEFORE` clause.

```sql
SELECT *
FROM your_table
BEFORE (TIMESTAMP => 'YYYY-MM-DD HH:MI:SS');
