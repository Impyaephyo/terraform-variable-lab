resource "aws_instance" "public_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnets[0].id
  key_name                    = aws_key_pair.kpname.key_name
  vpc_security_group_ids      = [aws_security_group.sshallow.id]
  associate_public_ip_address = true
  tags = {
    Name       = "${terraform.workspace}-public-instance"
    Managed_by = local.managed_by_tag
  }
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnets[0].id
  key_name                    = aws_key_pair.kpname.key_name
  vpc_security_group_ids      = [aws_security_group.sshallow.id]
  associate_public_ip_address = false
  tags = {
    Name       = "${terraform.workspace}-private-instance"
    Managed_by = local.managed_by_tag
  }
}