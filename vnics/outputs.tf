# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

output "id" {
  description = "ocid of created vnic."
  value       = oci_core_vnic_attachment.main.id
}