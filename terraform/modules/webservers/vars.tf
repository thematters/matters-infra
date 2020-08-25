variable "env_name" {
    description = "The name of the environment, e.g. prod, stage, develop"
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