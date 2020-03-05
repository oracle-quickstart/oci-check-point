## Subscribe to Marketplace listing
module "marketplace_subscription" {
  source         = "./terraform-modules/marketplace-subscription"
  compartment_id = var.compartment_ocid
  //listing id
  mp_listing_id = var.mp_listing_id
  //listing resource version (app version)
  mp_listing_resource_version = var.mp_listing_resource_version
  //image ocid
  mp_listing_resource_id = var.mp_listing_resource_id
}

## Creates a VCN with a public and private subnet and default IGW and Route Table
module "vcn_plus_two_subnet" {
  source                      = "./terraform-modules/vcn-plus-two-subnets"
  compartment_ocid            = var.compartment_ocid
  vcn_display_name            = var.vcn_display_name
  vcn_cidr_block              = var.vcn_cidr_block
  vcn_dns_label               = var.vcn_dns_label
  public_subnet_display_name  = var.public_subnet_display_name
  public_subnet_cidr_block    = var.public_subnet_cidr_block
  subnet_dns_label            = var.public_subnet_dns_label
  private_subnet_display_name = var.private_subnet_display_name
  private_subnet_cidr_block   = var.private_subnet_cidr_block
}

## Allow Ingress HTTPS from 
module "default_network_sec_group" {
  source           = "./terraform-modules/network-security-groups"
  compartment_ocid = var.compartment_ocid
  nsg_display_name = var.nsg_display_name
  nsg_whitelist_ip = var.nsg_whitelist_ip
  vcn_id           = module.vcn_plus_two_subnet.vcn_id
  vcn_cidr_block   = var.vcn_cidr_block
}

resource "oci_core_instance" "ha-vms" {
  depends_on = [module.marketplace_subscription]
  count      = 2

  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)
  compartment_id      = var.compartment_ocid
  display_name        = "${var.vm_display_name}-${count.index + 1}"
  shape               = var.vm_compute_shape
  fault_domain = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  create_vnic_details {
    subnet_id              = module.vcn_plus_two_subnet.public_subnet_id
    display_name           = "Primary"
    assign_public_ip       = true
    nsg_ids                = [module.default_network_sec_group.nsg_id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type = "image"
    source_id   = var.mp_listing_resource_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(<<-EOF
      #!/bin/bash
      clish -c 'set user admin shell ${var.shell}' -s
      ftw_sic=$(curl_cli --silent http://169.254.169.254/opc/v1/instance/id)
      /bin/blink_config -s "gateway_cluster_member=true&download_info=${var.enable_download_info}&upload_info=${var.enable_upload_info}&mgmt_admin_radio=gaia_admin&ftw_sic_key=$ftw_sic&reboot_if_required=true"
      EOF
    )
  }
}

resource "oci_core_vnic_attachment" "private_vnic_attachment" {
  count = 2
  create_vnic_details {
    subnet_id              = module.vcn_plus_two_subnet.private_subnet_id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    display_name           = "Secondary"
  }
  instance_id = oci_core_instance.ha-vms[count.index].id
  depends_on = [
    oci_core_instance.ha-vms,
  ]
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
