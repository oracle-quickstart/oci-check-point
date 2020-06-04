resource "oci_core_instance" "ha-vms" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]
  count      = 2

  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-${count.index + 1}"
  shape               = var.vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.public_subnet_id : oci_core_subnet.public_subnet[0].id
    display_name           = var.vm_display_name
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
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
      ftw_password=$(curl_cli --silent http://169.254.169.254/opc/v1/instance/id)
      clish -c 'set user admin shell ${var.shell}' -s
      clish -c 'set user admin password $ftw_password' -s
      conf="installSecurityGateway=true&gateway_cluster_member=true&installSecurityManagement=false"
      conf="$conf&download_info=${var.allow_upload_download}&upload_info=${var.allow_upload_download}"
      conf="$conf&mgmt_admin_radio=gaia_admin&ftw_sic_key=${var.sic_key}&reboot_if_required=true"
      /bin/blink_config -s "$conf"
      EOF
    )
  }
}

resource "oci_core_vnic_attachment" "private_vnic_attachment" {
  count = 2
  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.private_subnet_id : oci_core_subnet.private_subnet[0].id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "Secondary"
  }
  instance_id = oci_core_instance.ha-vms[count.index].id
  depends_on = [
    oci_core_instance.ha-vms,
  ]
}
