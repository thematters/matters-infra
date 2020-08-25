locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  region = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../modules/webservers"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    arguments = [
      "-var-file=${get_terragrunt_dir()}/../terraform.tfvars"
    ]
  }
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# databases module depends on networks module
dependencies {
    paths = ["../networks"]
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration
inputs = {
  env_name = "${local.env}"
  region = "${local.region}"
  ami_ubuntu = "ami-0bcc094591f354be2"

  es_instance_type = "t3a.medium"
  es_instance_count = 1

  ipfs_instance_type = "t3a.medium"
  ipfs_instance_count = 1

  redis_instance_type = "cache.t3.small"
  redis_number_cache_clusters = 1
  # need to be disabled when redis_number_cache_clusters=1
  redis_automatic_failover_enabled = false

  server_instance_type = "t3a.small"
  server_autoscale_min = 1
  server_autoscale_max = 2

  web_instance_type = "t3a.small"
  web_autoscale_min = 1
  web_autoscale_max = 2
}
