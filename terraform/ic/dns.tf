resource "google_dns_managed_zone" "io" {
  name        = "io-zone"
  dns_name    = "${var.domain}"
  description = "io zone"
}

resource "google_dns_record_set" "frontend" {
  name = "*.ic.${google_dns_managed_zone.io.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.io.name}"

  rrdatas = ["${google_compute_instance.integration-continue.network_interface.0.access_config.0.assigned_nat_ip}"]
}