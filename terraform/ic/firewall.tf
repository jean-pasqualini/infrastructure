resource "google_compute_firewall" "ansible-ci-allow-ssh-http-https" {
  name = "integration-continue-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}