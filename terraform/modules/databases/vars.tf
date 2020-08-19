variable "env_name" {
    description = "The name of the environment, e.g. prod, stage, develop"
    type = string
}

variable "instance_class" {
    description = "The instance class of RDS, e.g. db.t3.small"
    type = string
}

variable "allocated_storage" {
    description = "The size of storage allocated to RDS instance in GiB"
    type = number
}

variable "publicly_accessible" {
    description = "If RDS instance is publicly accessible"
    type = bool
}

variable "db_username" {
    description = "Username of RDS instance"
    type = string
}

variable "db_password" {
    description = "Password of RDS instance"
    type = string
}