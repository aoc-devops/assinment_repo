terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
# Create a lambda function to stop EC2 instances
resource "aws_lambda_function" "stop_ec2_instances" {
  filename         = "${path.module}/ec2-instances-stop-region.zip"  # Path to your lambda function code
  function_name    = "stopEC2Instances"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  #  source_code_hash = filebase64sha256("ec2-instances-stop-region.zip")
  runtime          = "python3.8"
}

# Create an IAM role for lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach necessary permissions to the lambda execution role
resource "aws_iam_policy_attachment" "lambda_execution_policy_attachment" {
  name       = "lambda_execution_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_lambda_permission" "invoke_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "StopEC2Schedule"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = aws_lambda_function.stop_ec2_instances.function_name
  arn       = aws_lambda_function.stop_ec2_instances.arn
}

