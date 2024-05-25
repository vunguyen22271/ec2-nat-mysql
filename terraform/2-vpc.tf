# VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_vpc"
  }
}


# public_subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"

  depends_on = [ aws_vpc.this ]

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_public_subnet"
  }
}

# private_subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"

  depends_on = [ aws_vpc.this ]

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_private_subnet"
  }
}

# Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"

  depends_on = [ aws_vpc.this ]

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [ aws_eip.eip,  aws_subnet.public_subnet ]

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_nat_gateway"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.this.id

  depends_on = [aws_vpc.this]
  
  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_igw"
  }
}

# public_sg
resource "aws_security_group" "public_sg" {
  name        = "${var.project_prefix}_${var.env_prefix}_public_sg"
  description = "${var.project_prefix}_${var.env_prefix}_public_sg"
  vpc_id      = aws_vpc.this.id

  depends_on = [aws_vpc.this]

  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "SSH from anywhere"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "8000 from anywhere"
  #   from_port   = 8000
  #   to_port     = 8000
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "3306 from anywhere"
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Allow inbound from vm_1 private IP"
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["${aws_instance.vm_1.private_ip}/32"]
  # }

  # ingress {
  #   description = "Ping from anywhere"
  #   from_port   = -1
  #   to_port     = -1
  #   protocol    = "icmp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   description = "HTTPS to ssm.us-east-1.amazonaws.com"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["ssm.us-east-1.amazonaws.com/32"]
  # }

  # egress {
  #   description = "HTTPS to ec2messages.us-east-1.amazonaws.com"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["ec2messages.us-east-1.amazonaws.com/32"]
  # }

  # egress {
  #   description = "HTTPS to ssmmessages.us-east-1.amazonaws.com"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["ssmmessages.us-east-1.amazonaws.com/32"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_public_sg"
  }
  # depends_on = [aws_vpc.dev_test_vpc]
}

# private_sg
resource "aws_security_group" "private_sg" {
  name        = "${var.project_prefix}_${var.env_prefix}_private_sg"
  description = "${var.project_prefix}_${var.env_prefix}_private_sg"
  vpc_id      = aws_vpc.this.id

  # depends_on = [aws_vpc.this]

  ingress {
    description = "Allow ingress from public_sg"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }
  ingress {
    description = "Allow all ingress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_private_sg"
  }
  # depends_on = [aws_vpc.dev_test_vpc]
}

# public_rt
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [ aws_vpc.this, aws_internet_gateway.igw ]

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_public_rt"
  }
}

# private_rt
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_private_rt"
  }
  depends_on = [ aws_vpc.this, aws_nat_gateway.nat_gateway ]
}

# public_rt_association
resource "aws_route_table_association" "tpublic_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [ aws_subnet.public_subnet, aws_route_table.public_rt ]
}

# private_rt_association
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
  depends_on = [ aws_subnet.private_subnet, aws_route_table.private_rt]
}