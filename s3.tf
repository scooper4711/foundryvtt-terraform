resource "aws_iam_role" "foundry_s3_access" {
  name = "foundry_s3_access"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets"
        }, 
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::vtt-assets",
                "arn:aws:s3:::vtt-assets/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "vtt-assets-inharnsway" {
  bucket = "my-tf-test-bucket"
  acl    = "public-read"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "HEAD"]
    allowed_origins = ["http://www.inharnsway.com"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}