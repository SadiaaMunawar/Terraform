variable "ami_id" {
  description = "AMI ID to launch the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "EC2-Instance"
}

variable "private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
  default     = "~/.ssh/my-keypair.pem"
}

variable "website_source_dir" {
  description = "Path to the website directory to deploy"
  type        = string
  default     = "./website"
}
