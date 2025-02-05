module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name            = "default-vpc"
  cidr            = "192.168.0.0/16"
  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets  = ["192.168.1.0/24", "192.168.2.0/24"]
  private_subnets = ["192.168.3.0/24", "192.168.4.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Type = "public-subnet"
  }
  private_subnet_tags = {
    Type = "private-subnet"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.asia-southeast-1.ec2"
  vpc_endpoint_type = "Interface"
}
