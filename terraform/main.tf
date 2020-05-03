module "aws-ecs-cluster" {
  source       = "./modules/aws-ecs-cluster"
  project_name = var.project_name
  project_env  = var.project_env
}

module "aws-ecr" {
  source       = "./modules/aws-ecr"
  project_name = var.project_name
}

module "aws-ecs-task-def" {
  source               = "./modules/aws-ecs-task-def"
  repository_url       = module.aws-ecr.repository_url
  family               = var.project_name
  file_system_dns_name = module.aws-efs.dns_name
  file_system_id       = module.aws-efs.id
  project_name         = var.project_name
}

module "aws-alb" {
  source       = "./modules/aws-alb"
  alb_name     = "${var.project_name}-alb"
  alb_port     = 80
  alb_protocol = "HTTP"
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.subnet_public_ids
}

module "aws-ecs-service" {
  source = "./modules/aws-ecs-service"

  cluster_id              = module.aws-ecs-cluster.id
  ecs_task_definition_arn = module.aws-ecs-task-def.arn
  project_name            = var.project_name
  subnet_ids              = module.networking.subnet_public_ids
  vpc_id                  = module.networking.vpc_id
  alb_id                  = module.aws-alb.alb_main_id
  security_group_id       = module.aws-alb.alb_security_group_id
  container_name          = "project_1"
  container_port          = "80"
  target_group_arn        = module.aws-alb.alb_target_group_arn

  ecs_service_depends_on = [
    module.aws-alb
  ]
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
  sg_id = module.aws-alb.alb_security_group_id
  vpc_id = module.networking.vpc_id
}

module "aurora-db" {
  source = "./modules/aws-rds"

  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_private_ids
  availability_zones = module.networking.availability_zone_names
  engine_mode        = "serverless"
  env_prefix         = "dev"
  storage_encrypted  = true

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 1
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

module "cloudwatch" {
  source         = "./modules/aws-cloudwatch"
  project_name   = var.project_name
  alert_sms      = var.alert_sms
  rds_cluster_id = module.aurora-db.cluster_identifier
  alb_arn_suffix = module.aws-alb.alb_arn_suffix
}
