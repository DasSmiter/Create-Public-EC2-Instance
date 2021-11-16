#Main variables

variable "aws_region" {
    type = string
    #Defaulting to US-east-1
    default = "us-east-1"
}

variable "aws_public_key" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBZITSKEqSCz4AkaxwA+vaCLJMpvW3OPw9PhRImzvyt1sLVdAlQMbFoKI8//J4GeseuoPAZNYlIgc1YEx1d4pghatSIVEdfEp/1ZSHkcq5I9ir3UPeTZ46tznKeuAYfijh5BiSYVsST8WNz1d8tkpY1W0qcsM8ox6IoQObakOh/o9RXeuKumbd9EJOHgrTyQ1VVuZ0wYwW3dbfNFd3RcfYtl1RKNmb/L/U9AXsyWDZWdgLXkA9y8xw+MtOQbSNpKur24s9JPnsIq8qE5+C0JxDR8cZ9wYO2V6ZNSdKhxm6lT6s8N3yHtvlanmFowHhO1UbMPsSr+XNqrn0CEXAMPLE"
}

#The AWS Instance Variables of AMI and Type

variable "aws_ec2_ami" {
    type = string
    #We default to Ubuntu AMI for US-East-1
    default = "ami-09e67e426f25ce0d7"
}

variable "aws_ec2_instance_type" {
    type = string
    default = "t2.micro"
}

#VPC Variables

variable "aws_vpc_cidr" {
    #format of this variable is a string with the cidr block inside "10.0.0.0/16"
    type = string
    default = "10.0.0.0/16"
}

variable "aws_vpc_tenancy" {
    type = string
    default = "default"
}

variable "aws_subnet_cidr" {
    #format of this variable is a string with the cidr block inside "10.0.0.0/16"
    type = string
    default = "10.0.0.0/24"
}

