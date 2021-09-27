#!/bin/bash

ftw_password=$(curl_cli --silent http://169.254.169.254/opc/v1/instance/id)

echo "template_name: ${template_name}" >> /etc/cloud-version
echo "template_version: ${template_version}" >> /etc/cloud-version

clish -c "set user admin shell '${shell}'" -s

blink_conf="gateway_cluster_member=true"
blink_conf="$blink_conf&ftw_sic_key=${sic_key}"
blink_conf="$blink_conf&download_info=${allow_upload_download}"
blink_conf="$blink_conf&upload_info=${allow_upload_download}"
blink_conf="$blink_conf&admin_password_regular=$ftw_password"
blink_conf="$blink_conf&reboot_if_required=true"

blink_config -s "$blink_conf"
