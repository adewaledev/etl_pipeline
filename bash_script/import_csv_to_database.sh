#!/bin/bash

# Directory containing the CSV files.
CSV_DIR="/home/adewale/cde_assignment/bash_script/posey"

# Check if the DB_NAME variable was successfully loaded from the environment
if [ -z "$DB_NAME" ]; then
    echo "Error: The DB_NAME variable is not set in the environment."
    echo "Please run 'source .env' before executing this script."
    exit 1
fi

# Let the user know the operation is starting
echo "Starting the data import into the '$DB_NAME' database."

# Check if the CSV directory exists
if [ ! -d "$CSV_DIR" ]; then
    echo "Error: The specified CSV directory '$CSV_DIR' does not exist."
    exit 1
fi

# Iterate over each CSV file in the specified directory
for FILE_PATH in "$CSV_DIR"/*.csv; do
    # Check if a file was found (in case there are no CSVs)
    if [ ! -f "$FILE_PATH" ]; then
        echo "No CSV files found in '$CSV_DIR'. Exiting."
        exit 1
    fi

    # Extract the table name from the filename (e.g., "orders.csv" -> "orders")
    TABLE_NAME=$(basename "$FILE_PATH" .csv)

    echo "---"
    echo "Processing file: $FILE_PATH"
    echo "Determining schema for table: $TABLE_NAME"

    # Read the header row of the CSV to get column names
    # sed removes any leading/trailing whitespace and non-alphanumeric characters
    HEADER_ROW=$(head -n 1 "$FILE_PATH" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' | tr -d '\r')

    # Construct the CREATE TABLE statement dynamically from the header row
    # Replace commas with ' TEXT, ' and add ' TEXT' to the end of the line
    COLUMNS_WITH_TYPES=$(echo "$HEADER_ROW" | sed 's/,/ TEXT, /g' | sed 's/$/ TEXT/')

    # Execute the CREATE TABLE statement, dropping the table first if it exists
    echo "Creating table '$TABLE_NAME' with columns: $COLUMNS_WITH_TYPES"
    psql -d "$DB_NAME" -c "DROP TABLE IF EXISTS \"$TABLE_NAME\"; CREATE TABLE \"$TABLE_NAME\" ($COLUMNS_WITH_TYPES);"

    # Use psql to execute a SQL COPY command to load the data.
    echo "Attempting to import data from: $FILE_PATH"
    psql -d "$DB_NAME" -c "\COPY \"$TABLE_NAME\" FROM '$FILE_PATH' WITH (FORMAT csv, HEADER true);"

    # Check the exit status of the psql command
    if [ $? -eq 0 ]; then
        echo "Successfully loaded data into table '$TABLE_NAME'."
    else
        echo "Error: Failed to load data into table '$TABLE_NAME'."
        echo "Please check the file format and table schema."
    fi
done

echo "---"
echo "All import operations complete."
