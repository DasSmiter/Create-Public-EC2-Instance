#The VPC is defined with a cidr block
resource "aws_vpc" "web-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "temp-${random_pet.name.id}"
  }
}

#Our Security Group is defined with 2 ingresses (HTTP and SSH) and 1 egress (all traffic)
resource "aws_security_group" "web-sg" {
  name        = "${random_pet.name.id}-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = "${aws_vpc.web-vpc.id}"

#2 Ingresses here, one for HTTP and one for SSH
  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      #Empty definitions are required by AWS provider due to ongoing issue
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }, 

    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      #Empty definitions are required by AWS provider due to ongoing issue
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
#1 egress definition, all egress is allowed
  egress = [
    {
      description      = "All Traffic Out"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      #Empty definitions are required by AWS provider due to ongoing issue
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  tags = {
    Name = "allow_tls"
  }
}

#The subnet is defined here, existing on a cidr block inside the VPC's block
resource "aws_subnet" "web-subnet" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${random_pet.name.id}-subnet"
  }
}

#The internet gateway is created and attached to the vpc
resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web-vpc.id

  tags = {
    Name = "web-gw"
  }
}


#A reference Elastic IP request
resource "aws_eip" "web-eip" {
  depends_on = [aws_internet_gateway.web-gw]
  vpc      = true
}

#A refernce NAT gateway
resource "aws_nat_gateway" "web-nat" {
  allocation_id = aws_eip.web-eip.id
  subnet_id = aws_subnet.web-subnet.id

  tags = {
    Name = "web-nat"
  }

  depends_on = [aws_internet_gateway.web-gw]
}

#The Route Table for our subnet
resource "aws_route_table" "web-rt" {
  vpc_id = "${aws_vpc.web-vpc.id}"

    tags = {
    Name = "web-rt"
  }
}

#Lets route the gateway to the route table
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.web-rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.web-gw.id}"
}

#Lets associate our route table to the subnet here
resource "aws_route_table_association" "web-publicrt" {
  subnet_id      = aws_subnet.web-subnet.id
  route_table_id = aws_route_table.web-rt.id
}