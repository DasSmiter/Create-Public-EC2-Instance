output "domain-name" {
  #The only default output we're including is the DNS for our public EC2 instance so the user can verify if it deployed correctly.
  value = aws_instance.web.public_dns
}