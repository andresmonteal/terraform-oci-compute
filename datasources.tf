data "oci_core_subnets" "subnets" {
  #Required
  compartment_id = try(module.get_network_cmp[0].id, var.network_cmp_id)

  #Optional
  display_name = var.subnet_name
}

data "oci_core_subnets" "add_subnet" {
  #Required
  compartment_id = try(module.get_network_cmp[0].id, var.network_cmp_id)

  #Optional
  display_name = var.add_vnic_subnet
}

data "oci_core_vnic_attachments" "all_vnics" {
  #Required
  compartment_id = try(module.get_compute_cmp[0].id, var.compute_cmp_id)

  #Optional
  instance_id = oci_core_instance.instance[0].id
}

data "oci_core_vnic_attachments" "vnic_primary" {
  #Required
  compartment_id = try(module.get_compute_cmp[0].id, var.compute_cmp_id)

  #Optional
  instance_id = oci_core_instance.instance[0].id
  filter {
    name   = "time_created"
    values = [element(sort(data.oci_core_vnic_attachments.all_vnics.vnic_attachments[*].time_created), 0)]
  }
}