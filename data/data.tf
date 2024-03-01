

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami" {
    value = "${data.aws_ami.windows}"
}

data "aws_iam_role" "example" {
  name = "terraform_provider_access"
}

output "test_role1" {
  value = data.aws_iam_role.example
}