module "aws-ecr" {
  source       = "./modules/aws-ecr"
  project_name = var.project_name
}

module "aws-alb" {
  source       = "./modules/aws-alb"
  alb_name     = "${var.project_name}-alb"
  alb_port     = 80
  alb_protocol = "HTTP"
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.subnet_public_ids
}

module "aws-ecs" {
  source = "./modules/aws-ecs"
  project_name            = var.project_name
  subnet_ids              = module.networking.subnet_public_ids
  vpc_id                  = module.networking.vpc_id
  alb_id                  = module.aws-alb.alb_main_id
  security_group_id       = module.aws-alb.alb_security_group_id
  container_name          = var.container_name
  container_port          = var.container_port
  target_group_arn        = module.aws-alb.alb_target_group_arn
  
  project_env  = var.project_env

  repository_url       = module.aws-ecr.repository_url
  repository_version   = var.repository_version
  family               = var.project_name
  file_system_dns_name = module.aws-efs.dns_name
  file_system_id       = module.aws-efs.id

  ecs_service_depends_on = [
    module.aws-alb,
    module.aws-efs
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
  sg_id        = module.aws-alb.alb_security_group_id
  vpc_id       = module.networking.vpc_id
  cidr_vpc     = var.cidr_vpc
}

module "aurora-db" {
  source = "./modules/aws-rds"

  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_private_ids
  availability_zones = module.networking.availability_zone_names
  engine_mode        = "serverless"
  env_prefix         = "dev"
  storage_encrypted  = true
  cidr_vpc           = var.cidr_vpc

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 1
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

module "cloudwatch" {
  source           = "./modules/aws-cloudwatch"
  project_name     = var.project_name
  alert_sms        = var.alert_sms
  rds_cluster_id   = module.aurora-db.cluster_identifier
  alb_arn_suffix   = module.aws-alb.alb_arn_suffix
  ecs_cluster_name = module.aws-ecs.ecs_cluster_name
  ecs_service_name = module.aws-ecs.ecs_service_name
  policy_cpu_low   = module.aws-ecs.policy_cpu_low
  policy_cpu_high  = module.aws-ecs.policy_cpu_high
}
