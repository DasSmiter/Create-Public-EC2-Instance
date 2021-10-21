provider "aws" {
  # Us East 1 region allows for future component additions, its the most useful of them.
  # This would need to be replaced if using another region
  # Considering setting this up as a variable as well
  region = "us-east-1"
}

# The provider for random names
provider "random" {}

# We need to define a resource to provide our random name.  random_pet.name.id retrieves this.
# All resources in this project will be named in AWS after this unique pet name using name tags
resource "random_pet" "name" {}

# The SSH Key Pair is defined here.  We use a public key in the reference, but this needs to be set up specific to your private keys
# You can generate the public key to insert here from a private key
# Create one in AWS if unsure how to make your own
# The key pair will be used to ssh into our instance after creation, if we wish
resource "aws_key_pair" "web-kp" {
  key_name   = "web-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBZITSKEqSCz4AkaxwA+vaCLJMpvW3OPw9PhRImzvyt1sLVdAlQMbFoKI8//J4GeseuoPAZNYlIgc1YEx1d4pghatSIVEdfEp/1ZSHkcq5I9ir3UPeTZ46tznKeuAYfijh5BiSYVsST8WNz1d8tkpY1W0qcsM8ox6IoQObakOh/o9RXeuKumbd9EJOHgrTyQ1VVuZ0wYwW3dbfNFd3RcfYtl1RKNmb/L/U9AXsyWDZWdgLXkA9y8xw+MtOQbSNpKur24s9JPnsIq8qE5+C0JxDR8cZ9wYO2V6ZNSdKhxm6lT6s8N3yHtvlanmFowHhO1UbMPsSr+XNqrn0CEXAMPLE"
}

# The instance definition
resource "aws_instance" "web" {
  ami           = "ami-09e67e426f25ce0d7" # The AMI referenced here is ubuntu and specific to the region
  instance_type = "t2.micro" # For now we want to remain in the free tier with a micro instance
  user_data     = file("init-script.sh") # Load in the user data script
  subnet_id     = aws_subnet.web-subnet.id # Instance needs to exist in our subnet
  vpc_security_group_ids = [aws_security_group.web-sg.id] # Attach the newly created Security Group to the instance
  associate_public_ip_address = true # Here is where we make our instance public associating an elastic IP
  key_name = aws_key_pair.web-kp.id # Set the keypair created earlier to be required

  tags = {
    Name = random_pet.name.id
  }
}
