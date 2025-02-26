provider "aws" {
  region = "ap-south-1"
}

# Create Key Pair
resource "aws_key_pair" "helloworld_key" {
  key_name   = "helloworld"
  public_key = file("${path.module}/javaapp.pub") # Uses existing public key
}

# Security Group
resource "aws_security_group" "helloworld_sg" {
  name        = "helloworld_sg"
  description = "Allow SSH and application access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Jenkins
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Nexus
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SonarQube
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Kubernetes API
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # NodePort Range for K8s
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_instance" "helloworld_master" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.helloworld_key.key_name
  security_groups = [aws_security_group.helloworld_sg.name]

  tags = {
    Name = "helloworld_master"
  }
}

resource "aws_instance" "helloworld_worker" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.helloworld_key.key_name
  security_groups = [aws_security_group.helloworld_sg.name]

  tags = {
    Name = "helloworld_worker"
  }
}

resource "aws_instance" "helloworld_jenkins" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.helloworld_key.key_name
  security_groups = [aws_security_group.helloworld_sg.name]

  tags = {
    Name = "helloworld_jenkins"
  }
}

resource "aws_instance" "helloworld_sonarqube" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.helloworld_key.key_name
  security_groups = [aws_security_group.helloworld_sg.name]

  tags = {
    Name = "helloworld_sonarqube"
  }
}

resource "aws_instance" "helloworld_nexus" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.helloworld_key.key_name
  security_groups = [aws_security_group.helloworld_sg.name]

  tags = {
    Name = "helloworld_nexus"
  }
}
