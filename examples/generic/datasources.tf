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