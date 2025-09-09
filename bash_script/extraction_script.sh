#!/bin/bash

# --- File Paths ---
destination_file="/home/adewale/cde_assignment/bash_script/raw/raw.csv"

# --- Data Extraction ---
# The URL variable is expected to be provided by the shell's environment
echo "EXTRACTING CSV..."

# Check if the URL variable is set
if [ -z "$URL" ]; then
  echo "Error: The 'URL' variable is not set. Please source the .env file before running."
  exit 1
fi

# Use dirname to create the parent directory for the destination file
mkdir -p "$(dirname "$destination_file")"

# Use curl to download the file, using the URL from the environment
curl -o "$destination_file" -m 120 "$URL"

# --- Status Check ---
# Check the exit status of the 'curl' command to determine success
if [ $? -eq 0 ]; then
  echo "FILE EXTRACTION COMPLETE!!!"
else
  echo "File Extraction Unsuccessful!!!"
fi

# Let the user know the operation has ended
echo "Extraction Operation Complete"