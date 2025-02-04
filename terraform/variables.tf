variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "12345"
}
