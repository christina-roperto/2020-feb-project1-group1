terraform {
  backend "s3" {
    bucket = "bucketname"
    key    = "wdpress/terraform.tfstate"
    region = "ap-southeast-2"
  }
}