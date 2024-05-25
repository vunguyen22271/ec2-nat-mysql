variable "project_prefix" {
  description = "Prefix for the project"
  type        = string
  default     = "nat_mysql"
}

variable "env_prefix" {
  description = "Prefix for the environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "mysql_root_pass" {
  description = "Root password for MySQL"
  type        = string
  default     = "sis@12345"
  sensitive   = true
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "775060919599"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "my-key"
}