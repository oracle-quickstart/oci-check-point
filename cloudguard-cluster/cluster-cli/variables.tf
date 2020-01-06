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

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaahcc2ffdraf4if3eat2j5doivedtv7wwzpoa4tvhvjfdcozshmgeq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaads23bte7abqb6cfrqmyq73zd7wpxchwwdteqk7mmqmbcv7pinv7a"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "R80.30"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "simple"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
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
  default     = "simple-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "simple"
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

variable "subnet_dns_label" {
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

variable "compartment_ocid" {
  description = "Compartment where infrastructure resources will be created"
}

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "simple-security-group"
}

variable "routetable_display_name" {
  description = "Route table Name"
  default     = "simple-route-table"
}

variable "use_existing_ip" {
  description = "Use an existing permanent public ip"
  default     = "Create new IP"
}
