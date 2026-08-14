data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

output "availability_domains" {
  description = "Dominios dispoinibles en la región"
  value       = [for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name]
}