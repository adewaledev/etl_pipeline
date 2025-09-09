#!/bin/bash

#Let the user know the script is starting

echo "Operation Started"

# Specify the source file path
source_directory=raw_json_csv

# Create the destination path if it doesnt exist
mkdir -p json_and_csv

# Specify the destination Path
destination_directory=json_and_csv

# Move all json and csv files from the source path to the destination path
mv $source_directory/*.csv $source_directory/*.json $destination_directory/

# Check if the status code of the move command is 0 (which indicates success)
if [ $? -eq 0 ]; then
  echo "File Successfully Moved"
else 
  echo "File Move Unsuccessful"
fi

# Let the user know the operation is complete
echo "Operation Complete"
