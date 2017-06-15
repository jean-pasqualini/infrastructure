resource "google_compute_instance" "integration-continue" {
  count 		= 1
  name 			= "integration-continue"
  machine_type 	= "n1-standard-1"
  tags 			= ["integration-continue"]
  zone			= "${var.region_zone}"

  metadata {
    startup-script = <<EOF
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
    sudo curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo '--> Start IC'
sudo chmod 777 /var/run/docker.sock
curl -Lk "https://x-oauth-token:$GITHUB_TOKEN@github.com/jean-pasqualini/infrastructure/tarball/master" | tar -xzv -C ./ --strip-components 1 --exclude="{README.md}" --wildcards jean*/docker/ic/
cd docker/ic
docker-compose up
EOF
  }

  disk {
    auto_delete = true
    type	= "pd-standard"
    image 	= "ubuntu-1604-xenial-v20170610"
    size	= "30"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}
