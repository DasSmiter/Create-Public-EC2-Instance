provider "aws" {
  region = "us-east-1"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_vpc" "web-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "temp-${random_pet.name.id}"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "${random_pet.name.id}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.web-vpc.id}"

  ingress = [
    {
      description      = "TLS in VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }, 

    {
      description      = "TLS in VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description      = "TLS out VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
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

resource "aws_subnet" "web-subnet" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${random_pet.name.id}-subnet"
  }
}

resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web-vpc.id

  tags = {
    Name = "web-gw"
  }
}

resource "aws_key_pair" "web-kp" {
  key_name   = "web-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBZITSKEqSCz4AkaxwA+vaCLJMpvW3OPw9PhRImzvyt1sLVdAlQMbFoKI8//J4GeseuoPAZNYlIgc1YEx1d4pghatSIVEdfEp/1ZSHkcq5I9ir3UPeTZ46tznKeuAYfijh5BiSYVsST8WNz1d8tkpY1W0qcsM8ox6IoQObakOh/o9RXeuKumbd9EJOHgrTyQ1VVuZ0wYwW3dbfNFd3RcfYtl1RKNmb/L/U9AXsyWDZWdgLXkA9y8xw+MtOQbSNpKur24s9JPnsIq8qE5+C0JxDR8cZ9wYO2V6ZNSdKhxm6lT6s8N3yHtvlanmFowHhO1UbMPsSr+XNqrn0CVH5GRlr"
}

resource "aws_instance" "web" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  subnet_id     = aws_subnet.web-subnet.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.web-kp.id

  depends_on = [aws_internet_gateway.web-gw, aws_nat_gateway.web-nat]

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_eip" "web-eip" {
  depends_on = [aws_internet_gateway.web-gw]
  vpc      = true
}

resource "aws_nat_gateway" "web-nat" {
  allocation_id = aws_eip.web-eip.id
  subnet_id = aws_subnet.web-subnet.id

  tags = {
    Name = "web-nat"
  }

  depends_on = [aws_internet_gateway.web-gw]
}

resource "aws_route_table" "web-rt" {
  vpc_id = "${aws_vpc.web-vpc.id}"

    tags = {
    Name = "web-rt"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.web-rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.web-gw.id}"
}

resource "aws_route_table_association" "web-publicrt" {
  subnet_id      = aws_subnet.web-subnet.id
  route_table_id = aws_route_table.web-rt.id
}