terraform {
  backend "s3" {
    bucket                      = "bucket-name"
    region                      = "us-ashburn-1"
    endpoint                    = "https://test-test-test.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    shared_credentials_file     = "path to keys"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
