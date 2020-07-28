output "subscription" {
  value = data.oci_core_app_catalog_subscriptions.mp_image_subscription.*.app_catalog_subscriptions
}

output "instance_public_ip" {
  value = oci_core_instance.simple-vm.public_ip
}

output "instance_private_ip" {
  value = oci_core_instance.simple-vm.private_ip
}

output "instance_https_url" {
  value = "https://${oci_core_instance.simple-vm.public_ip}"
}

output "initial_instruction" {
value = <<EOT

1.  Open an SSH client.
2.  Use the following information to connect to the instance
username: admin
IP_Address: ${oci_core_instance.simple-vm.public_ip}
SSH Key
For example:

$ ssh –i id_rsa admin@${oci_core_instance.simple-vm.public_ip}

3.  Set the user password for the administrator. Enter the command: set user admin password
4. Save the configuration. Enter the command: save config

After saving the password, you should run the first time wizard in the Gaia Portal:

1.  In a web browser, connect to the Gaia Portal: https://${oci_core_instance.simple-vm.public_ip}
2.  Follow the First Time Configuration Wizard.
3.  For additional details follow the documentation.
EOT
}