repo_name=$(cut -d " " -f 3 ./terraform/aws-ecr/repo.txt)

aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $repo_name
docker build -t wordpress:latest -f ./docker/wordpress/Dockerfile .
docker tag wordpress:latest $repo_name:latest
docker push $repo_name:latest

rm -f ./terraform/aws-ecr/repo.tx