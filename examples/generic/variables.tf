
# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.

variable "tenancy_ocid" {
  description = "root compartment"
  default     = "tenancy-id"
}

# general oci parameters

variable "network_cmp" {
  description = "compartment ocid where vcn and subnet are located"
  type        = string
}

variable "security_cmp" {
  description = "compartment ocid where secrets are located"
  type        = string
}

variable "secret_name" {
  description = "The user-friendly name of the secret. Avoid entering confidential information."
  type        = string
}

# variable
variable "instances" {
  type = map(any)
}