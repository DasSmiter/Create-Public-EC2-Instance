terraform {
  required_providers {
    #Since we are setting up an EC2 instance we will be using AWS services for this.
    aws = {
      source = "hashicorp/aws"
    }
    #This is a Terraform provider that we use to provide a random name for our components.
    random = {
      source = "hashicorp/random"
    }
  }
}