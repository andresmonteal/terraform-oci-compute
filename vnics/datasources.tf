# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

data "oci_core_subnets" "subnet" {
  #Required
  compartment_id = var.network_cmp

  #Optional
  display_name = var.subnet
}