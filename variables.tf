# Root module variables

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Key pair name for EC2 SSH access"
  type        = string
  default     = "my-keypair"
}

variable "private_key_path" {
  description = "Path to private key for SSH provisioning"
  type        = string
  default     = "~/.ssh/my-keypair.pem"
}

variable "s3_bucket_name" {
  description = "S3 bucket name (for Task 2-3)"
  type        = string
  default     = "sadia-lab1-bucket-230944"
}

variable "website_source_dir" {
  description = "Path to the website source directory to deploy"
  type        = string
  default     = "./website"
}
