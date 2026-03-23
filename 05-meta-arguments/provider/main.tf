//Uses Default provider(us-east-1)
resource "aws_instance" "virginia_ec2" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.nano"
}
//Uses mumbai provider configuration
resource "aws_instance" "mumbai_ec2" {
  provider      = aws.mumbai
  ami           = "ami-019715e0d74f695be"
  instance_type = "t2.nano"
}