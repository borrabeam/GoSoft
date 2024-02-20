# AWS provider
provider "aws" {
    region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
}

# Create a Subnet within that VPC
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "eu-central-1"
}

# Create an EIP with a `private` address
resource "aws_eip" "my_eip" {
  domain = "vpc"
  instance = aws_instance.my_instance.id 
  associate_with_private_ip = "10.0.10.250"
}

#Create an EBS volume 
resource "aws_ebs_volume" "my_ebs" {
  availability_zone = "eu-central-1"
}

#Attach EBS to the instance
resource "aws_volume_attachment" "ebs_attach" {
    device_name = "/dev/sdc"
    volume_id = aws_ebs_volume.my_ebs_volume.id
    instance_id = aws_instance.my_instance.id
}



# Create an EC2 instance
resource "aws_instance" "my_instance" {
    ami = "ami-0be656e75e69af1a9"
    instance_type = "t2.micro"
    subnet_id = aws_instance.my_subnet.id

    tags = {
        Name = "EC2Instance"
    }
}
