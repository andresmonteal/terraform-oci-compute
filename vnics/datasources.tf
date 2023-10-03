data "oci_core_subnets" "subnet" {
  #Required
  compartment_id = var.network_cmp

  #Optional
  display_name = var.subnet
}