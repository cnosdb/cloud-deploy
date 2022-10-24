provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "tls_private_key" "cnosdb" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "cnosdb"
  public_key = tls_private_key.cnosdb.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.cnosdb.private_key_pem}' > ./cnosdb.pem"
  }
}

resource "aws_vpc" "cnosdb" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "cnosdb_example"
    usedby = var.usedby_tags
  }
}

resource "aws_subnet" "cnosdb_subnet" {
  vpc_id            = aws_vpc.cnosdb.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "cnosdb_example"
    usedby = var.usedby_tags
  }
}
resource "aws_internet_gateway" "cnosdb" {
  vpc_id = aws_vpc.cnosdb.id

  tags = {
    Name = "cnosdb_example"
    usedby = var.usedby_tags
  }
}

resource "aws_route_table" "public_rt_client" {
  vpc_id = aws_vpc.cnosdb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cnosdb.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.cnosdb.id
  }

  tags = {
    Name = "cnosdb_example"
    usedby = var.usedby_tags
  }
}

resource "aws_route_table_association" "public_rt_client" {
  subnet_id      = aws_subnet.cnosdb_subnet.id
  route_table_id = aws_route_table.public_rt_client.id
}

resource "aws_security_group" "cnosdb_sg" {
  name   = "cnosdb sg"
  vpc_id = aws_vpc.cnosdb.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("server.yml")
}

resource "aws_instance" "cnosdb_server" {
  ami           = var.amis
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  subnet_id                   = aws_subnet.cnosdb_subnet.id
  vpc_security_group_ids      = [aws_security_group.cnosdb_sg.id]

  user_data = data.template_file.user_data.rendered

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags = {
    Name = "cnosdb_server"
    usedby = var.usedby_tags
    component = "cnosdb_server"
  }
}

resource "aws_eip" "cnosdb_server_public_ip" {
  instance = aws_instance.cnosdb_server.id
  vpc      = true
}

output "cnosdb_server_public_ip" {
  description = "cnosdb server public ip"
  value       = aws_eip.cnosdb_server_public_ip.public_ip
}