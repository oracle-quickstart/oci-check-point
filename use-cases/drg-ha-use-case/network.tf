# ------ Create South HUB VCN
resource "oci_core_vcn" "south_hub" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.south_hub_vcn_cidr_block
  dns_label      = var.south_hub_vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.south_hub_vcn_display_name
}

# ------ Create North HUB VCN
resource "oci_core_vcn" "north_hub" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.north_hub_vcn_cidr_block
  dns_label      = var.north_hub_vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.north_hub_vcn_display_name
}

# ------ Create South Hub VCN IGW
resource "oci_core_internet_gateway" "south_igw" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.south_hub_vcn_display_name}-igw"
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  enabled        = "true"
}

# ------ Create North Hub VCN IGW
resource "oci_core_internet_gateway" "north_igw" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.north_hub_vcn_display_name}-igw"
  vcn_id         = oci_core_vcn.north_hub[count.index].id
  enabled        = "true"
}

# ------ Create DRG
resource "oci_core_drg" "drg" {
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.south_hub_vcn_display_name}-drg"
}

# ------ Default Routing Table for Hub VCN 
resource "oci_core_default_route_table" "north_default_route_table" {
  count                      = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.north_hub[count.index].default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.north_igw[count.index].id
  }
}

# ------ Default Routing Table for Hub VCN 
resource "oci_core_default_route_table" "south_default_route_table" {
  count                      = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.south_hub[count.index].default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.south_igw[count.index].id
  }
}
# ------ Default Routing Table for Hub VCN 
resource "oci_core_route_table" "south_hub_frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  display_name   = var.public_routetable_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.south_igw[count.index].id
  }
}

# ------ Default Routing Table for Hub VCN 
resource "oci_core_route_table" "north_hub_frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.north_hub[count.index].id
  display_name   = var.public_routetable_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.north_igw[count.index].id
  }
}

# ------ Default Routing Table for Hub VCN 
resource "oci_core_route_table" "north_hub_nlb_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.north_hub[count.index].id
  display_name   = var.nlb_routetable_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.north_igw[count.index].id
  }
}


# ------ Create DRG North Hub Route Table
resource "oci_core_route_table" "north_hub_drg_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.north_hub[count.index].id
  display_name   = var.drg_routetable_display_name
}

# ------ Create DRG South Hub Route Table
resource "oci_core_route_table" "south_hub_drg_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  display_name   = var.drg_routetable_display_name
}

# ------ Get All Services Data Value 
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# # ------ Create Hub Service Gateway (North Hub VCN)
# resource "oci_core_service_gateway" "north_hub_service_gateway" {
#   count          = local.use_existing_network ? 0 : 1
#   compartment_id = var.network_compartment_ocid
#   vcn_id         = oci_core_vcn.north_hub[count.index].id
#   services {
#     service_id = data.oci_core_services.all_services.services[0]["id"]
#   }
#   display_name   = "hubServiceGateway"
#   route_table_id = oci_core_route_table.north_hub_service_gw_route_table_transit_routing[count.index].id
# }

# ------ Create Hub Service Gateway (Hub VCN)
resource "oci_core_service_gateway" "south_hub_service_gateway" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  services {
    service_id = data.oci_core_services.all_services.services[0]["id"]
  }
  display_name   = "hubServiceGateway"
  route_table_id = oci_core_route_table.south_hub_service_gw_route_table_transit_routing[count.index].id
}

# ------ Get Hub Service Gateway from Gateways (Hub VCN)
data "oci_core_service_gateways" "south_hub_service_gateways" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  state          = "AVAILABLE"
  vcn_id         = oci_core_vcn.south_hub[count.index].id
}

# ------ Get Hub Service Gateway from Gateways (Hub VCN)
data "oci_core_service_gateways" "north_hub_service_gateways" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  state          = "AVAILABLE"
  vcn_id         = oci_core_vcn.north_hub[count.index].id
}


# ------ Associate Emptry Route Tables to Service Gateway on Hub VCN Floating IP
resource "oci_core_route_table" "south_hub_service_gw_route_table_transit_routing" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  display_name   = var.sgw_routetable_display_name

  route_rules {
    network_entity_id = oci_core_private_ip.south_hub_cluster_backend_ip.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

# # ------ Associate Emptry Route Tables to Service Gateway on Hub VCN Floating IP
# resource "oci_core_route_table" "north_hub_service_gw_route_table_transit_routing" {
#   count          = local.use_existing_network ? 0 : 1
#   compartment_id = var.network_compartment_ocid
#   vcn_id         = oci_core_vcn.north_hub[count.index].id
#   display_name   = var.sgw_routetable_display_name

#   route_rules {
#     network_entity_id = oci_core_private_ip.north_hub_cluster_backend_ip.id

#     destination      = "0.0.0.0/0"
#     destination_type = "CIDR_BLOCK"
#   }
# }


# ------ Create Hub VCN Public subnet
resource "oci_core_subnet" "north_hub_frontend_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.north_hub[count.index].id
  cidr_block                 = var.north_hub_frontend_subnet_cidr_block
  display_name               = var.north_hub_frontend_subnet_display_name
  dns_label                  = var.north_hub_frontend_subnet_dns_label
  prohibit_public_ip_on_vnic = "false"
  security_list_ids = [data.oci_core_security_lists.allow_all_security_north_hub_vcn.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_north_hub_vcn,
  ]
}

# ------ Create Hub VCN Backend subnet
resource "oci_core_subnet" "north_hub_backend_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.north_hub[count.index].id
  cidr_block                 = var.north_hub_backend_subnet_cidr_block
  display_name               = var.north_hub_backend_subnet_display_name
  dns_label                  = var.north_hub_backend_subnet_dns_label
  prohibit_public_ip_on_vnic = "true"
  security_list_ids = [data.oci_core_security_lists.allow_all_security_north_hub_vcn.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_north_hub_vcn,
  ]
}

# ------ Create North Hub VCN NLB subnet
resource "oci_core_subnet" "north_hub_nlb_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.north_hub[count.index].id
  cidr_block                 = var.north_hub_nlb_subnet_cidr_block
  display_name               = var.north_hub_nlb_subnet_display_name
  dns_label                  = var.north_hub_nlb_subnet_dns_label
  prohibit_public_ip_on_vnic = "false"
  security_list_ids = [data.oci_core_security_lists.allow_all_security_north_hub_vcn.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_north_hub_vcn,
  ]
}

# ------ Create Hub VCN Public subnet
resource "oci_core_subnet" "south_hub_frontend_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.south_hub[count.index].id
  cidr_block                 = var.south_hub_frontend_subnet_cidr_block
  display_name               = var.south_hub_frontend_subnet_display_name
  dns_label                  = var.south_hub_frontend_subnet_dns_label
  prohibit_public_ip_on_vnic = "false"
  security_list_ids = [data.oci_core_security_lists.allow_all_security_south_hub_vcn.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_south_hub_vcn,
  ]
}

# ------ Create South Hub VCN Backend subnet
resource "oci_core_subnet" "south_hub_backend_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.south_hub[count.index].id
  cidr_block                 = var.south_hub_backend_subnet_cidr_block
  display_name               = var.south_hub_backend_subnet_display_name
  dns_label                  = var.south_hub_backend_subnet_dns_label
  prohibit_public_ip_on_vnic = "true"
  security_list_ids = [data.oci_core_security_lists.allow_all_security_south_hub_vcn.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_south_hub_vcn,
  ]
}

# ------ Update Route Table for Backend Subnet
resource "oci_core_route_table_attachment" "update_north_hub_backend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.north_hub_backend_subnet_id : oci_core_subnet.north_hub_backend_subnet[0].id
  route_table_id = oci_core_route_table.north_hub_backend_route_table[count.index].id
}

# ------ Update Route Table for Frontend Subnet
resource "oci_core_route_table_attachment" "update_north_hub_frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.north_hub_frontend_subnet_id : oci_core_subnet.north_hub_frontend_subnet[0].id
  route_table_id = oci_core_route_table.north_hub_frontend_route_table[count.index].id
}

# ------ Update Route Table for NLB Subnet
resource "oci_core_route_table_attachment" "update_north_hub_nlb_route_table" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.north_hub_nlb_subnet_id : oci_core_subnet.north_hub_nlb_subnet[0].id
  route_table_id = oci_core_route_table.north_hub_nlb_route_table[count.index].id
}

# ------ Update Route Table for Backend Subnet
resource "oci_core_route_table_attachment" "update_south_hub_backend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.south_hub_backend_subnet_id : oci_core_subnet.south_hub_backend_subnet[0].id
  route_table_id = oci_core_route_table.south_hub_backend_route_table[count.index].id
}

# ------ Update Route Table for Frontend Subnet
resource "oci_core_route_table_attachment" "update_south_hub_frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.south_hub_frontend_subnet_id : oci_core_subnet.south_hub_frontend_subnet[0].id
  route_table_id = oci_core_route_table.south_hub_frontend_route_table[count.index].id
}

# ------ Create Cluster Backend Floating IP (Hub VCN)
resource "oci_core_private_ip" "south_hub_cluster_backend_ip" {
  vnic_id      = data.oci_core_vnic_attachments.south_hub_backend_attachments.vnic_attachments.0.vnic_id
  display_name = "firewall_backend_secondary_private_ip"
}

# ------ Create Cluster Frontend Floating IP (Hub VCN)
resource "oci_core_private_ip" "south_hub_cluster_frontend_ip" {
  vnic_id = data.oci_core_vnic_attachments.south_hub_master_attachments.vnic_attachments.0.vnic_id
  display_name = "firewall_frontend_secondary_private_ip"
}

# # frontend cluster ip 
resource "oci_core_public_ip" "south_hub_cluster_public_ip" {
  count          = (var.use_existing_ip != "Create new IP") ? 0 : 1
  compartment_id = var.network_compartment_ocid

  lifetime      = "RESERVED"
  private_ip_id = oci_core_private_ip.south_hub_cluster_frontend_ip.id
}

# ------ Create route table for backend to point to backend cluster ip (Hub VCN)
resource "oci_core_route_table" "north_hub_backend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.north_hub_vcn_id : oci_core_vcn.north_hub[0].id
  display_name   = var.private_routetable_display_name
}


# ------ Create route table for backend to point to backend cluster ip (Hub VCN)
resource "oci_core_route_table" "south_hub_backend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.south_hub_vcn_id : oci_core_vcn.south_hub[0].id
  display_name   = var.private_routetable_display_name

  route_rules {
    network_entity_id = oci_core_private_ip.south_hub_cluster_backend_ip.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  depends_on = [
    oci_core_private_ip.south_hub_cluster_backend_ip,
  ]
}
# ------ Add North Hub Backend route table to Backend subnet (Hub VCN)
resource "oci_core_route_table_attachment" "north_hub_backend_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = local.use_existing_network ? var.north_hub_backend_subnet_id : oci_core_subnet.north_hub_backend_subnet[0].id
  route_table_id = oci_core_route_table.north_hub_backend_route_table[count.index].id
}

# ------ Create Web VCN
resource "oci_core_vcn" "web" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.web_vcn_cidr_block
  dns_label      = var.web_vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.web_vcn_display_name
}

# # ------ Create Web VCN LPG(Local Peering Gateway)
# resource "oci_core_local_peering_gateway" "web_hub_local_peering_gateway" {
#   count          = local.use_existing_network ? 0 : 1
#   compartment_id = var.network_compartment_ocid
#   vcn_id         = oci_core_vcn.web[count.index].id
#   display_name   = "LPG WebApp Spoke"
# }

# ------ Create Web Route Table and Associate to Web LPG
resource "oci_core_default_route_table" "web_default_route_table" {
  count                      = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.web[count.index].default_route_table_id
  route_rules {
    network_entity_id = oci_core_drg.drg.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# ------ Add Web Private Subnet to Web VCN
resource "oci_core_subnet" "web_private-subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.web_transit_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.web[count.index].id
  display_name               = var.web_transit_subnet_display_name
  dns_label                  = var.web_transit_subnet_dns_label
  prohibit_public_ip_on_vnic = true
  security_list_ids = [data.oci_core_security_lists.allow_all_security_web.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_web,
  ]
}

# ------ Add Web Load Balancer Subnet to Web VCN
resource "oci_core_subnet" "web_lb-subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.web_lb_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.web[count.index].id
  display_name               = var.web_lb_subnet_display_name
  dns_label                  = var.web_lb_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  security_list_ids = [data.oci_core_security_lists.allow_all_security_web.security_lists[0].id]
  depends_on = [
    oci_core_security_list.allow_all_security_web,
  ]
}

# ------ Create DB VCN
resource "oci_core_vcn" "db" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.db_vcn_cidr_block
  dns_label      = var.db_vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.db_vcn_display_name
}

# ------ Create DB Route Table and Associate to DB LPG
resource "oci_core_default_route_table" "db_default_route_table" {
  count                      = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.db[count.index].default_route_table_id
  route_rules {
    network_entity_id = oci_core_drg.drg.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# ------ Add DB Private Subnet to DB VCN
resource "oci_core_subnet" "db_private-subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.db_transit_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.db[count.index].id
  display_name               = var.db_transit_subnet_display_name
  dns_label                  = var.db_transit_subnet_dns_label
  prohibit_public_ip_on_vnic = true

  security_list_ids = [data.oci_core_security_lists.allow_all_security_db.security_lists[0].id]

  depends_on = [
    oci_core_security_list.allow_all_security_db,
  ]

}

# ------ Update Default Security List to All All  Rules
resource "oci_core_security_list" "allow_all_security_south_hub_vcn" {
  display_name   = "AllowAll"
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}

# ------ Update Default Security List to All All  Rules
resource "oci_core_security_list" "allow_all_security_north_hub_vcn" {
  display_name   = "AllowAll"
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.north_hub[count.index].id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}


# ------ Update Default Security List to All All  Rules
resource "oci_core_security_list" "allow_all_security_web" {
  display_name   = "AllowAll"
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.web[count.index].id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}


# ------ Update Default Security List to All All  Rules
resource "oci_core_security_list" "allow_all_security_db" {
  display_name   = "AllowAll"
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.db[count.index].id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}



# # ---- Create VCN Ingress Route Table on Hub VCN
resource "oci_core_route_table" "vcn_ingress_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.south_hub[count.index].id
  display_name   = "VCN-INGRESS"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_private_ip.south_hub_cluster_backend_ip.id
  }
}

# ------ Attach DRG to Hub VCN
resource "oci_core_drg_attachment" "north_hub_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  display_name       = "North_Hub_Firewall_VCN"
  drg_route_table_id = oci_core_drg_route_table.from_firewall_route_table.id
  vcn_id             = local.use_existing_network ? var.north_hub_vcn_id : oci_core_vcn.north_hub.0.id
}

# ------ Attach DRG to Hub VCN
resource "oci_core_drg_attachment" "hub_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  display_name       = "South_Hub_Firewall_VCN"
  drg_route_table_id = oci_core_drg_route_table.from_firewall_route_table.id

  network_details {
    id   = local.use_existing_network ? var.south_hub_vcn_id : oci_core_vcn.south_hub.0.id
    type = "VCN"
    route_table_id = oci_core_route_table.vcn_ingress_route_table.0.id
  }
}

# ------ Attach DRG to Web Spoke VCN
resource "oci_core_drg_attachment" "web_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  vcn_id             = local.use_existing_network ? var.web_vcn_id : oci_core_vcn.web.0.id
  display_name       = "Web_VCN"
  drg_route_table_id = oci_core_drg_route_table.to_firewall_route_table.id
}

# ------ Attach DRG to DB Spoke VCN
resource "oci_core_drg_attachment" "db_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  vcn_id             = local.use_existing_network ? var.db_vcn_id : oci_core_vcn.db.0.id
  display_name       = "DB_VCN"
  drg_route_table_id = oci_core_drg_route_table.to_firewall_route_table.id
}

# ------ Create From Firewall Route Table to DRG
resource "oci_core_drg_route_table" "from_firewall_route_table" {
  drg_id                           = oci_core_drg.drg.id
  display_name                     = "From-Firewall"
  import_drg_route_distribution_id = oci_core_drg_route_distribution.firewall_drg_route_distribution.id
}

# ------ Create To Firewall Route Table to DRG
resource "oci_core_drg_route_table" "to_firewall_route_table" {
  drg_id       = oci_core_drg.drg.id
  display_name = "To-Firewall"
}

# ---- Update To Firewall Route Table Pointing to Hub VCN 
resource "oci_core_drg_route_table_route_rule" "to_firewall_drg_route_table_route_rule" {
  drg_route_table_id         = oci_core_drg_route_table.to_firewall_route_table.id
  destination                = "0.0.0.0/0"
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = oci_core_drg_attachment.hub_drg_attachment.id
}

# ---- Update To Firewall Route Table Pointing to Hub VCN 
resource "oci_core_drg_route_table_route_rule" "to_firewall_drg_route_table_route_rule_two" {
  drg_route_table_id         = oci_core_drg_route_table.to_firewall_route_table.id
  destination                = "10.1.0.0/16"
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = oci_core_drg_attachment.north_hub_drg_attachment.id
}

# ---- DRG Route Import Route Distribution
resource "oci_core_drg_route_distribution" "firewall_drg_route_distribution" {
  distribution_type = "IMPORT"
  drg_id            = oci_core_drg.drg.id
  display_name      = "Transit-Spokes"
}

# ---- DRG Route Import Route Distribution Statements - One
resource "oci_core_drg_route_distribution_statement" "firewall_drg_route_distribution_statement_one" {
  drg_route_distribution_id = oci_core_drg_route_distribution.firewall_drg_route_distribution.id
  action                    = "ACCEPT"
  match_criteria {
    match_type = "DRG_ATTACHMENT_ID"
    drg_attachment_id = oci_core_drg_attachment.web_drg_attachment.id
  }
  priority = "1"
}

# ---- DRG Route Import Route Distribution Statements - Two 
resource "oci_core_drg_route_distribution_statement" "firewall_drg_route_distribution_statement_two" {
  drg_route_distribution_id = oci_core_drg_route_distribution.firewall_drg_route_distribution.id
  action                    = "ACCEPT"
  match_criteria {
    match_type = "DRG_ATTACHMENT_ID"
    drg_attachment_id = oci_core_drg_attachment.db_drg_attachment.id
  }
  priority = "2"
}


