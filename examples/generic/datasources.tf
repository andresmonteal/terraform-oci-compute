data "oci_identity_compartments" "compute_cmp_parent_1" {
  for_each = var.instances
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  name = each.value["compute_cmp"][0]
}

data "oci_identity_compartments" "compute_cmp_parent" {
  for_each = var.instances
  #Required
  compartment_id = data.oci_identity_compartments.compute_cmp_parent_1[each.key].compartments[0].id

  #Optional
  name = each.value["compute_cmp"][1]
}

data "oci_identity_compartments" "compute_cmp" {
  for_each = var.instances
  #Required
  compartment_id = data.oci_identity_compartments.compute_cmp_parent[each.key].compartments[0].id

  #Optional
  name = each.value["compute_cmp"][2]
}

data "oci_identity_compartments" "network_cmp" {
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  name = var.network_cmp
}

data "oci_identity_compartments" "security_cmp" {
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  name = var.security_cmp
}

#This data source provides the list of Secrets in Oracle Cloud Infrastructure Vault service.
data "oci_vault_secrets" "secret" {
  #Required
  compartment_id = data.oci_identity_compartments.security_cmp.compartments[0].id

  #Optional
  name = var.secret_name
}

#This data source provides details about a specific Secretbundle resource in Oracle Cloud Infrastructure Secrets service.
data "oci_secrets_secretbundle" "bundle" {
  secret_id = data.oci_vault_secrets.secret.secrets[0].id
}