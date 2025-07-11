terraform {
  backend "s3" {
    bucket = "samjayu-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
