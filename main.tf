provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIARZP47FIYTTNX2OXQ"
  secret_key = "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"
}

resource "aws_instance" "inst" {
  connection {
    user        = "ec2-user"
    private_key = file("dp1terraform.pem")
    host        = self.public_ip
  }
  count         = 2
  ami           = "ami-076e3a557efe1aa9c"
  key_name      = "dp1terraform"
  instance_type = "t3.micro"
  subnet_id     = element(aws_subnet.sub.*.id, count.index)
  associate_public_ip_address = true
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }
  #provisioner "remote-exec" {
  #inline = [
  # "ping -c 10 8.8.8.8",]}
  tags = {
    Name = "inst-${count.index + 1}"
  }
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dhirenvpc"
  }
}
resource "aws_subnet" "sub" {
  count      = length(var.subnet_cidr)
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr[count.index]
map_public_ip_on_launch = true
  tags = {
    Name = "subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpcigw"
  }
}

resource "aws_route_table" "Rout" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rout"
  }
  }