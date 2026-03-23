#1)Security Group for ALB(Internet -> ALB)
resource "aws_security_group" "alb_sg" {
  name        = "yt-alb-sg"
  description = "security group for application load balancer"
  vpc_id      = aws_vpc.custom_vpc.id
  ingress  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "yt-alb-sg"
  }
}
#2)Security Group for Ec2 Instances(ALB -> EC2)
resource "aws_security_group" "ec2_sg" {
  name        = "yt-ec2-sg"
  description = "security group for ec2-instances"
  vpc_id      = aws_vpc.custom_vpc.id
  ingress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.alb_sg.id]
   
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "yt-ec2-sg"
  }
}
#3)ALB
resource "aws_lb" "app_lb" {
  name               = "yt-app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id
  depends_on         = [aws_internet_gateway.igw_vpc]
}
#4)target group for ALB
resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = "yt-ec2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name = "yt-alb-ec2-tg"
  }

}
#5)alb listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn
  }
  tags = {
    Name = "yt-alb-listener"
  }

}
#6)Launch Template for ec2 instances
resource "aws_launch_template" "ec2_launch_template" {
  name          = "yt-LT"
  image_id      = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }
  user_data = filebase64("./user-data.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "yt-ec2-web-server"
    }
  }

}
#7)Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  name                = "yt-ec2-asg"
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  target_group_arns   = [aws_lb_target_group.alb_ec2_tg.arn]
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  health_check_type = "EC2"

}