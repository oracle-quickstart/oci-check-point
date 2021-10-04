#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

############################
#  Marketplace Image      #
############################

variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = true
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaahcc2ffdraf4if3eat2j5doivedtv7wwzpoa4tvhvjfdcozshmgeq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaagsapm5pdqheoqp3zwfktwtykvdzwlnx4k42ijc45kat3vg7hsfeq"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "R81_rev1.0"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "firewall-ha"
}

variable "vm_display_name_web" {
  description = "Instance Name"
  default     = "web-app"
}

variable "vm_display_name_db" {
  description = "Instance Name"
  default     = "db-app"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}

variable "spoke_vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 4
}

variable "spoke_vm_flex_shape_ocpus" {
  description = "Spoke VMs Flex Shape OCPUs"
  default     = 4
}
variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "ssh_public_key" {
  description = "SSH Public Key String"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "PARAVIRTUALIZED"
}

############################
#  Network Configuration   #
############################

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "north_hub_vcn_id" {
  default = ""
}

variable "north_hub_vcn_display_name" {
  description = "North Hub VCN Name"
  default     = "north-hub-vcn"
}

variable "north_hub_vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.1.0.0/16"
}

variable "north_hub_vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "north"
}

variable "south_hub_vcn_id" {
  default = ""
}

variable "south_hub_vcn_display_name" {
  description = "South Hub VCN Name"
  default     = "south-hub-vcn"
}

variable "south_hub_vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "192.168.0.0/16"
}

variable "south_hub_vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "south"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "north_hub_frontend_subnet_id" {
  default = ""
}

variable "north_hub_frontend_subnet_display_name" {
  description = "Frontend Subnet Name"
  default     = "frontend-subnet"
}

variable "north_hub_frontend_subnet_cidr_block" {
  description = "Frontend Subnet CIDR"
  default     = "10.1.1.0/24"
}

variable "north_hub_frontend_subnet_dns_label" {
  description = "Frontend Subnet DNS Label"
  default     = "frontend"
}

variable "north_hub_backend_subnet_id" {
  default = ""
}

variable "north_hub_backend_subnet_display_name" {
  description = "Backend Subnet Name"
  default     = "backend-subnet"
}

variable "north_hub_backend_subnet_cidr_block" {
  description = "Backend Subnet CIDR"
  default     = "10.1.2.0/24"
}

variable "north_hub_backend_subnet_dns_label" {
  description = "Backend Subnet DNS Label"
  default     = "backend"
}

variable "north_hub_nlb_subnet_id" {
  default = ""
}

variable "north_hub_nlb_subnet_display_name" {
  description = "NLB Subnet Name"
  default     = "nlb-subnet"
}

variable "north_hub_nlb_subnet_cidr_block" {
  description = "NLB Subnet CIDR"
  default     = "10.1.3.0/24"
}

variable "north_hub_nlb_subnet_dns_label" {
  description = "NLB Subnet DNS Label"
  default     = "nlb"
}

variable "south_hub_frontend_subnet_id" {
  default = ""
}

variable "south_hub_frontend_subnet_display_name" {
  description = "Frontend Subnet Name"
  default     = "frontend-subnet"
}

variable "south_hub_frontend_subnet_cidr_block" {
  description = "Frontend Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "south_hub_frontend_subnet_dns_label" {
  description = "Frontend Subnet DNS Label"
  default     = "frontend"
}

variable "south_hub_backend_subnet_id" {
  default = ""
}

variable "south_hub_backend_subnet_display_name" {
  description = "Backend Subnet Name"
  default     = "backend-subnet"
}

variable "south_hub_backend_subnet_cidr_block" {
  description = "Backend Subnet CIDR"
  default     = "192.168.2.0/24"
}

variable "south_hub_backend_subnet_dns_label" {
  description = "Backend Subnet DNS Label"
  default     = "backend"
}

variable "dynamic_group_description" {
  description = "Dynamic Group to Support check-point HA"
  default     = "Dynamic Group to Support check-point HA"
}

variable "dynamic_group_name" {
  description = "Dynamic Group Name"
  default     = "check-point-ha-dynamic-group"
}

variable "dynamic_group_policy_description" {
  description = "Dynamic Group Policy to allow check-point HA floating IP switch"
  default     = "Dynamic Group Policy for check-point HA"
}

variable "dynamic_group_policy_name" {
  description = "Dynamic Group Policy check-point"
  default     = "check-point-ha-dynamic-group-policy"
}

variable "web_vcn_id" {
  default = ""
}
variable "web_vcn_cidr_block" {
  description = "Web Spoke VCN CIDR Block"
  default     = "10.0.0.0/24"
}

variable "web_vcn_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "web"
}

variable "web_vcn_display_name" {
  description = "Web Spoke VCN Display Name"
  default     = "web-vcn"
}

variable "web_transit_subnet_id" {
  default = ""
}

variable "web_transit_subnet_cidr_block" {
  description = "Web Spoke VCN Private Subnet"
  default     = "10.0.0.0/25"
}

variable "web_transit_subnet_display_name" {
  description = "Web Spoke VCN Private Subnet Display Name"
  default     = "web_private-subnet"
}

variable "web_transit_subnet_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "webtransit"
}

variable "web_lb_subnet_id" {
  default = ""
}

variable "web_lb_subnet_cidr_block" {
  description = "Web Spoke VCN Loadbalancer Subnet"
  default     = "10.0.0.128/25"
}

variable "web_lb_subnet_display_name" {
  description = "Web Spoke VCN LB Subnet Display Name"
  default     = "web_lb-subnet"
}

variable "web_lb_subnet_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "weblb"
}

variable "backend_port" {
  description = "Web Load Balancer Backend Port"
  default     = 80
}

variable "db_vcn_id" {
  default = ""
}

variable "db_vcn_cidr_block" {
  description = "DB Spoke VCN CIDR Block"
  default     = "10.0.1.0/24"
}

variable "db_vcn_dns_label" {
  description = "DB Spoke VCN DNS Label"
  default     = "db"
}

variable "db_vcn_display_name" {
  description = "DB Spoke VCN Display Name"
  default     = "db-vcn"
}

variable "db_transit_subnet_id" {
  default = ""
}

variable "db_transit_subnet_cidr_block" {
  description = "DB Spoke VCN Private Subnet"
  default     = "10.0.1.0/24"
}

variable "db_transit_subnet_display_name" {
  description = "DB Spoke VCN Private Subnet Display Name"
  default     = "db_private-subnet"
}

variable "db_transit_subnet_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "dbtransit"
}

############################
# Additional Configuration #
############################

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "cluster-security-group"
}

variable "web_nsg_display_name" {
  description = "Network Security Groups - Web"
  default     = "web-security-group"
}

variable "db_nsg_display_name" {
  description = "Network Security Groups - App"
  default     = "db-security-group"
}


variable "public_routetable_display_name" {
  description = "Public route table Name"
  default     = "FrontendRouteTable"
}

variable "nlb_routetable_display_name" {
  description = "NLB route table Name"
  default     = "NLBRouteTable"
}

variable "private_routetable_display_name" {
  description = "Private route table Name"
  default     = "BackendRouteTable"
}

variable "drg_routetable_display_name" {
  description = "DRG route table Name"
  default     = "DRGRouteTable"
}

variable "sgw_routetable_display_name" {
  description = "SGW route table Name"
  default     = "SGWRouteTable"
}

variable "use_existing_ip" {
  description = "Use an existing permanent public ip"
  default     = "Create new IP"
}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default     = "ha"
}

variable "template_version" {
  description = "Template version"
  default     = "20200724"
}

######################
#    Enum Values     #   
######################
variable "network_strategy_enum" {
  type = map
  default = {
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}

variable "subnet_type_enum" {
  type = map
  default = {
    transit_subnet    = "Private Subnet"
    MANAGEMENT_SUBENT = "Public Subnet"
  }
}

variable "nsg_config_enum" {
  type = map
  default = {
    BLOCK_ALL_PORTS = "Block all ports"
    OPEN_ALL_PORTS  = "Open all ports"
    CUSTOMIZE       = "Customize ports - Post deployment"
  }
}


######################
# Cloud Init Values  #   
######################

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  default     = "true"
}

variable "shell" {
  description = "Change the admin shell to enable advanced command line configuration"
  default     = "/etc/cli.sh"
}

variable "sic_key" {
  description = "The Secure Internal Communication key creates trusted connections between Check Point components. Choose a random string consisting of at least 12 alphanumeric characters"
}