terraform {
  backend "s3" {
    bucket = "samjayu-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terradynamodb" #dynomodblock-old version
    #use_lockfile = true // new version
    encrypt = true
    
  }
}