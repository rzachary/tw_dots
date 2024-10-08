# Path to AWS Folder
export AWS_PATH="$HOME/.aws"

function aws_credentials {
    local credential_path="${AWS_PATH}/credentials/setup/$1"
}