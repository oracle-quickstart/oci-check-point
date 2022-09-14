resource "oci_core_instance" "ha-vms" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]
  count      = 2

  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))


  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-${count.index + 1}"
  shape               = var.vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_flex_shape
      content {
        ocpus = shape_config.value
      }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.public_subnet_id : oci_core_subnet.public_subnet[0].id
    display_name           = var.vm_display_name
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }

  launch_options {
    network_type = length(local.is_flex_shape) > 0 ? var.instance_launch_options_network_type : "PARAVIRTUALIZED"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("scripts/cloud-init.sh",{
      allow_upload_download=var.allow_upload_download   
      template_name = var.template_name
      template_version = var.template_version
      sic_key = var.sic_key
      shell = var.shell
    }))
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
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
