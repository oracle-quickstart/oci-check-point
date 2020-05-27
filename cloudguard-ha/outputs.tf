output "subscription" {
  value = data.oci_core_app_catalog_subscriptions.mp_image_subscription.*.app_catalog_subscriptions
}

output "vcn_id" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.vcn.*.id) : var.vcn_id
}

output "public_subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.public_subnet.*.id) : var.public_subnet_id
}

output "private_subnet_id" {
  value = ! local.use_existing_network ? join("", oci_core_subnet.private_subnet.*.id) : var.private_subnet_id
}

output "vcn_cidr_block" {
  value = ! local.use_existing_network ? join("", oci_core_vcn.vcn.*.cidr_block) : var.vcn_cidr_block
}

output "nsg_id" {
  value = join("", oci_core_network_security_group.nsg.*.id)
}

output "instance_ids" {
  value = [oci_core_instance.ha-vms.*.id]
}

output "instance_public_ips" {
  value = [oci_core_instance.ha-vms.*.public_ip]
}

output "instance_private_ips" {
  value = [oci_core_instance.ha-vms.*.private_ip]
}

output "instance_https_urls" {
  value = formatlist("https://%s", oci_core_instance.ha-vms.*.public_ip)
}

output "cluster_ip" {
  value = (var.use_existing_ip != "Create new IP") ? "No public cluster IP created" : oci_core_public_ip.cluster_public_ip.0.ip_address
}
