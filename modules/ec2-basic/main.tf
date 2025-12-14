resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  # Task 9: Use user_data script for reliable provisioning
  user_data = base64encode(file("${path.module}/user_data.sh"))

  tags = {
    Name        = var.instance_name
    Environment = "lab"
  }

  # Task 10: Lifecycle rule with prevent_destroy
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      tags["LastModified"]
    ]
  }

  depends_on = []
}
