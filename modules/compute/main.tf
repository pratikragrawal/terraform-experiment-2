data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  count = var.web_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.web_security_group_id]

  associate_public_ip_address = true

  key_name = var.key_name

  tags = {
    Name = "web-${count.index + 1}"
    Tier = "web"
  }
}

resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.db_security_group_id]

  key_name = var.key_name

  depends_on = [
    aws_instance.web
  ]

  tags = {
    Name = "database"
    Tier = "database"
  }
}