data "oci_core_vnic_attachments" "master_attachments" {
  compartment_id = var.compartment_ocid
  instance_id    = oci_core_instance.cluster-vm.0.id

  filter {
    name   = "subnet_id"
    values = [module.vcn_plus_two_subnet.public_subnet_id]
  }

  depends_on = [
    oci_core_vnic_attachment.private_vnic_attachment,
  ]
}
