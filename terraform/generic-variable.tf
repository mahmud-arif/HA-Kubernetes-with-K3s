# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}

variable "project_name" {
  description = "k3s project name"
  type = string
  default = "demo-project"
}