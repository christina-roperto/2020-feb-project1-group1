FROM ubuntu:18.04 as tf012aws2

RUN apt-get update && apt-get install curl make unzip sudo less -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
	unzip awscliv2.zip && \
	sudo ./aws/install && \
	rm -rf /var/lib/apt/lists/* && \
    curl https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip -o "terraform.zip" && \
    unzip ./terraform.zip -d /usr/local/bin

CMD [ "bash" ]
