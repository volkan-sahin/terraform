provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "tf-remote-state" {
    bucket = "tr-remote-s3-bucket-volkan-terraform003"

    force_destroy = true # Normally it must be false. Because if we delete s3 mistakenly, we lost all of the states.

}

resource "aws_s3_bucket_server_side_encryption_configuration" "mybackend" {
  bucket = aws_s3_bucket.tf-remote-state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}