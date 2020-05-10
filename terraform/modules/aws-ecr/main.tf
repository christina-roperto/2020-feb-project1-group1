resource "aws_ecr_repository" "ecr" {
  name = var.project_name

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Environment = var.project_name
  }
}

resource "aws_ssm_parameter" "ecr_url" {
  name  ="PROJ1_ECR_URL"
  type  = "SecureString"
  value =  aws_ecr_repository.ecr.repository_url
  overwrite = true
} 