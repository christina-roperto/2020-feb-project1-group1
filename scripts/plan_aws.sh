repo=$(cat ./terraform/aws-ecr/repo.txt | sed -n -e 's/^.*repository_url = //p')

cd /code/terraform
terraform init
TF_VAR_repository_url="$repo" terraform plan -out aws
