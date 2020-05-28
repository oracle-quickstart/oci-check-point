resource "oci_core_network_security_group" "nsg" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.vcn.0.id

  #Optional
  display_name = var.nsg_display_name
}

resource "oci_core_network_security_group_security_rule" "rule_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp443" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

//Allow inbound logging connections from managed gateways
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp257" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 257
      max = 257
    }
  }
}

//Allow inbound access using SmartConsole GUI client
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp18190" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 18190
      max = 18190
    }
  }
}

//Allow security gateways to fetch policy
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp18191" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 18191
      max = 18191
    }
  }
}

//Allow security gateways to pull a SIC certificate
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp18210" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 18210
      max = 18210
    }
  }
}

//Allow gateways to fetch CRLs
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp18264" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 18264
      max = 18264
    }
  }

}

//Allow inbound access using SmartConsole GUI client
resource "oci_core_network_security_group_security_rule" "rule_ingress_tcp19009" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = 19009
      max = 19009
    }
  }
}


resource "oci_core_network_security_group_security_rule" "rule_ingress_all_icmp_type3_code4" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = 1
  direction                 = "INGRESS"
  source                    = var.nsg_whitelist_ip != "" ? var.nsg_whitelist_ip : "0.0.0.0/0"
  stateless                 = true

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_vcn_icmp_type3" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  protocol                  = 1
  direction                 = "INGRESS"
  source                    = var.vcn_cidr_block
  stateless                 = true

  icmp_options {
    type = 3
  }
}

