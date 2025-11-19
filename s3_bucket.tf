# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "terraform-state-2025-minecraftserver"
resource "aws_s3_bucket" "state_bucket" {
  bucket              = var.state_bucket_name
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all            = {}
}
