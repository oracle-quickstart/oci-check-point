output "subscription" {
  value = data.oci_core_app_catalog_subscriptions.mp_image_subscription.*.app_catalog_subscriptions
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

output "initial_instruction" {
value = <<EOT

1.  Open an SSH client.
2.  Use the following information to connect to the instance
username: admin
IP_Address: ${oci_core_instance.ha-vms.0.public_ip}
SSH Key
For example:

$ ssh –i id_rsa admin@${oci_core_instance.ha-vms.0.public_ip}

3.  Set the user password for the administrator. Enter the command: set user admin password
4. Save the configuration. Enter the command: save config

After saving the password, you should run the first time wizard in the Gaia Portal:

1.  In a web browser, connect to the Gaia Portal: https://${oci_core_instance.ha-vms.0.public_ip}
2.  Follow the First Time Configuration Wizard.
3.  For additional details follow the documentation.
EOT
}
