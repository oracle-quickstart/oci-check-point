resource "oci_core_instance" "simple-vm" {
  depends_on          = [oci_core_app_catalog_subscription.mp_image_subscription]
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.subnet_id : oci_core_subnet.public_subnet[0].id
    display_name     = var.vm_display_name
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.nsg.id]
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
      set user admin password $ftw_password
      EOF
    )
  }
}

