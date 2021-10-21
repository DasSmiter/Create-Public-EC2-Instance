# Create a Public EC2 Instance with Terraform

This repo is a simple starting place for building a Public EC2 instance, including the necessary Virtual Private Cloud structures to make it accessible online.  It has a few component terraform files:

1. The VPC Definition - 
    This terraform file contains the Virtual Private Cloud components and definitions needed to provide public access for the EC2 instance.
2. The Instance Definition - 
    This terraform file contains the EC2 instance definitions.  We've created a simple installation setup which can be expanded, copied, or modified to fill out a fleet of EC2 instances as needed.
3. The EC2 User Data Script - 
    This bash script file contains the user data that will be loaded into the EC2 instance upon successful deployment.  It is currently bare except for loading bash as the shell and will need to modified prior to deployment.

Since this repo's purpose is to provide a structure for setting up a fleet of EC2 instances, including a private subnet, we have provided the basic structure for a private subnet and related NAT gateway.  Make sure to uncomment them if you are planning to make use of these components!