
docker build -t yangand/terraform .

docker run --rm --name terraform -it yangand/terraform

docker run --rm --name terraform -it --entrypoint /bin/bash -v ${PWD}:/aws -v ~/.aws:/root/.aws yangand/terraform
