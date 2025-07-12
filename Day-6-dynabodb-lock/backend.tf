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


#there is two type of lock file s3+dynomodb is old version and only s3 is new version

#dynomodblock-old version :-
#Below are command for old version:-
# dynamodb_table = "terradynamodb"
# encrypt = true

#below command for new version
#use_lockfile = true 

#due to lock feature -two developer not able to do apply at same time
#as getting error ("error aquiring the state lock")
#as in code i mentioned backend "s3" its mean statefile automatically store into s3 bucket for our safety
