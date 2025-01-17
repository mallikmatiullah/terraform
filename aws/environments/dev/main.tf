# Root level `main.tf` for the `dev` environment
# Calls modules and manages resources for the client's AWS requirements

module "vpc" {
  source = "../modules/vpc"

  cidr_block            = "10.0.0.0/16"
  name                  = "dev-vpc"
  public_subnet_count   = 1
  private_subnet_count  = 1
  public_subnet_cidr    = ["10.0.1.0/24"]
  private_subnet_cidr   = ["10.0.2.0/24"]
  azs                   = ["us-east-1a"]
}

module "ec2" {
  source = "../modules/ec2"

  ami                   = "ami-xxxxxxxx" # Debian stable AMI ID
  instance_type         = "t2.micro"
  key_name              = "my-key-pair"
  public_instance_count = 2
  private_instance_count = 2
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_subnet_id     = module.vpc.private_subnet_ids[0]
  security_group        = module.vpc.default_sg_id
}

module "load_balancer" {
  source = "../modules/load_balancer"

  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_instance_ids  = module.ec2.private_instance_ids
  load_balancer_name    = "dev-lb"
}

module "route53" {
  source = "../modules/route53"

  domain_name           = "example.com"
  public_hosted_zone_id = "Z123456ABCDEFG"
  records = [
    {
      name = "www.example.com",
      type = "A",
      ttl  = 300,
      value = module.load_balancer.lb_dns_name
    }
  ]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_ec2_ips" {
  value = module.ec2.public_instance_ips
}

output "private_ec2_ips" {
  value = module.ec2.private_instance_ips
}

output "load_balancer_dns" {
  value = module.load_balancer.lb_dns_name
}
