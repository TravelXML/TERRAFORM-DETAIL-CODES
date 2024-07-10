#create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "key-sapan"
  public_key = file("${path.module}/id_rsa.pub")
}

output "keyname" {
  value = aws_key_pair.deployer.key_name
}