#!/bin/sh
set -e

REDIS=${1:-n}

install_docker() {
    echo -e "------> Install Docker \n"
    sudo apt-get update

    sudo apt-get remove docker docker-engine docker.io
    
    sudo apt install docker.io
    
    sudo usermod -aG docker $(whoami)

    sudo systemctl start docker
}

install_git() {
    echo -e "------> Install Git \n"
    sudo apt install git
}

install_make() {
    echo -e "------> Install Make \n"
    sudo apt-get install build-essential
}

install_docker_compose() {
    echo -e "------> Installing docker compose\n"
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null

    sudo chmod +x /usr/local/bin/docker-compose

    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    docker-compose --version
}

install_redis() {
    echo -e "------> Installing Redis\n"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install redis-server
    sudo systemctl enable redis-server.service
}

main() {
    install_docker
    install_git
    install_make
    install_docker_compose
    if [ $REDIS != "${REDIS#[Yy]}" ] ;then
        install_redis
    fi
}



main
