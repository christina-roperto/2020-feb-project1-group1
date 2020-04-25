cd /code/terraform
terraform apply ecr
terraform output > repo.txt
echo repo_pass = $(aws ecr get-login-password --region ap-southeast-2) >> repo.txt