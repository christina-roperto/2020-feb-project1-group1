repo_name=$(aws ssm get-parameter --name "PROJ1_ECR_URL" --with-decryption --output text --query Parameter.Value)
repo_pass=$(aws ecr get-login-password --region ap-southeast-2)
sha=$(git rev-parse --short HEAD)
repo_tag="$repo_name:$sha"

docker login --username AWS --password $repo_pass $repo_name
docker build -t $repo_tag docker/wordpress
docker push $repo_tag