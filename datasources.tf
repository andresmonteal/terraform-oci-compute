data "oci_identity_compartments" "compute" {
  count = var.tenancy_ocid == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.compute_cmp]
  }
}

data "oci_identity_compartments" "network" {
  count = var.network_cmp == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.network_cmp]
  }
}

data "oci_identity_compartments" "boot_volume_backup_policy" {
  count = var.volume_bk_policy_cmp == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.volume_bk_policy_cmp]
  }
}

data "oci_identity_compartments" "security" {
  count = var.security_cmp == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.security_cmp]
  }
}

data "oci_core_subnets" "subnets" {
  #Required
  compartment_id = local.network_cmp_id

  #Optional
  display_name = var.subnet_name
}

data "oci_core_subnets" "add_subnet" {
  count = var.add_vnic_subnet == null ? 0 : 1
  #Required
  compartment_id = local.network_cmp_id

  #Optional
  display_name = var.add_vnic_subnet
}

data "oci_core_vnic_attachments" "all_vnics" {
  #Required
  compartment_id = local.compute_cmp_id

  #Optional
  instance_id = oci_core_instance.instance[0].id
}

data "oci_core_vnic_attachments" "vnic_primary" {
  #Required
  compartment_id = local.compute_cmp_id

  #Optional
  instance_id = oci_core_instance.instance[0].id
  filter {
    name   = "time_created"
    values = [element(sort(data.oci_core_vnic_attachments.all_vnics.vnic_attachments[*].time_created), 0)]
  }
}

// Get all the Availability Domains for the region and default backup policies
data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_volume_backup_policies" "default_backup_policies" {
  compartment_id = local.volume_bk_policy_cmp_id
}

data "oci_core_shapes" "current_ad" {
  compartment_id      = local.compute_cmp_id
  availability_domain = var.ad_number == null ? element(local.ADs, 0) : element(local.ADs, var.ad_number - 1)
}


##################################
# Instance Credentials Datasource
##################################
data "oci_core_instance_credentials" "credential" {
  count       = var.resource_platform != "linux" ? var.instance_count : 0
  instance_id = oci_core_instance.instance[count.index].id
}



data "oci_core_vnic_attachments" "vnic_attachment" {
  count          = var.instance_count
  compartment_id = local.compute_cmp_id
  instance_id    = oci_core_instance.instance[count.index].id

  depends_on = [
    oci_core_instance.instance
  ]
}

data "oci_core_private_ips" "private_ips" {
  count   = var.instance_count
  vnic_id = data.oci_core_vnic_attachments.vnic_attachment[count.index].vnic_attachments[0].vnic_id

  depends_on = [
    oci_core_instance.instance
  ]
}


#This data source provides the list of Secrets in Oracle Cloud Infrastructure Vault service.
data "oci_vault_secrets" "secret" {
  count = var.secret == null ? 0 : 1
  #Required
  compartment_id = local.security_cmp_id

  #Optional
  name = var.secret
}

#This data source provides details about a specific Secretbundle resource in Oracle Cloud Infrastructure Secrets service.
data "oci_secrets_secretbundle" "bundle" {
  count     = var.secret == null ? 0 : 1
  secret_id = data.oci_vault_secrets.secret[0].secrets[0].id
}