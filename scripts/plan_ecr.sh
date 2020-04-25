cd /code/terraform
terraform init
terraform plan -target module.aws-ecr -out ecr
