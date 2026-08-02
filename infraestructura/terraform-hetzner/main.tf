resource "hcloud_ssh_key" "default" {
  name       = "portfolio-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "hcloud_firewall" "web" {
  name = "fw-portfolio"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.allowed_ssh_cidr]
  }
}

resource "hcloud_server" "web" {
  name         = "vm-portfolio"
  server_type  = var.server_type
  image        = "ubuntu-24.04"
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.web.id]
}

output "instance_public_ip" {
  description = "IP pública de la VM."
  value       = hcloud_server.web.ipv4_address
}

output "ssh_command" {
  description = "Comando para conectarte (en Hetzner el usuario es root)."
  value       = "ssh -i ~/.ssh/oci_portfolio root@${hcloud_server.web.ipv4_address}"
}