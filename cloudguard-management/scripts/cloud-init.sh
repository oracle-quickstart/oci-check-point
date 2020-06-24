#!/bin/bash

echo "template_name: ${template_name}" >> /etc/cloud-version
echo "template_version: ${template_version}" >> /etc/cloud-version

clish -c "set user admin shell '${shell}'" -s

blink_conf="gateway_cluster_member=false"
blink_conf="$blink_conf&download_info=${allow_upload_download}"
blink_conf="$blink_conf&upload_info=${allow_upload_download}"
blink_conf="$blink_conf&mgmt_admin_radio=gaia_admin"

blink_config -s "$blink_conf"
