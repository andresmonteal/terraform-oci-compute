# Oracle Compute Instance Terraform Module

## Overview

This module provisions and manages Oracle Cloud Infrastructure (OCI) compute instances using Terraform. It is designed to be flexible and configurable, allowing users to customize instance settings, networking options, storage configurations, and more.

## Features

- Create and manage OCI compute instances
- Configure instance metadata, shape, and state
- Manage networking settings including VNICs, public/private IPs, and subnets
- Configure storage options including boot volumes and block storage
- Tagging support with freeform and defined tags
- Fault domain and availability domain configuration
- Support for Oracle Cloud Agent plugins

## Prerequisites

- OCI account with the necessary permissions
- Terraform installed

## Usage

### Example

```hcl
module "oci_compute_instance" {
  source = "./path/to/module"

  tenancy_ocid          = "ocid1.tenancy.oc1..example"
  compute_cmp           = "ComputeCompartmentName"
  network_cmp           = "NetworkCompartmentName"
  security_cmp          = "SecurityCompartmentName"
  volume_bk_policy_cmp  = "VolumeBackupPolicyCompartmentName"

  instance_count        = 2
  instance_display_name = "MyInstance"
  shape                 = "VM.Standard2.1"
  source_ocid           = "ocid1.image.oc1..example"

  ssh_public_keys       = file("~/.ssh/id_rsa.pub")
  user_data             = file("path/to/cloud-init-script.sh")

  freeform_tags = {
    Project = "MyProject"
  }

  defined_tags = {
    "Oracle-Tags.CostCenter" = "12345"
  }
}
```

## Inputs

### General OCI Parameters

- `tenancy_ocid` (string, required): The OCID of the root compartment.
- `compute_cmp` (string, optional): Compartment name for compute resource. Default is `null`.
- `network_cmp` (string, optional): Compartment name for networking resources. Default is `null`.
- `security_cmp` (string, optional): Compartment name for security resources. Default is `null`.
- `volume_bk_policy_cmp` (string, optional): Compartment name for volume backup policy resource. Default is `null`.

### Compute Instance Parameters

- `instance_count` (number, optional): Number of identical instances to launch. Default is `1`.
- `ad_number` (number, optional): The availability domain number. If none is provided, instances will be distributed across ADs. Default is `null`.
- `instance_display_name` (string, optional): A user-friendly name for the instance. Default is `""`.
- `shape` (string, optional): The shape of the instance. Default is `"VM.Standard2.1"`.
- `source_ocid` (string, required): The OCID of an image or a boot volume to use.
- `instance_state` (string, optional): The target state for the instance (`RUNNING` or `STOPPED`). Default is `RUNNING`.

### Networking Parameters

- `public_ip` (string, optional): Whether to create a public IP and its lifetime (`NONE`, `RESERVED`, `EPHEMERAL`). Default is `NONE`.
- `private_ips` (list(string), optional): Private IP addresses to assign to the VNICs. Default is `[]`.
- `subnet_ocids` (list(string), optional): OCIDs of the subnets in which the instance primary VNICs are created. Default is `null`.
- `vnic_name` (string, optional): A user-friendly name for the VNIC. Default is `""`.

### Storage Parameters

- `boot_volume_size_in_gbs` (number, optional): The size of the boot volume in GBs. Default is `null`.
- `block_storage_sizes_in_gbs` (list(number), optional): Sizes of volumes to create and attach to each instance. Default is `[]`.
- `vpus_per_gb` (number, optional): The number of volume performance units per GB. Default is `10`.

### Tagging Parameters

- `freeform_tags` (map(string), optional): Simple key-value pairs to tag the resources. Default is `null`.
- `defined_tags` (map(string), optional): Predefined and scoped to a namespace to tag the resources. Default is `null`.

### Other Parameters

- `ssh_public_keys` (string, optional): Public SSH keys to include in the `~/.ssh/authorized_keys` file. Default is `""`.
- `user_data` (string, optional): Base64-encoded data for Cloud-Init to run custom scripts or provide custom Cloud-Init configuration. Default is `null`.

## Outputs

- `instances_summary`: Private and public IPs for each instance.
- `instance_id`: OCIDs of created instances.
- `private_ip`: Private IPs of created instances.
- `public_ip`: Public IPs of created instances.
- `instance_username`: Usernames to login to Windows instances.
- `instance_password`: Passwords to login to Windows instances (sensitive).
- `instance_all_attributes`: All attributes of created instances.
- `public_ip_all_attributes`: All attributes of created public IPs.
- `private_ips_all_attributes`: All attributes of created private IPs.
- `vnic_attachment_all_attributes`: All attributes of created VNIC attachments.
- `volume_all_attributes`: All attributes of created volumes.
- `volume_attachment_all_attributes`: All attributes of created volume attachments.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

**Andres F. Montealegre**

- Email: [montealegre.af@gmail.com](mailto:montealegre.af@gmail.com)
- GitHub: [https://github.com/andresmonteal](https://github.com/andresmonteal)