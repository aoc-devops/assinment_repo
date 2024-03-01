terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
resource "aws_instance" "test_instance" {
  count = 10
  ami           = "ami-0f9c44e98edf38a2b"
  instance_type = var.instance
  monitoring             = true
  vpc_security_group_ids = var.sg
  subnet_id              = var.subnet

  tags = {
    By_Terraform   = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# resource "null_resource" "terminate_instances" {

#   count = length(aws_instance.test_instance)

#   provisioner "local-exec" {
#     command = "aws ec2 terminate-instances --instance-ids ${element(aws_instance.test_instance.*.id, count.index)}"
#   }
# }