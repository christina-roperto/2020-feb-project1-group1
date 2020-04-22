repo_name=$(cat ./terraform/aws-ecr/repo.txt | sed -n -e 's/^.*repository_url = //p')
repo_pass=$(cat ./terraform/aws-ecr/repo.txt | sed -n -e 's/^.*repo_pass = //p')

docker login --username AWS --password $repo_pass $repo_name
docker build -t wordpress:latest -f ./docker/wordpress/Dockerfile .
docker tag wordpress:latest $repo_name:latest
docker push $repo_name:latest

rm -f ./terraform/aws-ecr/repo.txt
