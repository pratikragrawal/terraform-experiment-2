aws_region        = "ap-south-1"
availability_zone = "ap-south-1a"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

web_count     = 2
instance_type = "t3.micro"

key_name   = "experiment2-access-key"
admin_cidr = "47.15.113.124/32"