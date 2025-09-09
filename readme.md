# PROJECT OVERVIEW

This project contain scripts to extract a csv file from a URL, transform the file and load the file to a new directory.

## - Extraction Script

This script downloads the file from the URL source and saves the raw file in a folder named raw.
Firstly, it checks if the URL is set in the environment variable.
If the URL is set, it attempts to download the file.
A timeout of 120s has been set, so the program terminates in case of a network problem.
If the download is successful, it saves the file in the 'raw' folder
If the status code is 0, that is the file is moved without any error, it echoes 'File Extraction Complete', else if echoes 'File extraction Not Successful'

## - Transformation Script

This script uses csvsql from the csvkit library to transform the file.
Csvsql allows us to use sql query to perform sql-like operations on our csv file.
It selects the required columns and renames the required columns.
The script checks the status code of the query.
If the query runs without any error, it echoes 'File Transformation Complete'. Else, it echoes 'File Extraction Not Successful'.

## - Load Script

This script moves the transformed file into a new directory 'Gold'.
If the move operation completes without error, it echoes 'File Successfully Loaded Into "directory"'. Else, it echoes 'Unable to Load File into "directory"'.

## - RUN ETL Script

This script chains together the extraction script, transformation script and load script.
It chains them together and run them sequentially.
This script has also been scheduled with a cron job to run every midnight.
If any error occurs, the script will log the error and the date to a specified file.

## - Move JSON AND CSV Script

This script moves JSON and CSV files from a specified source path to a specified destination path.

## - CSV TO SQL Script

This script iterates over a bunch of csv files and load them into a postgres database.
The connection details of the database are saved in the environment variable.
The table names are extracted from the CSV file name i.e ('accounts.csv' becomes 'accounts' after extraction).
For simplicity, the data type is specified as text.
For every csv file, if the file is loaded into the database without error, the script echoes 'Successfully Loaded Data Into Table'. Else, it echoes 'Error: Failed to Load data Into Table'.

# PREREQUISITES

- Python
- CSVKIT
- POSTGRES

# USAGE

To use run the script;

- source .env: This loads the variables in our environment variables into the scripts
- bash "file.sh": file.sh here is a placeholder for our actual script. So if we want to run run_etl.sh, we simply run 'bash run_etl.sh' in our terminal.

# DATA FLOW

extraction.sh ----------> transformation.sh -----------> load.sh
