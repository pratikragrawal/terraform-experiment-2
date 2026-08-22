variable "aws_region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "admin_cidr" {
  type = string
}

variable "web_count" {
  type        = number
  description = "Number of web servers"
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}