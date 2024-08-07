# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

#############
# Boot Volume
#############

# Assign a backup policy to instance's boot volume

resource "oci_core_volume_backup_policy_assignment" "boot_volume_backup_policy" {
  # * The boot volume backup policy is controlled by var.boot_volume_backup_policy.
  # * You can choose between OCI default backup policies : gold, silver, bronze.
  # * If you set the variable to "disabled", no backup policy will be applied to the boot volume.
  count     = var.boot_volume_backup_policy != "disabled" ? var.instance_count : 0
  asset_id  = oci_core_instance.instance.*.boot_volume_id[count.index]
  policy_id = local.backup_policies[var.boot_volume_backup_policy]
}

#########
# Volume
#########
resource "oci_core_volume" "volume" {
  count               = var.instance_count * length(var.block_storage_sizes_in_gbs)
  availability_domain = oci_core_instance.instance[count.index % var.instance_count].availability_domain
  compartment_id      = local.compute_cmp_id
  display_name        = "${oci_core_instance.instance[count.index % var.instance_count].display_name}_BV${floor(count.index / var.instance_count)}"

  # change, adds option to set vpu
  vpus_per_gb = coalesce(var.vpus_per_gb, 10)
  size_in_gbs = element(
    var.block_storage_sizes_in_gbs,
    floor(count.index / var.instance_count),
  )
  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags
}

####################
# Volume Attachment
####################
resource "oci_core_volume_attachment" "volume_attachment" {
  count           = var.instance_count * length(var.block_storage_sizes_in_gbs)
  attachment_type = var.attachment_type
  instance_id     = oci_core_instance.instance[count.index % var.instance_count].id
  volume_id       = oci_core_volume.volume[count.index].id
  use_chap        = var.use_chap
}

#############
# Block Volume backup policy
#############

# Assign a backup policy to instance's boot volume

resource "oci_core_volume_backup_policy_assignment" "block_volume_backup_policy" {
  count     = var.block_volume_backup_policy == "disabled" ? 0 : length(var.block_storage_sizes_in_gbs)
  asset_id  = oci_core_volume.volume[count.index].id
  policy_id = local.backup_policies[var.block_volume_backup_policy]
}