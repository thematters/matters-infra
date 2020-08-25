locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../modules/databases"

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
  instance_class = "db.t3.small"
  allocated_storage = 20
  publicly_accessible = true
}
