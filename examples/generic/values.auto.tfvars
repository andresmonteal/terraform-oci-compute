tenancy_ocid = "tenant-id"

instances = {
  "cmp-ans-prd-sales-yum" = {
    shape                       = "VM.Standard3.Flex"
    secret_name                 = "test"
    compute_cmp                 = "cmp-app-np"
    network_cmp                 = "cmp-networking"
    ad_number                   = 1
    secret_name                 = "test"
    source_ocid                 = "ocid1.image.oc1.iad.aaaaaaaa4m3bxzwpfcrthy3x74rozkmsxpnru4zcmlmta3yehg3rptvui7jq"
    instance_flex_memory_in_gbs = 8
    instance_flex_ocpus         = 1
    subnet_name                 = "sn-app-np-pri"
    boot_volume_size_in_gbs     = 50
    defined_tags                = { "application.project" = "test", "application.environment" = "np" }
  }
}