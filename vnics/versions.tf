# Copyright (c) 2024 Andres Montealegre, Email: montealegre.af@gmail.com
# This project is licensed under the MIT License. See the [LICENSE] file for details.

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.67.3"
    }
  }
  required_version = ">= 1.0.0"
}