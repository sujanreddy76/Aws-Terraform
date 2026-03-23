resource "null_resource" "file_provisioner" {
  count = var.environment == "prod" ? 3 : 1
  provisioner "file" {
    source      = "${path.module}/user-data.sh"
    destination = "/tmp/user-data.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa.pem")
      host        = element(aws_instance.public_server[*].public_ip, count.index)
    }

  }
 provisioner "remote-exec" {
   inline = [
     "sudo chmod 777 /tmp/user-data.sh",
     "sudo /tmp/user-data.sh",
     "sudo apt update",
     "sudo apt install jq unzip -y",
   ]

   connection {
     type        = "ssh"
     user        = "ubuntu"
     private_key = file("id_rsa.pem")
     host        = element(aws_instance.public_server.*.public_ip, count.index)
   }
 }


  provisioner "local-exec" {
    command = "echo ${join(" ", aws_instance.public_server[*].private_ip)} > private_ips.txt"
  }



}