resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "github_repository_deploy_key" "deploy_key" {
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = "false"
  repository = "k8s-releases-kdr"
  title      = "${var.environment}-flux"
}
