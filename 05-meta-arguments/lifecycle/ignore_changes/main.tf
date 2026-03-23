

#ec2-instance
resource "aws_instance" "terraform-instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  availability_zone           = "us-east-1b"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name       = "server-1"
    Env        = "Prod"
    Owner      = "sujan"
    CostCenter = "ABCD"
  }
  user_data = <<-EOF
              #!/bin/bash
              echo "hello, terraform" > /tmp/hello.txt
              echo "hii" > /tmp/sujan.txt
              EOF
  lifecycle {
    ignore_changes = [ user_data ]
  }
}



