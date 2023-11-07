resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = data.local_file.ssh_public_key.content
}