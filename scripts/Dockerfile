FROM maven:3.5.2-jdk-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python3-pip sshpass git openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
    
RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible==2.9.15 && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    pip install awscli

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

RUN apt-get update && \
    apt-get -y install curl && \
    apt-get -y install wget && \
    wget https://deb.nodesource.com/setup_10.x && \
    mv setup_10.x /tmp/node_setup.sh && \
    chmod a+x /tmp/node_setup.sh && \
    sh /tmp/node_setup.sh && \
    apt -y install nodejs && \
    npm install @angular/cli 

WORKDIR /ansible

RUN apt-get install -y unzip jq
ENV PACKER_BIN_DIR /usr/local/packer/bin
RUN mkdir --parents $PACKER_BIN_DIR 

ENV PACKER_ZIP=https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_linux_amd64.zip
RUN curl -sSLo /tmp/packer.zip $PACKER_ZIP && \
  unzip /tmp/packer.zip -d $PACKER_BIN_DIR && \
  rm /tmp/packer.zip
ENV PATH $PATH:$PACKER_BIN_DIR

# check that packer is correctly installed
RUN type packer
CMD [ "ansible-playbook", "--version" ]