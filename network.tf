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

resource "oci_core_vnic_attachment" "additional_vnic" {
  count = var.add_vnic_subnet == null ? 0 : 1
  #Required
  create_vnic_details {
    #Optional
    assign_public_ip = false
    defined_tags     = var.defined_tags
    freeform_tags    = local.merged_freeform_tags
    subnet_id        = data.oci_core_subnets.add_subnet[0].subnets[0].id
    display_name     = "${oci_core_instance.instance[0].display_name}_0"
  }
  instance_id = oci_core_instance.instance[0].id
}