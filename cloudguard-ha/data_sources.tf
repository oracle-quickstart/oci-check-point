data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_fault_domains" "fds" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = var.compute_compartment_ocid

  depends_on = [
    data.oci_identity_availability_domain.ad,
  ]
}

data "oci_core_vnic_attachments" "master_attachments" {
  compartment_id = var.network_compartment_ocid
  instance_id    = oci_core_instance.ha-vms.0.id

  filter {
    name   = "subnet_id"
    values = [local.use_existing_network ? var.public_subnet_id : oci_core_subnet.public_subnet[0].id]
  }

  depends_on = [
    oci_core_vnic_attachment.private_vnic_attachment,
  ]
}
