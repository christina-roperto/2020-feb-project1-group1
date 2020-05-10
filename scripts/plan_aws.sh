export TF_VAR_repository_version=$(cat repo_version.txt)

cd /code/terraform
terraform init
terraform plan -out aws
