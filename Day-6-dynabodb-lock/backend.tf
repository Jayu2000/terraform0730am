terraform {
  backend "s3" {
    bucket = "samjayu-bucket"
    key = "terraform.tfstate"
    dynamodb_table = "terradynamodb"
    region = "us-east-1"
    encrypt = true
    
  }
}