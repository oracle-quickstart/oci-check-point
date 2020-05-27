resource "oci_core_vcn" "vcn" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.vcn_cidr_block
  dns_label      = var.vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.vcn_display_name
}

resource "oci_core_internet_gateway" "igw" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vcn_display_name}-igw"
  vcn_id         = oci_core_vcn.vcn[count.index].id
  enabled        = "true"
}

resource "oci_core_default_route_table" "default_route_table" {
  count                      = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.vcn[count.index].default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw[count.index].id
  }
}

resource "oci_core_subnet" "public_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.vcn[count.index].id
  cidr_block                 = var.public_subnet_cidr_block
  display_name               = var.public_subnet_display_name
  route_table_id             = oci_core_vcn.vcn[count.index].default_route_table_id
  dns_label                  = var.public_subnet_dns_label
  prohibit_public_ip_on_vnic = "false"
}

resource "oci_core_subnet" "private_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.vcn[count.index].id
  cidr_block                 = var.private_subnet_cidr_block
  display_name               = var.private_subnet_display_name
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_private_ip" "cluster_frontend_ip" {
  vnic_id = data.oci_core_vnic_attachments.master_attachments.vnic_attachments.0.vnic_id
}

# frontend cluster ip 
resource "oci_core_public_ip" "cluster_public_ip" {
  count          = (var.use_existing_ip != "Create new IP") ? 0 : 1
  compartment_id = var.network_compartment_ocid

  lifetime      = "RESERVED"
  private_ip_id = oci_core_private_ip.cluster_frontend_ip.id
}

# backend cluster IP
resource "oci_core_private_ip" "cluster_private_ip" {
  vnic_id = oci_core_vnic_attachment.private_vnic_attachment.0.vnic_id
}

# create route table for backend to point to backend cluster ip
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.vcn[0].id
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
  subnet_id      = local.use_existing_network ? var.private_subnet_id : oci_core_subnet.private_subnet[0].id 
  route_table_id = oci_core_route_table.private_route_table.id
}
