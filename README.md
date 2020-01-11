
docker build -t yangand/terraform .

docker run --rm --name terraform -it yangand/terraform

docker run --rm --name terraform -it yangand/terraform /bin/bash
