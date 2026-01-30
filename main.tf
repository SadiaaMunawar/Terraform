terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Task 7: Remote backend configuration
  # Uncomment and update after creating S3 bucket and DynamoDB table
  # backend "s3" {
  #   bucket         = "terraform-state-ACCOUNT_ID-us-east-1"
  #   key            = "lab-basic/${terraform.workspace}/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# Data source to get latest Amazon Linux 2 AMI
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Module instance 1 - Web Server
module "web_server" {
  source              = "./modules/ec2-basic"
  ami_id              = data.aws_ami.latest.id
  instance_type       = "t3.micro"
  subnet_id           = null  # Set to your subnet if needed
  key_name            = var.key_name
  instance_name       = "WebServer-${terraform.workspace}"
  private_key_path    = var.private_key_path
  website_source_dir  = var.website_source_dir
}

# Module instance 2 - DB Server
module "db_server" {
  source              = "./modules/ec2-basic"
  ami_id              = data.aws_ami.latest.id
  instance_type       = "t3.micro"
  subnet_id           = null  # Set to your subnet if needed
  key_name            = var.key_name
  instance_name       = "DBServer-${terraform.workspace}"
  private_key_path    = var.private_key_path
  website_source_dir  = var.website_source_dir
}
