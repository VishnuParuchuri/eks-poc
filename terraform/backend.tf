terraform {
  backend "s3" {
    bucket         = "vishnu-eks-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}
