repo_name=$(aws ssm get-parameter --name "PROJ1_ECR_URL" --with-decryption --output text --query Parameter.Value)
repo_pass=$(aws ecr get-login-password --region ap-southeast-2)

docker login --username AWS --password $repo_pass $repo_name
docker build -t wordpress:latest -f ./docker/wordpress/Dockerfile .
docker tag wordpress:latest $repo_name:latest
docker push $repo_name:latest