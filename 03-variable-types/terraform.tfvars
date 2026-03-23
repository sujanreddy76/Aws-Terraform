vm_config = {
  name = "object-vm"
  instance_type = "t2.nano"
  zone = "us-east-1b"
  tags = {
    "Name" = "object-vm"
    "Owner" = "sujan"
  }
}
//----
vm_list = [ 
 {
  name = "vm-1"
  instance_type = "t2.nano"
  zone = "us-east-1a"
  tags = {
    "Name" = "vm-1"
  }
},
{
    name = "vm-2"
    instance_type = "t2.micro"
    zone = "us-east-1b"
    tags = {
      "Name" = "vm-2"
    }
} ]