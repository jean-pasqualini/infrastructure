resource "google_compute_address" "integration-continue" {
  count = 1
  name = "integration-continue"
}

resource "google_compute_instance" "integration-continue" {
  count 		= 1
  name 			= "integration-continue"
  machine_type 	= "n1-standard-1"
  tags 			= ["integration-continue"]
  zone			= "${var.region_zone}"

  metadata {
    startup-script = "${file("boot.sh")}"
  }

  disk {
    auto_delete = true
    type	= "pd-standard"
    image 	= "ubuntu-1604-xenial-v20170610"
    size	= "50"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.integration-continue.address}"
    }
  }
}

output "ip" {
  value = "${google_compute_address.integration-continue.address}"
}