terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_iam_user" "user" {
  
  name = "test_user"
  path = "/"
}

resource "aws_iam_access_key" "new_user" {
  
  user    = aws_iam_user.user.name
}

resource "aws_iam_policy" "policy" {
  
  name        = "test_policy"
  path        = "/"
  description = "This policy having access to ec2, lambda and notification service"

  policy = jsonencode({
    
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]

  })
}


resource "aws_iam_policy_attachment" "attach-policy" {
  
  name       = "test-policy-attachment"
  users      = [aws_iam_user.user.name]
  policy_arn = aws_iam_policy.policy.arn
}

