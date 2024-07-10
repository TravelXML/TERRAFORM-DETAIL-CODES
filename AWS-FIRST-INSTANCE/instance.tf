# createing instance 
resource "aws_instance" "web" {
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "first-tf-instance"
  }
  user_data = file("${path.module}/script.sh")

connection{
        type = "ssh"
        user = "ubuntu"
        private_key = file("${path.module}/id_rsa")
        host = "${self.public_ip}"
    }

#file, local-exec, remote-exec
provisioner "file" {
    source ="readme.md" #terraform machine
    destination = "/tmp/readme.md" #remote machine
    
}

provisioner "local-exec" {
command = "echo ${self.public_ip} > /tmp/mypublicip.txt"    
}


}

  