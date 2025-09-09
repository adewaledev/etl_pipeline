#!/bin/bash

# Check if the required environment variables are set.
# The `source .env` command should be run by the user before executing this script.
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_USER" ] || [ -z "$PGPASSWORD" ] || [ -z "$DB_NAME" ] || [ -z "$CSV_DIR" ]; then
    echo "Error: One or more required environment variables are not set."
    echo "Please ensure you have a .env file and have run 'source .env'."
    exit 1
fi

# Export the password so that the psql command can use it.
export PGPASSWORD

# Function to run psql commands with the provided connection details.
run_psql() {
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 --quiet -c "$1"
}

# Check if the CSV directory exists
if [ ! -d "$CSV_DIR" ]; then
    echo "Error: The specified CSV directory '$CSV_DIR' does not exist. Exiting."
    exit 1
fi

# Iterate over each CSV file in the specified directory.
for FILE_PATH in "$CSV_DIR"/*.csv; do
    # Check if a file was found (in case there are no CSVs).
    if [ ! -f "$FILE_PATH" ]; then
        echo "No CSV files found in '$CSV_DIR'. Exiting."
        exit 1
    fi

    # Extract the table name from the filename (e.g., "orders.csv" -> "orders").
    TABLE_NAME=$(basename "$FILE_PATH" .csv)

    # --- Drop and create tables ---
    echo "---"
    echo "Processing file: $FILE_PATH"
    echo "Dropping table '$TABLE_NAME' if it exists..."
    run_psql "DROP TABLE IF EXISTS \"$TABLE_NAME\";"

    # Read the header row to get column names dynamically.
    HEADER_ROW=$(head -n 1 "$FILE_PATH" | tr -d '\r')

    # Construct the CREATE TABLE statement with all columns as TEXT.
    # Replace commas with ' TEXT, ' and add ' TEXT' to the end of the line.
    COLUMNS_WITH_TEXT_TYPE=$(echo "$HEADER_ROW" | sed 's/,/ TEXT, /g' | sed 's/$/ TEXT/')
    
    echo "Creating table '$TABLE_NAME' with all columns as TEXT."
    run_psql "CREATE TABLE \"$TABLE_NAME\" ($COLUMNS_WITH_TEXT_TYPE);"

    # --- Copy data from CSV file ---
    echo "Attempting to import data from: $FILE_PATH"
    run_psql "\COPY \"$TABLE_NAME\" FROM '$FILE_PATH' WITH (FORMAT csv, HEADER true);"

    # Check the exit status of the psql command.
    if [ $? -eq 0 ]; then
        echo "Successfully loaded data into table '$TABLE_NAME'."
    else
        echo "Error: Failed to load data into table '$TABLE_NAME'. Please check the file format."
        exit 1
    fi
done

echo "---"
echo "All import operations complete."
