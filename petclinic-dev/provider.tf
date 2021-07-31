# terraform {
#   required_providers {
#       aws = {
#       source = "hashicorp/aws"
#       version = "3.51.0"
#       region =  "ap-south-1"
#     }
#   }
# }


provider "aws" {
  #profile = "default"
  region = "ap-south-1"
  
  }

