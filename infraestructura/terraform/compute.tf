//Imagen de Ubuntu para la VM
/* data "oci_core_images" "ubuntu" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
} */

//La VM que se va a crear
/* resource "oci_core_instance" "web" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "vm-portfolio"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gbs
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(pathexpand(var.ssh_public_key_path))
  }
} */

//Salidas para mostrar información de la VM
/* output "instance_public_ip" {
  description = "IP pública de la VM."
  value       = oci_core_instance.web.public_ip
} */

//Comando SSH listo para conectarse a la VM
/* output "ssh_command" {
  description = "Comando listo para conectarte."
  value       = "ssh -i ~/.ssh/oci_portfolio ubuntu@${oci_core_instance.web.public_ip}"
} */

data "oci_core_images" "ubuntu" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "web" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "vm-portfolio"
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(pathexpand(var.ssh_public_key_path))
  }
}

output "instance_public_ip" {
  description = "IP pública de la VM."
  value       = oci_core_instance.web.public_ip
}

output "ssh_command" {
  description = "Comando listo para conectarte."
  value       = "ssh -i ~/.ssh/oci_portfolio ubuntu@${oci_core_instance.web.public_ip}"
}