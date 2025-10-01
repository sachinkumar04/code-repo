provider "aws" {
  region = var.region  # Ensure that the region is provided via variables.tf or set directly in terraform.tfvars
}

# Security Group allowing SSH and application traffic
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow SSH and app traffic"
  vpc_id      = "vpc-0154a5cb0c10c7dbe"  # Your specified VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generate a new SSH key pair using the TLS provider
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair resource to import the generated public key
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins_deploy_key"
  public_key = tls_private_key.jenkins_key.public_key_openssh  # Corrected to public_key_openssh
}

# EC2 Instance creation
resource "aws_instance" "example" {
  ami                    = var.ami_id  # Use the variables from terraform.tfvars
  instance_type           = var.instance_type  # Use the variables from terraform.tfvars
  key_name                = aws_key_pair.jenkins_key.key_name  # Use the created key pair
  subnet_id               = "subnet-0734a3ce24f6f70b8"  # Your specified Subnet ID
  vpc_security_group_ids  = [aws_security_group.allow_web.id]

  tags = {
    Name = "ExampleInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              EOF
}

# Output the public IP of the created EC2 instance
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}

# Output the private key (sensitive value)
output "private_key" {
  value     = tls_private_key.jenkins_key.private_key_pem  # Corrected to private_key_pem
  sensitive = true
}

