output "firewallA_instance_public_ips" {
  value = [oci_core_instance.firewall-vms[0].*.public_ip]
}

output "firewallA_instance_private_ips" {
  value = [oci_core_instance.firewall-vms[0].*.private_ip]
}

output "firewallB_instance_public_ips" {
  value = [oci_core_instance.firewall-vms[1].*.public_ip]
}

output "firewallB_instance_private_ips" {
  value = [oci_core_instance.firewall-vms[1].*.private_ip]
}

output "instance_https_urls" {
  value = formatlist("https://%s", oci_core_instance.firewall-vms.*.public_ip)
}

output "initial_instruction" {
value = <<EOT
Configuring a Gateway in the Gaia Portal

1.  Open an SSH client.
2.  Use the following information to connect to the instance
username: admin
IP_Address: Public or Private IP address of the instance
SSH Key
For example:
$ ssh –i id_rsa admin@<IP Address>

3.  Set the user password for the administrator. Enter the command: set user admin password
4. Save the configuration. Enter the command: save config
After saving the password, you should run the first time wizard in the Gaia Portal:

1.  In a web browser, connect to the Gaia Portal: https://<IP_address>
2.  Follow the First Time Configuration Wizard.
3.  For additional details follow the documentation.

Configuring a Gateway in SmartConsole

After completing the "First Time Wizard (FTW)" you need to configure the Gateway in SmartConsole.
1.    Go to SmartConsole > Gateways & Servers view.
2.    Click the new icon > Gateway.
3.    The Check Point Security Gateway Creation window shows.
4.    Select youre preferred mode (Standard or Wizard).
5.    Enter the fields in the General Properties window.
6.    Click Next.
7.    Establish SIC.
8.    Click Finish.
9.    The Check Point Gateway General Properties window apprears.
10.  Complete the configuration of the gateway.

Notes:
1.    SSH password authentication is disabled
2.    For information regarding Firefox and Chrome refer to https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk121373
EOT
}