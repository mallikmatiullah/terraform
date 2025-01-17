variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs for the instance"
}

variable "user_data" {
  type        = string
  description = "Path to the user data script (optional)"
  default     = null
}

variable "name" {
  type        = string
  description = "Name tag for the EC2 instance"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to add to the EC2 instance"
  default     = {}
}
