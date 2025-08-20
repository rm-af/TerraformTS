resource "aws_s3_bucket" "ml_models" {
  bucket = "my-sagemaker-models-${random_id.suffix.hex}"
  acl    = "private"

  tags = {
    Name = "SageMaker Model Storage"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}