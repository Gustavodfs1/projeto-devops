FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install ansible wget unzip python3-pip rsync -y && \
  pip3 install boto boto3 botocore && \
  wget https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip -O /tmp/terraform_1.0.8_linux_amd64.zip && \
  unzip /tmp/terraform_1.0.8_linux_amd64.zip -d /usr/bin && \
  ansible-galaxy collection install amazon.aws