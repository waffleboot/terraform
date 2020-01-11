
// https://learn.hashicorp.com/terraform/getting-started/build#configuration

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-0662eb9b9b8685935"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

