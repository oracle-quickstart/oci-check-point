variable "compartment_ocid" {
}

variable "vcn_cidr_block" {
  default = ""
}

variable "vcn_dns_label" {
  default = "vcn"
}

variable "vcn_display_name" {
  default = "vcn"
}

variable "igw_display_name" {
  default = "internet-gateway"
}

variable "public_subnet_cidr_block" {
}

variable "public_subnet_display_name" {
  default = "public_subnet"
}

variable "subnet_dns_label" {
  default = "subnet"
}

variable "use_existing_network" {
  type    = bool
  default = false
}

variable "vcn_id" {
  default = ""
}

variable "public_subnet_id" {
  default = ""
}

variable "private_subnet_id" {
  default = ""
}

variable "private_subnet_cidr_block" {
  default = ""
}

variable "private_subnet_display_name" {
  default = ""
}