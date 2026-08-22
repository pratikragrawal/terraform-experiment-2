variable "web_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "web_security_group_id" {
  type = string
}

variable "db_security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}