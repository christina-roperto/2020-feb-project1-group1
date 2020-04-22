module "aws-ecs-cluster" {
  source       = "./modules/aws-ecs-cluster"
  project_name = var.project_name
  project_env  = var.project_env
}

module "aws-ecs-task-def" {
  source = "./modules/aws-ecs-task-def"

  family                    = "wordpress"
  container_definition_file = var.container_definition_file
  file_system_dns_name      = module.aws-efs.dns_name
}

module "aws-ecs-service" {
  source = "./modules/aws-ecs-service"

  cluster_id   = module.aws-ecs-cluster.id
  task_arn     = module.aws-ecs-task-def.arn
  project_name = var.project_name
  subnet_ids   = module.networking.subnet_public_ids
  vpc_id       = module.networking.vpc_id
}

module "networking" {
  source       = "./modules/aws-networking"
  project_name = var.project_name
  cidr_vpc     = var.cidr_vpc
}

module "aws-efs" {
  source       = "./modules/aws-efs"
  project_name = var.project_name
  subnet_ids   = module.networking.subnet_private_ids
}

module "aurora-db" {
  source = "./modules/aws-rds"

  db_username        = var.db_username
  db_password        = var.db_password
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_private_ids
  availability_zones = module.networking.availability_zone_names
  engine_mode        = "serverless"
  env_prefix         = "dev"
  storage_encrypted  = true

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 32
    min_capacity             = 8
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}
