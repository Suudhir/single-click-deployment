#!/bin/bash

#setting up environment variables
set -e
action=${1}
Branch=${2}
deploy_env=${3}
aws_region="eu-west-1"
cd=$(pwd)
version_enabled=${4}


echo "action: $1, branch: $2, deploy_env: $3, version_enabled: ${4}"

#Installing Aws CLI
# install_aws_cli () {
#     apt-get update > /dev/null && \
#     apt-get install -y curl > /dev/null && \
#     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#     unzip awscliv2.zip && \
#     ./aws/install && \

# }


#Installing Serverless
install_serverless () {
    echo "\nInstalling Serverless...\n" && \
    npm -g config set user root && \
    npm config set registry http://registry.npmjs.org > /dev/null && \
    npm install -g serverless > /dev/null && \
    serverless --version && \
    sls plugin install -n serverless-python-requirements && \
    sls plugin install -n serverless-pseudo-parameters && \
    sls plugin install -n serverless-vpc-discovery@3.0.0 && \
    sls plugin install -n serverless-plugin-log-retention && \
    sls plugin install -n serverless-dependson-plugin && \
    sls plugin install -n serverless-deployment-bucket && \
    sls plugin install -n serverless-plugin-aws-alerts && \
    echo "\nInstallation of serverless and required plugins are completed.\n\n"
}


#function to print which branch is allowed for which environment
branch_allowed () {
    echo -e "\n${Branch} is not allowed to perform action in ${deploy_env} Environment.\n\n"
    if [ "$deploy_env" = "dev" ]; then
        echo -e "Choose develop branch for DEV environment.\n\n"
    elif [ "$deploy_env" = "qa" ]; then
        echo -e "Choose qa branch for QA environment.\n\n"
    elif [ "$deploy_env" = "stage" ]; then
        echo -e "Choose stage branch for STAGE environment.\n\n"
    elif [ "$deploy_env" = "prod" ]; then
        echo -e "Choose master branch for PRODUCTION environment.\n\n"
    fi
}

pipeline () {

###################################################################### PLAN ##############################################################################


    # if [ "$action" = "Plan" ]; then
    #     case "$deploy_env" in
    #         "dev"|"stage"|"prod")
    #             ;;
    #         *)
    #             branch_allowed
    #             ;;
    #     esac

    #     case "$Branch" in
    #         "dev"|"stage"|"feature/feature/publish-task-state-cwrule-to-dynamodb-HYP-14628-update")
    #             ;;
    #         *)
    #             branch_allowed
    #             ;;
    #     esac

    #     echo -e "\nSkipping serverless Plan \n\n" && \
    #     cd serverless_modules && \
    # fi

##################################################################### APPLY ########################################################################################


    #  if [ "$action" = "Apply" ]; then
    #      case "$deploy_env" in
    #          "dev"|"stage"|"prod")
    #              ;;
    #          *)
    #              branch_allowed
    #         ;      ;
    #      esac

    #      case "$Branch" in
    #          "dev"|"stage"|"feature/feature/publish-task-state-cwrule-to-dynamodb-HYP-14628-update")
    #              ;;
    #          *)
    #              branch_allowed
    #              ;;
    #      esac

    #      echo -e "\nDeploying serverless \n\n" && \
    #      cd serverless_modules && \
    #      # Find all directories in the current directory
    #      folders=$(find . -maxdepth 1 -type d)

    #      # Loop through the results and run terraform plan inside each directory
    #      for folder in $folders
    #      do
    #          if [ $folder != "." ] && [ $folder != ".." ]; then
    #              # Check if the folder name contains "lambda"
    #              echo "Successfully got lambda folder: $(basename "$folder" | sed 's/^\.\///')"
    #              cd $(basename "$folder" | sed 's/^\.\///')
    #              echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
    #              lambda_function="$(basename "$folder" | sed 's/^\.\///')"
    #              echo $lambda_function
    #              ls && \
    #              install_serverless && \
    #              apt-get update && \
    #              apt-get -y install python3-pip > /dev/null && \
    #              pip3 --version && \

    #              if [ "$version_enabled" = "true" ]; then
    #                  current_version=$(aws lambda get-function --function-name $lambda_function --query 'Configuration.Version' --output text)
    #                  echo "current version is $current_version"
    #                  next_version=$((current_version + 1))
    #                  echo "next version is $next_version"
    #                  serverless deploy --stage $deploy_env --param="env $deploy_env" --param="lambda_function=$lambda_function" --region $aws_region --version $next_version
    #              else
    #                  serverless deploy --stage $deploy_env --param="env $deploy_env" --param="lambda_function=$lambda_function" --region $aws_region
    #              fi

    #              # Change back to the original directory
    #              cd ..
    #              echo "Changed back to the original directory"
    #          fi

    #      done
    #  fi


     if [ "$action" = "Apply" ]; then
         case "$deploy_env" in
             "dev"|"stage"|"prod")
                 ;;
             *)
                 branch_allowed
                 ;;
         esac

         case "$Branch" in
             "dev"|"stage"|"feature/feature/publish-task-state-cwrule-to-dynamodb-HYP-14628-update")
                 ;;
             *)
                 branch_allowed
                 ;;
         esac

         echo -e "\nDeploying serverless \n\n" && \
         cd serverless_modules && \
         # Find all directories in the current directory
         folders=$(find . -maxdepth 1 -type d)

         # Loop through the results and run terraform plan inside each directory
         for folder in $folders
         do
             if [ $folder != "." ] && [ $folder != ".." ]; then
                 # Check if the folder name contains "lambda"
                 echo "Successfully got lambda folder: $(basename "$folder" | sed 's/^\.\///')"
                 cd $(basename "$folder" | sed 's/^\.\///')
                 echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
                 lambda_function="$(basename "$folder" | sed 's/^\.\///')"
                 echo $lambda_function
                 ls && \
                 install_serverless && \
                 apt-get update && \
                 apt-get -y install python3-pip > /dev/null && \
                 pip3 --version && \

                 if [ "$version_enabled" = "true" ]; then
                     current_version=$(aws lambda get-function --function-name $lambda_function --query 'Configuration.Version' --output text)
                     echo "current version is $current_version"
                     next_version=$((current_version + 1))
                     echo "next version is $next_version"
                     serverless deploy --stage $deploy_env --param="env $deploy_env" --param="lambda_function=$lambda_function" --region $aws_region --version $next_version
                 else
                     serverless deploy --stage $deploy_env --param="env $deploy_env" --param="lambda_function=$lambda_function" --region $aws_region
                 fi

                # Change back to the original directory
                cd ..
                echo "Changed back to the original directory"
            fi

        done
    fi

############################################################################# DESTROY ################################################################################

      if [ "$action" = "Destroy" ]; then
        case "$deploy_env" in
            "dev"|"stage"|"prod")
                ;;
            *)
                branch_allowed
                ;;
        esac

        case "$Branch" in
            "dev"|"stage"|"feature/feature/publish-task-state-cwrule-to-dynamodb-HYP-14628-update")
                ;;
            *)
                branch_allowed
                ;;
        esac

        echo -e "\nUneploying serverless \n\n" && \
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
                    lambda_function="$(basename "$folder" | sed 's/^\.\///')"                    
                    ls && \
                    install_serverless && \
                    serverless remove  --stage ${deploy_env} --param="env ${deploy_env}" --param="lambda_function=${lambda_function}" --region ${AWS_REGION} --param="enable_event=${ENABLE_EVENT}"
                    # Change back to the original directory
                    cd ..
                    echo "Changed back to the original directory"
                # fi
            fi
        done
     fi   
 
}

pipeline
