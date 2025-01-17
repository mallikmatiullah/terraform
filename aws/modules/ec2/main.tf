resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  security_groups = var.security_groups

  user_data = var.user_data != null ? file(var.user_data) : null

  tags = merge(
    {
      Name = "${var.name}-instance"
    },
    var.additional_tags
  )
}
