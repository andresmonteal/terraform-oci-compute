resource "oci_core_vnic_attachment" "main" {
  #Required
  create_vnic_details {
    #Optional
    assign_public_ip = false
    defined_tags     = var.defined_tags
    freeform_tags    = var.freeform_tags
    subnet_id        = data.oci_core_subnets.subnet.subnets[0].id
    display_name     = var.display_name
    private_ip       = var.private_ips[0]
  }
  instance_id = var.instance_id
}

resource "oci_core_private_ip" "main" {
  count = length(var.private_ips) - 1
  #Optional
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
  vnic_id       = oci_core_vnic_attachment.main.vnic_id
  ip_address    = var.private_ips[count.index + 1]
  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}