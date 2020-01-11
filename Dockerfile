FROM ubuntu

ARG VER=0.12.19

COPY hashicorp.asc .

RUN apt-get update && apt-get install -y gpg curl unzip

RUN gpg --import hashicorp.asc && rm hashicorp.asc

RUN curl -Os https://releases.hashicorp.com/terraform/0.12.19/terraform_${VER}_SHA256SUMS ; \
    curl -Os https://releases.hashicorp.com/terraform/0.12.19/terraform_${VER}_SHA256SUMS.sig ; \
    curl -Os https://releases.hashicorp.com/terraform/0.12.19/terraform_${VER}_linux_amd64.zip

RUN gpg --verify terraform_${VER}_SHA256SUMS.sig terraform_${VER}_SHA256SUMS ; \
    sha256sum --check --quiet --ignore-missing terraform_${VER}_SHA256SUMS

RUN unzip terraform_${VER}_linux_amd64.zip -d terraform_${VER}

RUN ln -s terraform_${VER} terraform

RUN rm terraform_${VER}_SHA256SUMS terraform_${VER}_SHA256SUMS.sig terraform_${VER}_linux_amd64.zip

WORKDIR /terraform

CMD [ "./terraform" ]