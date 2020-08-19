# Live modules shall pin exact terraform and provider versions

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.44.0"
  
  name = var.vpc_name
  azs = var.availability_zones #["eu-west-1a", "eu-west-1b"]

  cidr = "10.10.0.0/16"
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.0.0/24", "10.10.3.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.env_name
  }
}