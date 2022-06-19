## Building docker image that has packer, ansible and inspec
FROM ubuntu:20.04

LABEL maintainer="Cong TO <congto@hocchudong.com>"


ENV PACKER_VERSION=1.8.0
ENV PACKER_SHA256SUM=f323fc29525a7d94b9b008cd533a0687b01e0882417a2f838785df7c77350030

RUN apt-get update && \
    apt-get install -y git curl bash wget openssl unzip coreutils

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS
RUN sha256sum -c packer_${PACKER_VERSION}_SHA256SUMS
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip


RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python3-pip sshpass git openssh-client vim && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean


RUN packer plugins install github.com/rgl/windows-update v0.14.0
RUN packer plugins install github.com/hashicorp/vsphere v1.0.2

   
# RUN python3 -m pip install --upgrade pip cffi && \
#    pip install ansible-base==2.10.13 ansible==3.4.0 && \
#    pip install mitogen ansible-lint jmespath && \
#    pip install --upgrade pywinrm && \
#    pip install --upgrade j2cli && \
#    rm -rf /root/.cache/pip

#RUN mkdir /ansible && \
#    mkdir -p /etc/ansible && \
#    echo 'localhost' > /etc/ansible/hosts


ENV USER root

ENTRYPOINT ["/bin/bash", "-c"]