locals {
  default_freeform_tags = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-oci-compute"
  }
  merged_freeform_tags    = merge(var.freeform_tags, local.default_freeform_tags)
  compute_cmp_id          = try(data.oci_identity_compartments.compute[0].compartments[0].id, var.compute_cmp_id)
  network_cmp_id          = try(data.oci_identity_compartments.network[0].compartments[0].id, var.network_cmp_id)
  volume_bk_policy_cmp_id = try(data.oci_identity_compartments.volume_backup_policy[0].compartments[0].id, var.volume_bk_policy_cmp_id)
  security_cmp_id         = try(data.oci_identity_compartments.security[0].compartments[0].id, var.security_cmp_id)
  ADs = [
    // Iterate through data.oci_identity_availability_domains.ad and create a list containing AD names
    for i in data.oci_identity_availability_domains.ad.availability_domains : i.name
  ]
  backup_policies = {
    // Iterate through data.oci_core_volume_backup_policies.default_backup_policies and create a map containing name & ocid
    // This is used to specify a backup policy id by name
    for i in data.oci_core_volume_backup_policies.default_backup_policies.volume_backup_policies : i.display_name => i.id
  }
  vcn_id    = data.oci_core_subnets.subnets.subnets[0].vcn_id
  subnet_id = data.oci_core_subnets.subnets.subnets[0].id
  shapes_config = {
    // prepare data with default values for flex shapes. Used to populate shape_config block with default values
    // Iterate through data.oci_core_shapes.current_ad.shapes (this exclude duplicate data in multi-ad regions) and create a map { name = { memory_in_gbs = "xx"; ocpus = "xx" } }
    for i in data.oci_core_shapes.current_ad.shapes : i.name => {
      "memory_in_gbs" = i.memory_in_gbs
      "ocpus"         = i.ocpus
    }
  }
  shape_is_flex = length(regexall("^*.Flex", var.shape)) > 0 # evaluates to boolean true when var.shape contains .Flex
}