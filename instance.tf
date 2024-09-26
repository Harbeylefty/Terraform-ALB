// create Keypair for instance 
provider "tls" {}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "TF_key.pem"
}


// create Instances 
resource "aws_instance" "web" {
  count = length(var.public_subnets_cidr)
  ami = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnets[count.index].id
  key_name = "TF_key"
  vpc_security_group_ids =  [aws_security_group.my_sg.id]
  associate_public_ip_address = true 
  user_data = file("instance${count.index + 1}.sh")

  tags = {
    Name = var.instance_names[count.index]
  }
}



