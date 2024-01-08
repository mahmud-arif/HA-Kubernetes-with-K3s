
resource "aws_security_group" "bastian" {
  name        = "bastian"
  description = "Security group for bastionHost instance"
  vpc_id = module.myapp-vpc.vpc_id
  
  # Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with this setting; it allows SSH access from any IP
  }
  
  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "bastian-sg"
  }
}

resource "aws_instance" "bastionHost" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 20.04 LTS AMI ID (Update with the latest AMI ID)
  instance_type = "t2.micro"
  subnet_id     = module.myapp-vpc.public_subnets[1]
  key_name      = aws_key_pair.ssh-key.key_name
  security_groups = [aws_security_group.bastian.id]
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "bastianHost"
  }
}


output "bastionHost_public_ip" {
  value = aws_instance.bastionHost.public_ip
}