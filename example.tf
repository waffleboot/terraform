
// https://learn.hashicorp.com/terraform/getting-started/build#configuration

provider "aws" {
  profile = "default"
  region  = "eu-north-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0662eb9b9b8685935"
  instance_type = "t3.micro"
}

