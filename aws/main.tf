# Root level `main.tf` for the `dev` environment
# Calls modules and manages resources for the client's AWS requirements

module "vpc" {
  source = "./modules/vpc"

  cidr_block           = var.cidr_block
  name                 = var.name
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  azs                  = var.azs
}

## Proxy Server Security Group
resource "aws_security_group" "proxy_server_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from the internet
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from the internet
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.jump_host_sg.id] # SSH from jump host
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-proxy-server-sg"
  }
}

## Private Security Group
resource "aws_security_group" "private_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.proxy_server_sg.id] # Allow HTTP from proxy server
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.proxy_server_sg.id] # Allow HTTPS from proxy server
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.jump_host_sg.id] # SSH from jump host
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-private-sg"
  }
}

# Jump Host
module "jump_host" {
  source           = "./modules/ec2"
  ami              = var.ami
  instance_type    = var.instance_type_jump_host
  subnet_id        = aws_subnet.public_subnet.id
  key_name         = var.key_name
  security_groups  = [aws_security_group.jump_host_sg.id]
  # user_data        = "${path.module}/scripts/jump_host.sh"
  name             = "${var.name}-jump-host"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "jump_host_key" {
  key_name   = "jump-host-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}


# # Proxy Server
# module "proxy_server" {
#   source           = "./modules/ec2"
#   ami              = var.ami
#   instance_type    = var.instance_type_proxy_server
#   subnet_id        = aws_subnet.public_subnet.id
#   key_name         = var.key_name
#   security_groups  = [aws_security_group.proxy_server_sg.id]
#   user_data        = "${path.module}/scripts/proxy_server.sh"
#   name             = "${var.name}-proxy-server"
#   additional_tags  = { Role = "ProxyServer" }
# }

# # Private Instances
# module "private_instances" {
#   source           = "./modules/ec2"
#   count            = var.private_instance_count
#   ami              = var.ami
#   instance_type    = var.instance_type_private
#   subnet_id        = aws_subnet.private_subnet.id
#   key_name         = var.key_name
#   security_groups  = [aws_security_group.private_sg.id]
#   user_data        = "${path.module}/scripts/app_server.sh"
#   name             = "${var.name}-private-${count.index + 1}"
#   additional_tags  = { Role = "PrivateServer" }
# }


# module "ec2" {
#   source = "./modules/ec2"

#   ami                   = var.ami # Replace with the desired Debian stable AMI
#   instance_type         = var.instance_type
#   public_instance_count = var.public_instance_count
#   private_instance_count = var.private_instance_count
#   public_subnet_id      = module.vpc.public_subnet_ids[0]
#   private_subnet_id     = module.vpc.private_subnet_ids[1]
#   key_name              = var.key_name
#   # security_group        = module.vpc.default_sg_id
#   name                  = var.name
# }

# module "load_balancer" {
#   source = "./modules/load_balancer"

#   public_subnet_id      = module.vpc.public_subnet_ids[0]
#   private_instance_ids  = module.ec2.private_instance_ids
#   load_balancer_name    = "dev-lb"
# }

# module "route53" {
#   source = "./modules/route53"

#   domain_name           = "example.com"
#   public_hosted_zone_id = "Z123456ABCDEFG"
#   records = [
#     {
#       name = "www.example.com",
#       type = "A",
#       ttl  = 300,
#       value = module.load_balancer.lb_dns_name
#     }
#   ]
# }



