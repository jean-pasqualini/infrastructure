#!/bin/bash
echo '--> Detect DOCKER'
DOCKER_DETECTOR=/var/run/docker.sock
if [ ! -f $DOCKER_DETECTOR ]; then
    echo '--> Install DOCKER';
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sleep 5
    sudo sed -i 's~fd://~fd:// -H 0.0.0.0:2375~g' /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo service docker restart
    curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-"$(uname -s)"-"$(uname -m)" | sudo tee /usr/local/bin/docker-compose > /dev/null
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo '--> Start IC'
sudo chmod 777 /var/run/docker.sock
curl -Lk "https://x-oauth-token:$GITHUB_TOKEN@github.com/jean-pasqualini/infrastructure/tarball/master" | tar -xzv -C ./ --strip-components 1 --exclude="{README.md}" --wildcards jean*/docker/ic/
cd docker/ic || return
docker-compose up