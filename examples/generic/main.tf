module "instance_flex" {
  source = "../../"

  for_each = var.instances

  # general oci parameters
  tenancy_ocid  = var.tenancy_ocid
  compute_cmp   = each.value["compute_cmp"]
  freeform_tags = lookup(each.value, "freeform_tags", null)
  defined_tags  = lookup(each.value, "defined_tags", null)

  # compute instance parameters
  ad_number                   = lookup(each.value, "ad_number", null)
  instance_count              = lookup(each.value, "instance_count", 1)
  instance_display_name       = each.key
  instance_state              = lookup(each.value, "instance_state", "RUNNING")
  shape                       = each.value["shape"]
  source_ocid                 = module.images["junos-204R2"].id #each.value["source_ocid"]
  source_type                 = lookup(each.value, "source_type", "image")
  instance_flex_memory_in_gbs = each.value["instance_flex_memory_in_gbs"] # only used if shape is Flex type
  instance_flex_ocpus         = each.value["instance_flex_ocpus"]         # only used if shape is Flex type
  baseline_ocpu_utilization   = lookup(each.value, "baseline_ocpu_utilization", "BASELINE_1_1")

  # operating system parameters
  secret       = lookup(each.value, "secret", null)
  security_cmp = lookup(each.value, "security_cmp", null)

  # networking parameters
  public_ip            = lookup(each.value, "public_ip", "NONE") # NONE, RESERVED or EPHEMERAL
  subnet_name          = each.value["subnet_name"]
  network_cmp          = each.value["network_cmp"]
  primary_vnic_nsg_ids = lookup(each.value, "primary_vnic_nsg_ids", null)
  private_ip_count     = lookup(each.value, "private_ip_count", 0)
  add_vnic_subnet      = lookup(each.value, "add_vnic_subnet", null)
  private_ips          = lookup(each.value, "private_ip", null)

  # storage parameters
  boot_volume_backup_policy  = lookup(each.value, "boot_volume_backup_policy", "disabled")
  block_volume_backup_policy = lookup(each.value, "block_volume_backup_policy", "disabled")
  boot_volume_size_in_gbs    = lookup(each.value, "boot_volume_size_in_gbs", null)
  block_storage_sizes_in_gbs = lookup(each.value, "block_storage_sizes_in_gbs", [])
  vpus_per_gb                = lookup(each.value, "vpus_per_gb", 10)
  vpus_per_gb_boot           = lookup(each.value, "vpus_per_gb_boot", 10)
  volume_bk_policy_cmp       = lookup(each.value, "vol_policy_cmp", null)

  # cloud init
  user_data = each.value["cloud_init"] == null ? null : base64encode(file(each.value["cloud_init"]))
}