variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 1
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 1
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "ami" {
  description = "The AMI ID for the EC2 instances (e.g., Debian stable AMI)"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances (e.g., t2.micro)"
  type        = string
  default     = "t2.micro" # Optional: Set a default value
}

variable "public_instance_count" {
  description = "Number of public EC2 instances"
  type        = number
  default     = 2 # Optional: Set a default value
}

variable "private_instance_count" {
  description = "Number of private EC2 instances"
  type        = number
  default     = 2 # Optional: Set a default value
}


variable "key_name" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
}

variable "security_group" {
  description = "The Security Group ID for the EC2 instances"
  type        = string
}

variable "instance_type_jump_host" {
  type        = string
  description = "Instance type for the jump host"
}
# variable "instance_name" {
#   description = "The name prefix for the EC2 instances"
#   type        = string
# }
