//vpc
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
//igw
resource "aws_internet_gateway" "igw_terraform" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "igw-terraform"
  }

}
//Public Subnet-1
resource "aws_subnet" "public_subnet1_terraform" {
  vpc_id                  = aws_vpc.tf_vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = var.subnet1_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet1-terraform"
  }
}
//Public Subnet-2
resource "aws_subnet" "public_subnet2_terraform" {
  vpc_id                  = aws_vpc.tf_vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = var.subnet2_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet2-terraform"
  }
}
//route_table
resource "aws_route_table" "rt_terraform" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_terraform.id
  }
  tags = {
    Name    = "public-rt-terraform"
    Service = "Terraform"
  }

}
//Subnet1-RouteTable-association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public_subnet1_terraform.id
  route_table_id = aws_route_table.rt_terraform.id
}
//Subnet2-RouteTable-association
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public_subnet2_terraform.id
  route_table_id = aws_route_table.rt_terraform.id
}
//Security Group
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id
  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    //In AWS Security Groups: protocol = "-1" means: Allow ALL protocols
    //When protocol = -1 Then from_port and to_port are ignored by AWS. Meaning: Allow all inbound traffic from anywhere on all ports and all protocols.
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }

}
#ec2-instance-1
resource "aws_instance" "webserver-1" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t2.micro"
  key_name                    = "sujanreddyNVKeypair"
  subnet_id                   = aws_subnet.public_subnet1_terraform.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name = "Webserver-1"
  }
  user_data = base64encode(file("./user-data1.sh"))
}
#ec2-instance-2
resource "aws_instance" "webserver-2" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t2.micro"
  key_name                    = "sujanreddyNVKeypair"
  subnet_id                   = aws_subnet.public_subnet2_terraform.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name = "Webserver-2"
  }
  user_data = base64encode(file("./user-data2.sh"))
}

#Application Load Balancer
resource "aws_lb" "alb_terraform" {
  name               = "alb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = [aws_subnet.public_subnet1_terraform.id, aws_subnet.public_subnet2_terraform.id]
  tags = {
    Name = "alb_terraform"
  }

}
#loadbalancer target group
resource "aws_lb_target_group" "tg_alb_terraform" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_vpc.id
  health_check {
    path = "/"
    port = "traffic-port"
  }

}
#target group attachment to instance1
resource "aws_lb_target_group_attachment" "tga1_instance1_alb_terraform" {
  target_group_arn = aws_lb_target_group.tg_alb_terraform.arn
  target_id        = aws_instance.webserver-1.id
  port             = 80
}
#target group attachment to instance2
resource "aws_lb_target_group_attachment" "tga2_instance2_alb_terraform" {
  target_group_arn = aws_lb_target_group.tg_alb_terraform.arn
  target_id        = aws_instance.webserver-2.id
  port             = 80
}
#attaching target group to alb listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_terraform.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg_alb_terraform.id
    type             = "forward"
  }

}
