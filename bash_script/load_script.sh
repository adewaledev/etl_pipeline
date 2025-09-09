#!/bin/bash

# Specify the source file
source_file="/home/adewale/cde_assignment/bash_script/transformed/2023_year_finance.csv"

#Specify the destination path
destination="/home/adewale/cde_assignment/bash_script/Gold"

# Let the user know load operation has started
echo "Loading into $destination"

# Use mkdir -p to ensure the destination directory exists
mkdir -p "$destination"

# Copy the Transformed Data Into Gold Directory
cp "$source_file" "$destination"

# Check if the file status is 0 (Successful)
if [ $? -eq 0 ]; then
  echo "File Successfully Loaded into $destination"
else
  echo "Unable to Load File into $destination"
fi

# Let the user know the operation has ended
echo "Load Operation Complete!"