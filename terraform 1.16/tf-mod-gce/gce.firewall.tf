resource "google_compute_firewall" "ingress_allow" {
  for_each = var.firewall_rules_to_allow == null ? {} : {
    for rule in var.firewall_rules_to_allow : rule.rule_name => rule
  }

  name    = "${var.vm_name}-${each.value.rule_name}"
  network = var.network

  allow {
    protocol = each.value.protocol
    ports    = ["${each.value.port}"]
  }

  source_ranges = ["${each.value.source_range}"]
  target_tags   = each.value.network_tags
}
