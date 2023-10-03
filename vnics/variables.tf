# Copyright (c) 2018, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general oci parameters

variable "network_cmp" {
  description = "Compartment name for networking resources"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Virtual cloud network subnet name"
  default     = ""
  type        = string
}

variable "display_name" {
  description = "(Optional) A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information."
  type        = string
  default     = ""
}

variable "private_ips" {
  description = "Private IP addresses of your choice to assign to the VNICs."
  type        = list(string)
  default     = []
}

variable "instance_id" {
  description = "(Required) The OCID of the instance."
  default     = ""
}

# optionals

variable "freeform_tags" {
  description = "simple key-value pairs to tag the resources created using freeform tags."
  type        = map(string)
  default     = null
}

variable "defined_tags" {
  description = "predefined and scoped to a namespace to tag the resources created using defined tags."
  type        = map(string)
  default     = null
}