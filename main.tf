# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

############
# Instance
############
resource "oci_core_instance" "instance" {
  count = var.instance_count
  // If no explicit AD number, spread instances on all ADs in round-robin. Looping to the first when last AD is reached
  availability_domain  = var.ad_number == null ? element(local.ADs, 1) : element(local.ADs, var.ad_number - 1)
  compartment_id       = local.compute_cmp_id
  display_name         = var.instance_display_name == "" ? "" : var.instance_count != 1 ? "${var.instance_display_name}_${count.index + 1}" : var.instance_display_name
  extended_metadata    = var.extended_metadata
  ipxe_script          = var.ipxe_script
  preserve_boot_volume = var.preserve_boot_volume
  state                = var.instance_state
  shape                = var.shape
  fault_domain         = var.fault_domain
  shape_config {
    // If shape name contains ".Flex" and instance_flex inputs are not null, use instance_flex inputs values for shape_config block
    // Else use values from data.oci_core_shapes.current_ad for var.shape
    memory_in_gbs             = local.shape_is_flex == true && var.instance_flex_memory_in_gbs != null ? var.instance_flex_memory_in_gbs : local.shapes_config[var.shape]["memory_in_gbs"]
    ocpus                     = local.shape_is_flex == true && var.instance_flex_ocpus != null ? var.instance_flex_ocpus : local.shapes_config[var.shape]["ocpus"]
    baseline_ocpu_utilization = var.baseline_ocpu_utilization
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    dynamic "plugins_config" {
      for_each = var.cloud_agent_plugins
      content {
        desired_state = plugins_config.value
        name          = plugins_config.key
      }
    }
  }

  create_vnic_details {
    assign_public_ip = var.public_ip == "NONE" ? var.assign_public_ip : var.public_ip == "EPHEMERAL" ? true : false
    display_name     = var.vnic_name == "" ? var.instance_display_name : var.instance_count != "1" ? "${var.vnic_name}_${count.index + 1}" : var.vnic_name
    hostname_label   = var.hostname_label == "" ? "" : var.instance_count != "1" ? "${var.hostname_label}-${count.index + 1}" : var.hostname_label
    private_ip = element(
      concat(var.private_ips, [""]),
      length(var.private_ips) == 0 ? 0 : count.index,
    )
    skip_source_dest_check = var.skip_source_dest_check
    // Current implementation requires providing a list of subnets when using ad-specific subnets
    subnet_id = local.subnet_id #data.oci_core_subnet.instance_subnet[count.index % length(data.oci_core_subnet.instance_subnet.*.id)].id
    nsg_ids   = var.primary_vnic_nsg_ids

    freeform_tags = local.merged_freeform_tags
    defined_tags  = var.defined_tags
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_keys == null ? null : trimspace(var.ssh_public_keys)
    user_data           = var.user_data
  }

  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs

    #change, adds vpu per gb
    boot_volume_vpus_per_gb = var.vpus_per_gb_boot
    source_id               = var.source_ocid
    source_type             = var.source_type
  }

  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags

  timeouts {
    create = var.instance_timeout
    update = var.instance_timeout
    delete = var.instance_timeout
  }

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"]
    ]
  }
}

####################
# Networking
####################

resource "oci_core_public_ip" "public_ip" {
  count          = var.public_ip == "NONE" ? 0 : var.instance_count
  compartment_id = local.compute_cmp_id
  lifetime       = var.public_ip

  display_name  = var.public_ip_display_name != null ? var.public_ip_display_name : oci_core_instance.instance[count.index].display_name
  private_ip_id = data.oci_core_private_ips.private_ips[count.index].private_ips[0].id
  # public_ip_pool_id = oci_core_public_ip_pool.test_public_ip_pool.id # * (BYOIP CIDR Blocks) are not supported yet by this module.

  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags
}