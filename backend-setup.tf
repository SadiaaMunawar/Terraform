# Task 7: Remote Backend Setup
# This file sets up the S3 bucket and DynamoDB table for remote state management
# Run this separately first, then configure the backend block in main terraform block

# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${data.aws_caller_identity.current.account_id}-${var.aws_region}"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "production"
  }
}

# Enable versioning on S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locks"
    Environment = "production"
  }
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# Outputs for backend configuration
output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "S3 bucket name for terraform state"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "DynamoDB table name for state locking"
}
