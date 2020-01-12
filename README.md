
docker build -t yangand/terraform .

docker run --rm --name terraform -it yangand/terraform

docker run --rm --name terraform -it -v ${PWD}:/opt -v ~/.aws:/home/terraform/.aws yangand/terraform

---

ssh -L 8888:192.168.0.107:22 -i ~/.aws/ssh-key.pem ubuntu@ec2-13-48-84-139.eu-north-1.compute.amazonaws.com

ssh -i ~/.aws/ssh-key.pem -p 8888 ubuntu@localhost

terraform fmt
terraform apply
terraform validate
