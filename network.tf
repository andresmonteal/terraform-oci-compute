# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

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
  count  = length(var.add_vnic_subnet)

  network_cmp   = local.network_cmp_id
  defined_tags  = var.defined_tags
  freeform_tags = local.merged_freeform_tags
  subnet        = keys(element(var.add_vnic_subnet, count.index))[0]
  display_name  = "${oci_core_instance.instance[0].display_name}-${format("%s%s", var.vnic_prefix, count.index + 1)}"
  private_ips   = values(element(var.add_vnic_subnet, count.index))[0]
  instance_id   = oci_core_instance.instance[0].id
}