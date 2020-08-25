##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "web" {
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.web.id}"

  filter {
    name = "tag:Name"
    values = ["${var.env_name}-vpc-public-*"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.web.id}"

  filter {
    name = "tag:Name"
    values = ["${var.env_name}-vpc-private-*"]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.web.id
  name   = "default"
}


# =======================================================
# ES
# =======================================================
module "es" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v2.15.0"

  instance_count = "${var.es_instance_count}"

  name                        = "${var.env_name}-es"
  key_name                    = "${var.key_name}"
  ami                         = "${var.ami_ubuntu}"
  instance_type               = "${var.es_instance_type}"
  subnet_id                   = tolist(data.aws_subnet_ids.public.ids)[0]
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = false
}

# =======================================================
# IPFS 
# =======================================================
module "ipfs_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.env_name}-ipfs-sg"
  description = "Security group for IPFS usage with EC2 instance"
  vpc_id      = "${data.aws_vpc.web.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = [
      "http-80-tcp",
      "ssh-tcp"
  ]
  ingress_with_cidr_blocks = [
      {
          from_port = 9094,
          to_port = 9096,
          protocol = "tcp",
          description = "IPFS ports",
          cidr_blocks = "0.0.0.0/0"
      },
      {
          from_port = 4001,
          to_port = 5001,
          protocol = "tcp",
          description = "IPFS ports",
          cidr_blocks = "0.0.0.0/0"
      }
  ]
  egress_rules        = ["all-all"]
}
resource "aws_eip" "ipfs_this" {
  vpc      = true
  instance = module.ipfs.id[0]
}

module "ipfs" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v2.15.0"

  instance_count = "${var.ipfs_instance_count}"

  name                        = "${var.env_name}-ipfs"
  key_name                    = "${var.key_name}"
  ami                         = "${var.ami_ubuntu}"
  instance_type               = "${var.ipfs_instance_type}"
  subnet_id                   = tolist(data.aws_subnet_ids.public.ids)[0]
  vpc_security_group_ids      = [module.ipfs_security_group.this_security_group_id]
  associate_public_ip_address = true
}

# =======================================================
# ElastiCache Redis
# =======================================================
module "redis" {
  source = "umotif-public/elasticache-redis/aws"
  version = "~> 1.0.0"

  name_prefix = "server-${var.env_name}"
  node_type = "${var.redis_instance_type}"
  number_cache_clusters = var.redis_number_cache_clusters
  automatic_failover_enabled = var.redis_automatic_failover_enabled

  engine_version           = "5.0.6"
  port                     = 6379
  maintenance_window       = "mon:03:00-mon:04:00"
  snapshot_window          = "04:00-06:00"
  snapshot_retention_limit = 7

  apply_immediately = true
  family            = "redis5.0"
  description = "Queue and cache"

  vpc_id = data.aws_vpc.web.id
  subnet_ids = data.aws_subnet_ids.private.ids
}

# =======================================================
# S3 
# =======================================================
module "s3_web" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.9.0"

  bucket = "web-${var.env_name}.matters.news"

  // bucket policy public for get object
}

module "s3_server" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.9.0"

  bucket = "server-${var.env_name}.matters.news"

  // acl = "public"
  // acl public 
  // bucket policy public for get object
}

module "s3_oss" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.9.0"

  bucket = "oss-${var.env_name}.matters.news"  

  // bucket policy public
  // static website hosting enabled
}


# =======================================================
# Beanstalk environments
# =======================================================
module "eb_app" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=tags/0.3.0"
  name        = "matters-${var.env_name}"
  description = "Matters beanstalk application for ${var.env_name} environment"
}

module "eb_env_web" {
  source = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  name = "matters-web-${var.env_name}" 
  description = "Matters beanstalk environment for front web"

  region = var.region
  instance_type = var.web_instance_type
  autoscale_min = var.web_autoscale_min
  autoscale_max = var.web_autoscale_max
  keypair = "${var.key_name}"
  elastic_beanstalk_application_name = module.eb_app.elastic_beanstalk_application_name

  loadbalancer_type = "application"
  vpc_id = data.aws_vpc.web.id
  loadbalancer_subnets = data.aws_subnet_ids.public.ids
  application_subnets = data.aws_subnet_ids.private.ids

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  solution_stack_name = "64bit Amazon Linux 2018.03 v4.15.1 running Node.js"

  additional_settings = [
    {
      namespace = "aws:elasticbeanstalk:container:nodejs"
      name = "NodeVersion"
      value = "12.16.1"
    }
  ]
}

module "eb_env_server" {
  source = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  name = "matters-server-${var.env_name}"
  description = "Matters beanstalk environment for API server"

  region = var.region
  instance_type = var.server_instance_type
  autoscale_min = var.server_autoscale_min
  autoscale_max = var.server_autoscale_max
  keypair = "${var.key_name}"
  elastic_beanstalk_application_name = module.eb_app.elastic_beanstalk_application_name

  loadbalancer_type = "application"
  vpc_id = data.aws_vpc.web.id
  loadbalancer_subnets = data.aws_subnet_ids.public.ids
  application_subnets = data.aws_subnet_ids.private.ids

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.15.3 running Docker 19.03.6-ce"
}
