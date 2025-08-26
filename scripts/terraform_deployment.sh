#!/bin/bash

#setting up environment variables
set -e
action=${1}
Branch=${2}
deploy_env=${3}
aws_region="eu-west-1"
cd=$(pwd)


echo "action: $1, branch: $2, deploy_env: $3"

#Installing Aws CLI
install_aws_cli () {
    echo -e "\nInstalling AWS CLI...\n\n" && \
    #apk update > /dev/null && apk add --no-cache curl gcompat zip > /dev/null && \
    curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip -o awscliv2.zip > /dev/null && \
    unzip awscliv2.zip > /dev/null && ./aws/install > /dev/null && \
    aws --version && \
    echo -e "\nInstallation of AWS CLI is completed.\n\n"


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

################################################################### PLAN ###############################################################################################


pipeline () {

     if [ "$action" = "Plan" ]; then
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

        echo -e "\nRunning terraform plan\n\n" && \
        cd terraform_modules && \
        folders=$(find . -maxdepth 1 -type d ! -name '*tfvars')
          for folder in $folders
          do
              if [ $folder != "." ] && [ $folder != ".." ]; then
                  echo "Folder without tfvars file found: $(basename "$folder" | sed 's/^\.\///')"
                  cd $(basename "$folder" | sed 's/^\.\///')
                  echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
                  tfvars="${cd}/terraform_modules/$(basename "$folder" | sed 's/^\.\///')-tfvars/${deploy_env}-$(basename "$folder" | sed 's/^\.\///').tfvars"
                  echo $tfvars && \
                  terraform init && \
                  terraform plan --var-file ${tfvars} -out output.tfplan && \
                  cd ..
                  echo "Changed back to the original directory"
              fi
          done

          echo -e "\nCompleted terraform plan.\n\n"
     fi


##################################################################### APPLY ########################################################################################

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

        echo -e "\nRunning terraform apply\n\n" && \
        cd terraform_modules && \
        folders=$(find . -maxdepth 1 -type d ! -name '*tfvars')
          for folder in $folders
          do
              if [ $folder != "." ] && [ $folder != ".." ]; then
                  echo "Folder without tfvars file found: $(basename "$folder" | sed 's/^\.\///')"
                  cd $(basename "$folder" | sed 's/^\.\///')
                  echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
                  tfvars="${cd}/terraform_modules/$(basename "$folder" | sed 's/^\.\///')-tfvars/${deploy_env}-$(basename "$folder" | sed 's/^\.\///').tfvars"
                  echo $tfvars && \
                  terraform init && \
                  terraform plan --var-file ${tfvars} -out output.tfplan && \
                  terraform apply -auto-approve "output.tfplan" && \
                  cd ..
                  echo "Changed back to the original directory"
              fi
          done

          echo -e "\nCompleted terraform apply.\n\n"
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

        echo -e "\nRunning terraform destroy\n\n" && \
        cd terraform_modules && \
        folders=$(find . -maxdepth 1 -type d ! -name '*tfvars')
          for folder in $folders
          do
              if [ $folder != "." ] && [ $folder != ".." ]; then
                  echo "Folder without tfvars file found: $(basename "$folder" | sed 's/^\.\///')"
                  cd $(basename "$folder" | sed 's/^\.\///')
                  echo "Changed directory to $(basename "$folder" | sed 's/^\.\///')"
                  tfvars="${cd}/terraform_modules/$(basename "$folder" | sed 's/^\.\///')-tfvars/${deploy_env}-$(basename "$folder" | sed 's/^\.\///').tfvars"
                  echo $tfvars && \
                  terraform init && \
                  terraform destroy --var-file ${tfvars} -auto-approve && \
                  cd ..
                  echo "Changed back to the original directory"
              fi
          done

          echo -e "\nCompleted terraform destroy.\n\n"
     fi
 
}

pipeline
