#The outputs file holds all the outputs we want Terraform to show, you can add various
#information from the different components here, but by default we only output the domain for the isntance

output "domain-name" {
  #The only default output we're including is the DNS for our public EC2 instance so the user can verify if it deployed correctly.
  value = aws_instance.web.public_dns
}