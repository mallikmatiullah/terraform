cidr_block = "10.0.0.0/16"
name       = "dev"

#Ec2 vars
ami                   = "ami-064519b8c76274859"
instance_type_jump_host = "t2.micro"
# instance_type         = "t2.micro"
public_instance_count = 2
private_instance_count = 2
key_name              = "my-key-pair"
security_group        = "sg-0abcd12345"
# name                  = "dev-instance"
