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
  default     = "ocid1.image.oc1..aaaaaaaafms4hyju5vjrloutauk4dgnln64xyxz5l33o6spduve2pdefnpdq"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "R81.10_with_JHF_45"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "cloudguard-ha"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 1
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
  description = "SSH Public Key"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "VFIO"
}

############################
#  Network Configuration   #
############################

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "cloudguard-ha-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "ha"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "public_subnet_id" {
  default = ""
}

variable "public_subnet_display_name" {
  description = "Public Subnet Name"
  default     = "public-subnet"
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "public_subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

variable "private_subnet_id" {
  default = ""
}

variable "private_subnet_display_name" {
  description = "Private Subnet Name"
  default     = "private-subnet"
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet CIDR"
  default     = "10.0.1.0/24"
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

variable "public_routetable_display_name" {
  description = "Public route table Name"
  default     = "public-route-table"
}

variable "private_routetable_display_name" {
  description = "Private route table Name"
  default     = "private-route-table"
}

variable "use_existing_ip" {
  description = "Use an existing permanent public ip"
  default     = "Create new IP"
}

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

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default = "ha"
}

variable "template_version" {
  description = "Template version"
  default = "20200104"
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
    PRIVATE_SUBNET = "Private Subnet"
    PUBLIC_SUBNET  = "Public Subnet"
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

