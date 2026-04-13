terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.40.0"
    }
  }

  backend "s3" {
    bucket = "winx-terraform-state"
    key    = "global/terraform.tfstate"
    region = "eu-west-2"
  }

}
provider "aws" {
  region = eu-west-2
}