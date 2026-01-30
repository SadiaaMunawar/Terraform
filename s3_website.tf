# S3 static website hosting
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  force_destroy = true

  tags = {
    Name        = "Static Website Bucket"
    Environment = "lab"
  }
}

resource "aws_s3_bucket_public_access_block" "website_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public_bucket" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.public_bucket.json
}

# Upload website files to S3
# Creates objects for each file in website/ directory
locals {
  files = fileset("${path.root}/website", "**/*")
}

resource "aws_s3_object" "website_files" {
  for_each = { for f in local.files : f => f }

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.key
  source = "${path.root}/website/${each.key}"
  etag   = filemd5("${path.root}/website/${each.key}")
  # ACLs disabled because ObjectOwnership may be set to BucketOwnerEnforced
  # and AWS will reject ACLs. Public access is granted via the bucket policy above.
  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "application/javascript"
    },
    (split(".", each.key)[length(split(".", each.key)) - 1]),
    "binary/octet-stream"
  )
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}

output "website_url" {
  value = "http://${aws_s3_bucket.website_bucket.website_endpoint}"
}
