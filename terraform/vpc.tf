module "myapp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.14.3"

    name = "${var.project_name}-${var.vpc_name}"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks
    azs = var.vpc_availability_zones 
    
    enable_nat_gateway = var.vpc_enable_nat_gateway
    single_nat_gateway = var.vpc_single_nat_gateway
    enable_dns_hostnames = var.vpc_dns_hostname
    one_nat_gateway_per_az = false
    enable_dns_support   = true
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "k8-ssh"
  public_key = file("/Users/mahmud/.ssh/id_rsa.pub")
}

