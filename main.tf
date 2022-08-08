provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "web-server" {
    ami=var.ami_id
    instance_type = "t2.micro"
    key_name = "jenkins_key"
    tags = {
      "name" = "jenkins server"
    }
    security_groups = ["allow_ssh","default"]
  
}

resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "jenkins_key" {
    key_name="jenkins_key"
    public_key =tls_private_key.rsa-4096-example.public_key_openssh
  
}

resource "local_file" "name" {
  content = tls_private_key.rsa-4096-example.private_key_pem
  filename = "jenkins_key"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
 
  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
   
  }

 
  tags = {
    Name = "allow_ssh"
  }
}