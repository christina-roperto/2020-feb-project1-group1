# DevOps - Project 01 - Group 01 - Wordpress Solution 

Solution based on AWS to install wordpress site with Fargate and Aurora DB Cluster. 

## Solution Diagram 

![](docs/devops-image-diagram-project-01.png)

## Requirements 

- Make
- Docker-compose 
- Git
- Bash
- AWS CLI 2.0

## Usage

Clone or download the repository:

```
git clone https://github.com/devopsacademyau/2020-feb-project1-group1.git
```

Set up your AWS credentials:

```
aws configure
```

Set up a s3 bucket and update the file:

```
terraform/_backend.tf
```

Prepare (optional)

Run `make prepare` and edit your `.env` file to your preferences.

Plan:

Create an execution plan:
```
make plan
```

Build:

Create an ECR repository, build wordpress docker image and push to the repository created:
```
make build
```

Deploy:

Deploy the infrastructure on AWS using the docker image pushed to ECR
```
make deploy
```

Destroy:

**WARNING:** This will delete your configuration, database, EFS and all other resources.

Destory all the infrastructure created on AWS
```
make destroy
```

Clean:

Delete files and docker images created on plan, build and deploy targets.
```
make clean
```

## Predefined values

Wordpress Version:
```
wordpress:5.4.0-php7.2-apache
ECR versioning: git rev-parse --short HEAD
```

Terraform version:
```
terraform/0.12.24
```

Terraform backend:
```
AWS S3 - "wdpress/terraform.tfstate"
```

VPC:
```
aws region: ap-southeast-2
cidr: 10.10.0.0/16
```

Application Load Balancer:
```
port: 80
```

Cloudwatch:
```
ALB high response time: 3
ECS high cpu usage: 80%
ECS low cpu usage: 2%
RDS high cpu usage: 70%
```

SSM Parameters:
```
PROJ1_ECR_URL
PROJ1_DB_HOST
PROJ1_DB_USER: random string 
PROJ1_DB_PASSWORD: random string
PROJ1_DB_NAME
```

ECS:
```
Autoscaling task: Min 2, Max 4, Desired 2
Type: FARGATE
Platform_version: 1.4.0
Task CPU: 256
Task Memory: 512
```

EFS:
```
Encrypted: true
```

RDS:
```
Aurora MySQL Serveless
Version: 5.6.10a
Encrypted: true
```

CI/CD:
```
Github actions:
on push terraform/**: make plan && make deploy
on pull_request docker/wordpress/Dockerfile: make plan && make build
```
