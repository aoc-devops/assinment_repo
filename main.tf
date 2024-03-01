terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [ aws.new_user ]
    }
  }
}
provider "aws" {

  region = "us-east-1"

}

provider "aws" {
  alias      = "new_user"
  region     = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::199360086209:role/terraform_provider_access"
    # role_arn = "${module.data.test_role1}"
  }
  
  
}

module "iam" {
  source = "./iam"
  
  
}
module "data" {
  source = "./data"
  
}

module "ec2_instance" {
  source  = "./ec2"
  providers = {
  aws = aws.new_user
  }
}

module "lambda" {
  source = "./lambda"
  providers = {
  aws = aws.new_user
  }
  
}
