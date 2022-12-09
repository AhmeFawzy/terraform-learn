provider "aws" {
    region = "eu-west-3"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "flokiapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "flokiapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names  // we won't hardcode them because what if we want to deploy this in mutliple regions so we will set them dynamically 
  
  enable_nat_gateway = true 
  single_nat_gateway = true //all private subnets will route their internet traffic through this single NAT gateway
  enable_dns_hostnames = true

  tags = {
     "kubernetes.io/cluster/flokiapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/flokiapp-eks-cluster" = "shared"
    "kubernets.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/flokiapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1  // elb = elastic loadblanacer
  }
 // these tags to helps the cloud controller manager to identify which vpc and subnets to connect to
}