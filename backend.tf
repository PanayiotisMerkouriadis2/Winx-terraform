terraform {
  backend "s3" {
    bucket         = "winx-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "winx-terraform-locks"
    encrypt        = true
  }
}