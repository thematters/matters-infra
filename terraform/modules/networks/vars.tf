variable "env_name" {
    description = "The name of the environment, e.g. prod, stage, develop"
    type = string
}

variable "vpc_name" {
    description = "The name of the VPC"
    type = string
}

variable "availability_zones" {
    description = "The name of availability zones"
    type = list(string)
}