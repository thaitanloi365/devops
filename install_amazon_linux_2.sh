install_docker() {
    echo -e "------> Install Docker \n"
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user

    sudo chkconfig docker on

    sudo yum install -y git
}


install_git() {
    echo -e "------> Install Git \n"
    sudo yum install -y git
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

main() {
    install_docker
    install_git
    install_docker_compose
    sudo reboot
}



main
