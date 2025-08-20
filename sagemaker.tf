resource "aws_sagemaker_notebook_instance" "ml_notebook" {
    name = "my-ml-notebook"
    role_arn = aws_iam_role.sagemaker_role.arn
    instance_type = "ml.t2.medium"

    tags = {
        Name = "ML Development Notebook"
    }
}

resource "aws_sagemaker_model" "ml_model" {
    name = "my-ml-model"
    execution_role_arn = aws_iam_role.sagemaker_role.arn

    primary_container {
        image =  414097320818.dkr.ecr.us-east-1.amazonaws.com/my-sagemaker-model
        model_data_url = "s3://${aws_s3_bucket.ml_models.bucket}/model.tar.gz"
        
    }
}