resource "aws_security_group" "load-balancer" {
  name        = "load-balancer"
  description = "Security group for loadblancer instance"
  vpc_id = module.myapp-vpc.vpc_id
  
  # Ingress rule for SSH (port 22)
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with this setting; it allows SSH access from any IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "load-balancer" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 20.04 LTS AMI ID (Update with the latest AMI ID)
  instance_type = "t2.small"
  subnet_id     = module.myapp-vpc.public_subnets[0]
  key_name      = aws_key_pair.ssh-key.key_name
  security_groups = [aws_security_group.load-balancer.id]
  root_block_device {
    volume_size = 15
  }
  tags = {
    Name = "load-balancer"
  }
}


output "lb_public_ip" {
  value = aws_instance.load-balancer.public_ip
}