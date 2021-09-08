#!/bin/sh
set -e

REDIS=${1:-n}

install_docker() {
    echo -e "------> Install Docker \n"
    sudo apt-get update -y
    
    sudo apt install apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

    sudo apt update -y

    apt-cache policy docker-ce

    sudo apt install docker-ce -y

    sudo usermod -aG docker $(whoami)

    sudo systemctl status docker
}

install_git() {
    echo -e "------> Install Git \n"
    sudo apt install git -y
}

install_aws() {
    echo -e "------> Install AWS CLI 2 \n"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}

install_make() {
    echo -e "------> Install Make \n"
    sudo apt-get install build-essential -y
}

install_docker_compose() {
    # get latest docker compose released tag
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    
    echo -e "------> Installing docker compose version ${COMPOSE_VERSION}\n"

    sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null

    sudo chmod +x /usr/local/bin/docker-compose

    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    docker-compose --version
}

install_redis() {
    echo -e "------> Installing Redis\n"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install redis-server -y
    sudo systemctl enable redis-server.service
}

main() {
    install_docker
    install_git
    install_make
    install_docker_compose
    install_aws
    if [ $REDIS != "${REDIS#[Yy]}" ] ;then
        install_redis
    fi
}



main
