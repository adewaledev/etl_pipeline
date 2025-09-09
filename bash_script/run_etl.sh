#!/bin/bash

# Define the directory where the scripts are located
SCRIPT_DIR="/home/adewale/cde_assignment/bash_script"

# Log the start of the job to a log file
echo "ETL job started at $(date)" >>~/cron.log

# Run the scripts sequentially
# The '&&' operator ensures the next command only runs if the previous one was successful
"$SCRIPT_DIR/extraction_script.sh" && \
"$SCRIPT_DIR/transformation_script.sh" && \
"$SCRIPT_DIR/load_script.sh"

# Log the completion or failure
if [ $? -eq 0 ]; then
    echo "ETL job completed successfully at $(date)" >> ~/cron.log
else
    echo "ETL job failed at $(date)" >> ~/cron.log
fi
