#!/bin/bash     
       
       
        cd serverless_modules && \
        # Find all directories in the current directory
        folders=$(find . -maxdepth 1 -type d)

        # Loop through the results and run terraform plan inside each directory
        for folder in $folders
        do
            # Skip the current directory (".") and parent directory ("..")
            if [ $folder != "." ] && [ $folder != ".." ]; then
                # Check if the folder name contains "lambda"
                # if [[ $folder == *"lambda"* ]]; then
                    echo "Successfully got lambda folder: $(basename "$folder" | sed 's/^\.\///')"
                    cd $(basename "$folder" | sed 's/^\.\///')
                    echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
                    echo "Sliced as per requirement $(basename "$folder" | sed 's/^\.\///' | awk -F '-' '{print $1}')"
                    lambda_function="$(basename "$folder" | sed 's/^\.\///')"
                    echo $lambda_function
                    new_lambda_function="$(basename "$folder" | sed 's/^\.\///' | awk -F '-' '{print $1}')"
                    echo "$new_lambda_function-cost-reports-lambda"

            fi
        done                    
