data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_file
}

data "aws_availability_zones" "available" {
  state = "available"
}