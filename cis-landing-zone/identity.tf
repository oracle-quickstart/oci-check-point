# ------ Create Dynamic Group to Support Check Point CloudGurard HA
resource "oci_identity_dynamic_group" "firewall_dynamic_group" {
  compartment_id = var.tenancy_ocid
  name           = var.dynamic_group_name
  description    = var.dynamic_group_description
  matching_rule  = "Any {instance.id = '${oci_core_instance.firewall-vms[0].id}', instance.id = '${oci_core_instance.firewall-vms[1].id}'}" 
}

# ------ Create Dynamic Group Policies to Support Check Point CloudGurard HA (fix this)
resource "oci_identity_policy" "pan_firewall_ha_policy" {
  compartment_id = var.network_compartment
  description    = var.dynamic_group_policy_description
  name           = var.dynamic_group_policy_name

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.firewall_dynamic_group.name} to manage all-resources in compartment ${data.oci_identity_compartment.network_compartment.name}",
  ]
}