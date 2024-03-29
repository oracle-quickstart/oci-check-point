# ------ Get Network Compartment Name for Policies
data "oci_identity_compartment" "network_compartment" {
    id = var.network_compartment_ocid
}


# ------ Get list of availability domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# ------ Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id = var.compute_compartment_ocid
  # operating_system         = var.instance_os
  # operating_system_version = var.linux_os_version
  shape = var.spoke_vm_compute_shape
  
  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# ------ Get the Oracle Tenancy ID
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = "${var.tenancy_ocid}"
}


# ------ Get Your Home Region
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

# ------ Get the Tenancy ID and AD Number
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

# ------ Get the Tenancy ID and ADs
data "oci_identity_availability_domains" "ads" {
  #Required
  compartment_id = var.tenancy_ocid
}

# ------ Get the Faulte Domain within AD 
data "oci_identity_fault_domains" "fds" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = var.compute_compartment_ocid

  depends_on = [
    data.oci_identity_availability_domain.ad,
  ]
}

# ------ Get the attachement based on Backend Subnet
data "oci_core_vnic_attachments" "backend_attachments" {
  compartment_id = var.network_compartment_ocid
  instance_id    = oci_core_instance.ha-vms.0.id

  filter {
    name   = "subnet_id"
    values = [local.use_existing_network ? var.backend_subnet_id : oci_core_subnet.backend_subnet[0].id]
  }

  depends_on = [
    oci_core_vnic_attachment.backend_vnic_attachment,
  ]
}


# ------ Get the attachement based on Frontend Subnet
data "oci_core_vnic_attachments" "master_attachments" {
  compartment_id = var.network_compartment_ocid
  instance_id    = oci_core_instance.ha-vms.0.id

  filter {
    name   = "subnet_id"
    values = [local.use_existing_network ? var.frontend_subnet_id : oci_core_subnet.frontend_subnet[0].id]
  }
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.hub.0.id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security,
  ]
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_web" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.web.0.id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security_web,
  ]
}

# ------ Get the Allow All Security Lists for Subnets in Firewall VCN
data "oci_core_security_lists" "allow_all_security_db" {
  compartment_id = var.compute_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.db.0.id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security_db,
  ]
}
