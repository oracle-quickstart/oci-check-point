output "vcn_id" {
  value = ! var.use_existing_network ? join("", oci_core_vcn.vcn.*.id) : var.vcn_id
}

output "public_subnet_id" {
  value = ! var.use_existing_network ? join("", oci_core_subnet.public_subnet.*.id) : var.public_subnet_id
}

output "private_subnet_id" {
  value = ! var.use_existing_network ? join("", oci_core_subnet.private_subnet.*.id) : var.private_subnet_id
}

output "vcn_cidr_block" {
  value = ! var.use_existing_network ? join("", oci_core_vcn.vcn.*.cidr_block) : var.vcn_cidr_block
}
