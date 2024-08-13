locals {
  vpc_name       = "${terraform.workspace}-vpc"
  key_pair_name  = "${terraform.workspace}-public-key"
  instance_name  = "${terraform.workspace}-instance"
  managed_by_tag = "Terraform"
}