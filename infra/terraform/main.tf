provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "rayen-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "devops" {
  ami                    = "ami-0ec2a5ff1be0688fa"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "devops-instance"
  }
}

output "public_ip" {
  value = aws_instance.devops.public_ip
}