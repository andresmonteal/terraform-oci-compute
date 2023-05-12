secret_name  = "SECRET"
security_cmp = "SECURITY"

# Below is a proposed generic notation to be used for naming Compartments:
# [Compartment code]-[entity/sub-entity]-[environment]-[function/department]-[project]-[custom]

instances = {
  "cmp-ans-prd-sales-yum" = {
    shape                       = "VM.Standard3.Flex"
    compute_cmp                 = ["LVL1", "LVL2", "LVL3"]
    network_cmp                 = ["LVL1"]
    ad_number                   = 1
    source_ocid                 = "ocid1.image.oc1.iad.aaaaaaaa4m3bxzwpfcrthy3x74rozkmsxpnru4zcmlmta3yehg3rptvui7jq"
    instance_flex_memory_in_gbs = 8
    instance_flex_ocpus         = 1
    subnet_name                 = "ASH-ANSIBLE-PRD-SUBPRI01"
    add_vnic_subnet             = null
    boot_volume_backup_policy   = "CUSTOM-BACKUP"
    boot_volume_size_in_gbs     = 47
    block_storage_sizes_in_gbs  = ["1024"]
    defined_tags                = {}
  },
  "cmp-ans-prd-sales-has" = {
    shape                       = "VM.Standard3.Flex"
    compute_cmp                 = ["LVL1"]
    network_cmp                 = ["LVL1", "LVL2", "LVL3"]
    ad_number                   = 1
    source_ocid                 = "ocid1.image.oc1.iad.aaaaaaaa4m3bxzwpfcrthy3x74rozkmsxpnru4zcmlmta3yehg3rptvui7jq"
    instance_flex_memory_in_gbs = 8
    instance_flex_ocpus         = 1
    subnet_name                 = "ASH-ANSIBLE-PRD-SUBPRI01"
    add_vnic_subnet             = null
    boot_volume_backup_policy   = "CUSTOM-BACKUP"
    boot_volume_size_in_gbs     = 47
    block_storage_sizes_in_gbs  = []
    defined_tags                = { "NAMESPACE.TAG" = "VALUE", "NAMESPACE.TAG" = "VALUE-2" }
  }
}