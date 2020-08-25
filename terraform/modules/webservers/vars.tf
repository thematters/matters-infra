variable "env_name" {
    description = "The name of the environment, e.g. prod, stage, develop"
    type = string
}

variable "region" {
    description = "The name of the region"
    type = string
}

variable "key_name" {
    description = "The SSH key name"
    type = string
}

variable "db_instance_address" {
    description = "The address of database"
    type = string
}

variable "ami_ubuntu" {
    description = "The EC2 ami for ubuntu"
    type = string
}

variable "es_instance_type" {
    description = "EC2 instance type for elasticsearch"
    type = string
} 

variable "es_instance_count" {
    description = "EC2 instance count for elasticsearch"
    type = number
}

variable "ipfs_instance_type" {
    description = "EC2 instance type for IPFS"
    type = string
} 

variable "ipfs_instance_count" {
    description = "EC2 instance count for IPFS"
    type = number 
}

variable "redis_instance_type" {
    description = "Redis instance type"
    type = string
}

variable "redis_number_cache_clusters" {
    description = "Redis instance count for Redis"
    type = number
}

variable "redis_automatic_failover_enabled" {
    description = "Redis automatic failover"
    type =bool
}

variable "server_instance_type" {
    description = "Elastic beanstalk EC2 instance type for API server"
    type = string
}
variable "server_environment_type" {
    description = "Elastic beanstalk EC2 environment type for API server, e.g. LoadBalanced or SingleInstance"
    type = string
}
variable "server_autoscale_min" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 
variable "server_autoscale_max" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 

variable "web_instance_type" {
    description = "Elastic beanstalk EC2 instance type for frontend web"
    type = string
}
variable "web_environment_type" {
    description = "Elastic beanstalk EC2 environment type for frontend_web, e.g. LoadBalanced or SingleInstance"
    type = string
}
variable "web_autoscale_min" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 
variable "web_autoscale_max" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 

variable "server_env_apollo_api_key" {
    description = "Apollo API Key"
    type = string
}

variable "server_env_aws_access_id" {
    description = "AWS access ID"
    type = string
}

variable "server_env_aws_access_key" {
    description = "AWS access secret key"
    type = string
}

variable "server_env_firebase_credentials" {
    description = "Google Firebase credentials"
    type = string
}

variable "server_env_gcp_project_id" {
    description = "GCP project ID"
    type = string
}

variable "server_env_jpush_api_key" {
    description = "JPush API key"
    type = string
}
variable "server_env_jpush_api_secret" {
    description = "JPush API secret"
    type = string
}
variable "server_env_jwt_secret" {
    description = "JWT secret"
    type = string
}
variable "server_env_likecoin_api_url" {
    description = "LikeCoin API URL"
    type = string
}
variable "server_env_likecoin_auth_url" {
    description = "LikeCoin auth URL"
    type = string
}
variable "server_env_likecoin_client_id" {
    description = "LikeCoin client ID"
    type = string
}
variable "server_env_likecoin_client_secret" {
    description = "LikeCoin client secret"
    type = string
}
variable "server_env_likecoin_migration_api_url" {
    description = "LikeCoin migration API URL"
    type = string
}
variable "server_env_likecoin_pay_liker_id" {
    description = "LikeCoin pay liker ID"
    type = string
}
variable "server_env_likecoin_pay_url" {
    description = "LikeCoin pay URL"
    type = string
}
variable "server_env_likecoin_token_url" {
    description = "LikeCoin token URL"
    type = string
}
variable "server_env_oauth_secret" {
    description = "OAuth secret"
    type = string
}
variable "server_env_oicd_private_key" {
    description = "OICD private key"
    type = string
}