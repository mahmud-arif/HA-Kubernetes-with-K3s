resource "aws_security_group" "master_sg" {
  name        = "master"
  description = "Security group for master instance"
  vpc_id = module.myapp-vpc.vpc_id
  
  # Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Be cautious with this setting; it allows SSH access from any IP
  }
  # Ingress rule for port 6443
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  }

  # Ingress rule for ports 2379-2380
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  }

  # Ingress rule for ports 10250-10260
  ingress {
    from_port   = 10250
    to_port     = 10260
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  }
  
  #  ingress {
  #   from_port   = 6784
  #   to_port     = 6784
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  # }

  #   ingress {
  #   from_port   = 6783
  #   to_port     = 6783
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  # }

    ingress {
    from_port   = 6782
    to_port     = 6782
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  }
  
  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "master-sg"
  }
}
#
resource "aws_security_group" "worker_sg" {
  name        = "worker"
  description = "Security group for worker instances"
  vpc_id = module.myapp-vpc.vpc_id
  # Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Be cautious with this setting; it allows SSH access from any IP
  }

  # Ingress rule for port 10250
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  }

  # Ingress rule for ports 30000-32767
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # You can restrict this to specific IPs if needed
  }

  # # Ingress rule for port 6784
  # ingress {
  #   from_port   = 6784
  #   to_port     = 6784
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  # }

  #   ingress {
  #   from_port   = 6782
  #   to_port     = 6782
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  # }
  
  #   ingress {
  #   from_port   = 6783
  #   to_port     = 6783
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # You can restrict this to specific IPs if needed
  # }

  #   ingress {
  #   from_port   = 8080
  #   to_port     = 8080
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # You can restrict this to specific IPs if needed
  # }
  
  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "worker-sg"
  }
}
# Launch EC2 instances
resource "aws_instance" "master" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 20.04 LTS AMI ID (Update with the latest AMI ID)
  instance_type = "t2.medium"
   subnet_id     = module.myapp-vpc.private_subnets[0]
  key_name      = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids  = [aws_security_group.master_sg.id]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker1" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 20.04 LTS AMI ID (Update with the latest AMI ID)
  instance_type = "t2.medium"
  subnet_id     = module.myapp-vpc.private_subnets[1]
  key_name      = aws_key_pair.ssh-key.key_name
  security_groups = [aws_security_group.worker_sg.id]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "worker1"
  }
}

resource "aws_instance" "worker2" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 20.04 LTS AMI ID (Update with the latest AMI ID)
  instance_type = "t2.medium"
  subnet_id     = module.myapp-vpc.private_subnets[1]
  key_name      = aws_key_pair.ssh-key.key_name
  security_groups = [aws_security_group.worker_sg.id]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "worker2"
  }
}


output "instance_private_ips" {
  value = [
    aws_instance.master.private_ip,
    aws_instance.worker1.private_ip,
    aws_instance.worker2.private_ip,
    # Add more instances as needed
  ]
}