#!/bin/zsh
set -e

AWS_VARS=(AWS_SSO_URL AWS_SSO_REGION)

for AWS_VAR in "${AWS_VARS[@]}"; do
  echo "$AWS_VAR is ${!AWS_VAR}"
    if [[ -z "${!AWS_VAR}" ]]; then
        echo "Error: AWS variable \"$AWS_VAR\" is unset"
        AWS_VAR_UNSET=true
    fi
done

if ! [[ -z "$AWS_VAR_UNSET" ]]; then
    SCRIPT=$(realpath "$0")
    echo "AWS Variables are not set, skipping autoconfig of files."
    echo "Re-run ${SCRIPT} when AWS_ variables are set."
    echo "set you AWS_ variables in https://gitpod.io/variables ." 
    echo "For more help, you can refer these docs: https://www.gitpod.io/docs/environment-variables#using-the-account-settings ."
    exit 1
fi


# create the config for SSO login

# This assumes the below variables have been configured for this repo in gitpod
# https://www.gitpod.io/docs/environment-variables#using-the-account-settings
echo "Forcing AWS config to just use SSO credentials"
[[ -d /home/gitpod/.aws ]] || mkdir /home/gitpod/.aws
cat <<- AWSFILE > /home/gitpod/.aws/config
[profile uct-dev]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${DEV_AWS_ACCOUNT_ID}
sso_role_name = ${DEV_AWS_ROLE_NAME}
region = ${UCT_DEV_AWS_DEFAULT_REGION}

[profile uct-prod]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${PROD_AWS_ACCOUNT_ID}
sso_role_name = ${PROD_AWS_ROLE_NAME}
region = ${UCT_PROD_AWS_DEFAULT_REGION}

[profile uct-exp]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${EXP_AWS_ACCOUNT_ID}
sso_role_name = ${EXP_AWS_ROLE_NAME}
region = ${UCT_EXP_AWS_DEFAULT_REGION}
AWSFILE

echo "All Things which are required for AWS SSO Login are Installed & Configured Successfully."
echo "Now, You can Start an AWS SSO login session."