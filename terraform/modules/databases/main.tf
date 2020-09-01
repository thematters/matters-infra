##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "db" {
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.db.id

  filter {
    name = "tag:Name"
    values = ["${var.env_name}-vpc-public-*"]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.db.id
  name   = "default"
}

#####
# DB
#####
module "db" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v2.17.0"

  identifier = "matters-${var.env_name}"

  engine            = "postgres"
  engine_version    = "11.8"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "matters_${var.env_name}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.db_username

  password = var.db_password
  port     = "5432"

  vpc_security_group_ids = [data.aws_security_group.default.id]
  publicly_accessible = var.publicly_accessible

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Environment = "${var.env_name}"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.public.ids

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "matters-${var.env_name}"

  # Database Deletion Protection
  deletion_protection = false
}