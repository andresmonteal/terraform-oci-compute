module "instance_flex" {
  source = "git::ssh://devops.scmservice.us-ashburn-1.oci.oraclecloud.com/namespaces/id9de6bj2yv6/projects/claro-devops/repositories/terraform-oci-compute?ref=v0.2.0"

  for_each = var.instances

  # general oci parameters
  tenancy_ocid     = var.tenancy_ocid
  compute_cmp_list = each.value["compute_cmp"]
  freeform_tags    = lookup(each.value, "freeform_tags", null)
  defined_tags     = lookup(each.value, "defined_tags", null)

  # compute instance parameters
  ad_number                   = lookup(each.value, "ad_number", null)
  instance_count              = lookup(each.value, "instance_count", 1)
  instance_display_name       = each.key
  instance_state              = lookup(each.value, "instance_state", "RUNNING")
  shape                       = each.value["shape"]
  source_ocid                 = each.value["source_ocid"]
  source_type                 = lookup(each.value, "source_type", "image")
  instance_flex_memory_in_gbs = each.value["instance_flex_memory_in_gbs"] # only used if shape is Flex type
  instance_flex_ocpus         = each.value["instance_flex_ocpus"]         # only used if shape is Flex type
  baseline_ocpu_utilization   = lookup(each.value, "baseline_ocpu_utilization", "BASELINE_1_1")

  # operating system parameters
  ssh_public_keys = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)

  # networking parameters
  public_ip            = lookup(each.value, "public_ip", "NONE") # NONE, RESERVED or EPHEMERAL
  subnet_name          = each.value["subnet_name"]
  network_cmp_list     = each.value["network_cmp"]
  primary_vnic_nsg_ids = lookup(each.value, "primary_vnic_nsg_ids", null)
  private_ip_count     = lookup(each.value, "private_ip_count", 0)
  add_vnic_subnet      = lookup(each.value, "add_vnic_subnet", null)

  # storage parameters
  boot_volume_backup_policy  = lookup(each.value, "boot_volume_backup_policy", "disabled")
  boot_volume_size_in_gbs    = lookup(each.value, "boot_volume_size_in_gbs", null)
  block_storage_sizes_in_gbs = lookup(each.value, "block_storage_sizes_in_gbs", [])
  vpus_per_gb                = lookup(each.value, "vpus_per_gb", 10)
  vpus_per_gb_boot           = lookup(each.value, "vpus_per_gb_boot", 10)
  volume_bk_policy_cmp_list  = lookup(each.value, "vol_policy_cmp", ["BACKUPS"])
}