# terraform-oci-compute
terraform module to create and manage compute instances
Terraform Module: [Module Name]
This Terraform module creates a compute instance in Oracle Cloud Infrastructure (OCI) along with block storage devices, virtual network interface cards (VNICS), and other associated resources.

Features
Creates a compute instance with configurable options
Attaches block storage devices
Configures virtual network interface cards (VNICs) with public/private IPs and security groups
Supports user data and SSH keys for instance customization
Outputs details about the created resources
Usage
Copy the module: Copy the module directory to your Terraform project.
Reference the module: In your main Terraform configuration file (main.tf), reference the module using the following syntax:
Terraform
module "compute_instance" {
  source  = "./path/to/module"
  # Configure module variables...
}
Use code with caution.
content_copy
Set variables: Define the variables for the module in your main Terraform configuration. Refer to the "Variables" section below for a detailed list of available variables.

Run Terraform: Run terraform init and terraform apply to provision the resources.

Variables
The module accepts various variables to customize the creation of the compute instance and associated resources.

Required Variables:

tenancy_ocid: (Updatable) The OCID of the root compartment.
instance_count: Number of identical instances to launch from a single module.
Optional Variables:

Compartment Names/IDs: You can specify compartment names or IDs for various resources like compute, networking, volume backups, and security.
Secret: Secret name to be used as a key for the compute resource.
Instance Timeout: Timeout setting for creating the instance.
Freeform Tags/Defined Tags: Tags to be applied to the created resources.
Instance Parameters:
instance_display_name: A user-friendly name for the instance.
instance_flex_memory_in_gbs: The total amount of memory available to the instance in gigabytes (for flexible shapes).
instance_flex_ocpus: The total number of OCPUs available to the instance (for flexible shapes).
instance_state: The target state for the instance (RUNNING or STOPPED).
shape: The shape of the instance (VM standard shapes supported).
cloud_agent_plugins: Whether each Oracle Cloud Agent plugin should be ENABLED or DISABLED.
baseline_ocpu_utilization: The baseline OCPU utilization for a subcore burstable VM instance.
source_ocid: The OCID of an image or a boot volume to use.
source_type: The source type for the instance (image or boot volume).
Operating System Parameters:
extended_metadata: Additional metadata key/value pairs for the instance.
resource_platform: Platform to create resources in (defaults to linux).
ssh_public_keys: Public SSH keys to be included in the authorized_keys file.
user_data: Base64-encoded data for Cloud-Init to run custom scripts.
Networking Parameters:
assign_public_ip (deprecated, use public_ip): Whether to assign a public IP address to the primary VNIC.
hostname_label: The hostname for the VNIC's primary private IP.
ipxe_script: Optional iPXE script for the boot process.
private_ips: List of private IP addresses to assign to the VNICS.
public_ip: Whether to create a public IP for the primary VNIC (NONE, RESERVED, or EPHEMERAL).
public_ip_display_name: A user-friendly name for the public IP.
skip_source_dest_check: Whether to disable the source/destination check on the VNIC.
subnet_ocids: List of OCIDs for the subnets where the primary VNICS are created.
vnic_name: A user-friendly name for the VNIC.
primary_vnic_nsg_ids: List of OCIDs for the network security groups (NSGs) to add the primary VNIC to.
vnic_prefix: Optional prefix for additional VNICS created by the module.
Storage Parameters:
attachment_type: The type of volume (iscsi or paravirtualized).
`block_storage
