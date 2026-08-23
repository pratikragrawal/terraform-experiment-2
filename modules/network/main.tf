# =========================
# VPC
# =========================

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "experiment2-vpc"
  }
}


# =========================
# Public Subnet
# =========================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "experiment2-public-subnet"
    Tier = "public"
  }
}


# =========================
# Private Subnet
# =========================

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "experiment2-private-subnet"
    Tier = "private"
  }
}


# =========================
# Internet Gateway
# =========================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "experiment2-internet-gateway"
  }
}


# =========================
# Public Route Table
# =========================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "experiment2-public-route-table"
  }
}


# =========================
# Public Route Table Association
# =========================

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# =========================
# Web Security Group
# =========================

resource "aws_security_group" "web" {
  name        = "experiment2-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  # HTTP access only from administrator network
  ingress {
    description = "HTTP from administrator"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  # SSH only from administrator IP
  ingress {
    description = "SSH from administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS outbound traffic
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  tags = {
    Name = "experiment2-web-sg"
    Tier = "web"
  }
}


# =========================
# Database Security Group
# =========================

resource "aws_security_group" "db" {
  name        = "experiment2-db-sg"
  description = "Security group for database server"
  vpc_id      = aws_vpc.main.id

  # Allow traffic only from Web Security Group
  ingress {
    description     = "Traffic from web servers"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # Allow HTTPS outbound traffic only
  egress {
    description     = "HTTPS outbound"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = {
    Name = "experiment2-db-sg"
    Tier = "database"
  }
}