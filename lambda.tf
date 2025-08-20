resource "aws_lambda_function" "inference_lambda" {
    function_name = "sagemaker_inference_handler"
    role = aws_iam_role.lambda_exec.arn
    handler = "index.handler"
    runtime = "python3.8"
    timeout = 30

    filename         = "lambda_function.zip"
    source_code_hash = filebase64sha256("lambda_function.zip")

    environment {
        variables = {
        SAGEMAKER_ENDPOINT = aws_sagemaker_endpoint.model_endpoint.name
    }
  }
}

resource "aws_iam_role" "lambda_exec"{
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }] 
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic"{
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sagemaker_invoke" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}