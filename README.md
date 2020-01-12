
docker build -t yangand/terraform .

docker run --rm --name terraform -it yangand/terraform

docker run --rm --name terraform -it -v ${PWD}:/opt -v ~/.aws:/home/terraform/.aws yangand/terraform

---

ssh -L 8888:192.168.0.103:22 -i ssh-key.pem ec2-user@ec2-13-53-152-109.eu-north-1.compute.amazonaws.com

ssh -i ssh-key.pem -p 8888 ec2-user@localhost

terraform fmt
terraform apply
terraform validate
