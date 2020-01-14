resource "oci_core_private_ip" "cluster_frontend_ip" {
  vnic_id = data.oci_core_vnic_attachments.master_attachments.vnic_attachments.0.vnic_id
}

# frontend cluster ip 
resource "oci_core_public_ip" "cluster_public_ip" {
  count          = (var.use_existing_ip != "Create new IP") ? 0 : 1
  compartment_id = var.compartment_ocid

  lifetime      = "RESERVED"
  private_ip_id = oci_core_private_ip.cluster_frontend_ip.id
}

# backend cluster IP
resource "oci_core_private_ip" "cluster_private_ip" {
  vnic_id = oci_core_vnic_attachment.private_vnic_attachment.0.vnic_id
}

# create route table for backend to point to backend cluster ip
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn_plus_two_subnet.vcn_id
  display_name   = var.private_routetable_display_name 

  route_rules {
    network_entity_id = oci_core_private_ip.cluster_private_ip.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  depends_on = [
    oci_core_private_ip.cluster_private_ip,
  ]
}

# add backend route table to backend subnet
resource "oci_core_route_table_attachment" "private_route_table_attachment" {
  subnet_id      = module.vcn_plus_two_subnet.private_subnet_id
  route_table_id = oci_core_route_table.private_route_table.id
}
