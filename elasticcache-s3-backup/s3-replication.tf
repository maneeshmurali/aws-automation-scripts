provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "wh-elasticcache-backup-new"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.destination
  bucket   = "wh-elasticcache-backup-ohio-new"
  acl      = "private"

  versioning {
    enabled = true
  }
}

provider "aws" {
  alias  = "destination"
  region = "us-east-2"
}

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.source_bucket.arn]
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.source_bucket.arn}/*"
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.destination_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  policy_arn = aws_iam_policy.replication_policy.arn
  role       = aws_iam_role.replication_role.name
}

resource "aws_s3_bucket_replication_configuration" "replication_configuration" {
  bucket = aws_s3_bucket.source_bucket.id
  
  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket       = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"
    }
  }

  role = aws_iam_role.replication_role.arn

  depends_on = [aws_iam_role_policy_attachment.replication_policy_attachment]
}
