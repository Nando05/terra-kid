terraform {
  required_version = "1.11.2"  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4"
    }
}
}
resource "aws_s3_bucket" "tarea" {
  
  bucket = "dev-ops-team-bucket-${random_string.aws_s3[count.index].id}"
  count  = 5
  tags = { "area" = "devOps"
    "pais"        = "de Las Maravillas"
  }
}

resource "random_string" "aws_s3" {
  count   = 5
  length  = 8
  special = true
  upper   = false
}
