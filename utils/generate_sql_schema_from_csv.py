import pandas as pd


def generate_table_definition_from_csv(csv_path):
    """Generate table column definitions from a CSV file for SQL CREATE TABLE statements."""
    # Load a few rows from the CSV to infer column types
    df = pd.read_csv(csv_path, nrows=3)

    # Mapping of Pandas dtypes to Snowflake SQL data types
    dtype_mapping = {
        "int64": "INT",
        "float64": "FLOAT",
        "object": "VARCHAR",
        "bool": "BOOLEAN",
        "datetime64[ns]": "TIMESTAMP",
    }

    # Start creating the column definitions for SQL schema
    column_definitions = ""

    # Loop over DataFrame columns and dynamically map types
    for column in df.columns:
        dtype = str(df[column].dtype)
        sql_type = dtype_mapping.get(dtype, "VARCHAR")  # Default to VARCHAR if type not found
        column_name = column.replace(" ", "_")  # Replace spaces with underscores for SQL compatibility
        column_definitions += f"{column_name} {sql_type}, "

    # Remove last comma and space
    column_definitions = column_definitions.rstrip(", ")

    return column_definitions
