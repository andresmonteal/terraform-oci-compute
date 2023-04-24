network_cmp = "network-cmp"

security_cmp = "security-cmp"

secret_name = "ssh-key-pub"

instances = {
  "INSTANCE-NAME" = {
    shape                       = "VM.Standard.E4.Flex"
    compute_cmp                 = ["LEVEL1", "LEVEL2", "LEVEL3"]
    ad_number                   = 1
    source_ocid                 = "ocid1.image.oc1.iad.aaaaaaaayrldglwozuedpvfllelnmthkcbd5irmjyeih56a4tslst2rne6jq"
    instance_flex_memory_in_gbs = "48"
    instance_flex_ocpus         = "4"
    subnet_name                 = "SUBNET-NAME"
    add_vnic_subnet             = "ADDITIONAL-VNIC-SUBNET-NAME"
    boot_volume_backup_policy   = "BACKUP-POLICIES"
    boot_volume_size_in_gbs     = "50"
    block_storage_sizes_in_gbs  = ["200", "100"]
    defined_tags                = { "NAMESPACE.TAG" = "VALUE", "NAMESPACE.TAG" = "VALUE-2" }
  }
}