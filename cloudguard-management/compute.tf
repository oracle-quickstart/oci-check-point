resource "oci_core_instance" "simple-vm" {
  depends_on          = [oci_core_app_catalog_subscription.mp_image_subscription]
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  dynamic "shape_config" {
    for_each = local.is_flex_shape
      content {
        ocpus = shape_config.value
      }
  }

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.subnet_id : oci_core_subnet.public_subnet[0].id
    display_name     = var.vm_display_name
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("scripts/cloud-init.sh",{
      allow_upload_download=var.allow_upload_download   
      template_name = var.template_name
      template_version = var.template_version
      shell = var.shell
    }))
  }
}

