provider "tls" {}

resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "kpname" {
  key_name   = "${terraform.workspace}-keypair"
  public_key = tls_private_key.tlskey.public_key_openssh
}

provider "local" {}

resource "local_file" "key" {
  content  = tls_private_key.tlskey.private_key_openssh
  filename = "${terraform.workspace}-keypair.pem"
}