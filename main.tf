provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

# variable "ec2_name" {
#   default = "terraformvolkan-ec2"
# }

# variable "ec2_type" {
#   default = "t2.micro"
# }

# variable "ec2_ami" {
#   default = "ami-0742b4e673072066f"
# }

# variable "s3_bucket_name" {
#   default = "terraform002zz-s3-bucket-variable-addwhateveryouwant"
# }

locals {
  mytag = "volkanesvo-local-name"
}


resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = "lessonkey"
  tags = {
    Name = "${local.mytag}-come from locals"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  # bucket = "${var.s3_bucket_name}-${count.index}"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
  for_each = toset(var.users)
  bucket   = "examplevolkan-tf-s3-bucket-${each.value}"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}

output "tf-example-public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

# output "tf-example-s3" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

