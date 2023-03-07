data "oci_core_subnets" "subnets" {
  #Required
  compartment_id  = var.network_compartment_ocid

  #Optional
  display_name    = var.subnet_name
}