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
variable "web_autoscale_min" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 
variable "web_autoscale_max" {
    description = "Elastic beanstalk autoscaling instance counts"
    type = number
} 