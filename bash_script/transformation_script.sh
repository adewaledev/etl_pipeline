#!/bin/bash

# Let the user know the script has started
echo "Transformation Operation Started"

# Destination Path
mkdir -p bash_script/transformed

#Keep only desired columns
query="SELECT Year, Value, Units, Variable_code AS Variable FROM raw"

# Run the query and redirect the output to destination path
csvsql --query="$query" raw/raw.csv > bash_script/transformed/2023_year_finance.csv

# Check if the operation is successful
if [ $? -eq 0 ]; then
echo "Transformation Complete!!!"
else
echo "Transformation Unsuccessful!!!"
fi

# Let the user know the operation has ended
echo "Transformation Operation Complete!"
