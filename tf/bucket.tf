# Bucket to save Firehose files for Dynamodb changes

resource "random_string" "random" {
  length           = 5
  special          = false
  upper = false
}

resource "aws_s3_bucket" "this" {

  bucket = "simple-${var.env}-res-${random_string.random.result}"
  # acl = "private"
  force_destroy = false

}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
   id = "lifecycle_1"
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
    status = "Enabled"
  }  
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


