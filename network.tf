resource "oci_core_private_ip" "private_ip" {
  count = var.private_ip_count
  #Optional
  defined_tags  = var.defined_tags
  freeform_tags = local.merged_freeform_tags
  vnic_id       = data.oci_core_vnic_attachments.vnic_primary.vnic_attachments[0].vnic_id
  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}

module "additional_vnic" {
  source = "./vnics"
  count  = length(keys(var.add_vnic_subnet))

  network_cmp   = local.network_cmp_id
  defined_tags  = var.defined_tags
  freeform_tags = local.merged_freeform_tags
  subnet        = element(keys(var.add_vnic_subnet), count.index)
  display_name  = "${oci_core_instance.instance[0].display_name}_${count.index}"
  private_ips   = element(values(var.add_vnic_subnet), count.index)
  instance_id   = oci_core_instance.instance[0].id
}