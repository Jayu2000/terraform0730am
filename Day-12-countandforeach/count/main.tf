variable "env" {
  type    = list(string)
  default = ["dev", "prod"]

}

resource "aws_instance" "name" {
  ami           = "ami-05ffe3c48a9991133"
  instance_type = "t2.micro"
  count         = length(var.env)
  tags = {
    Name = var.env[count.index]
  }

}

#as we most of this is not recommended 
#for creation of resource as we use this but not for deletion
#while creating time the sequence start from 0 1 2 but while deleting time sequence is 2 1 0

#test - i-031eecaec0167ae93
#dev- i-0c45fada941a138da
#prod - i-0a23aba4aed39ccb7


#prod -i-031eecaec0167ae93
#dev -i-0c45fada941a138da

#as in above code when we remove test environment on that time test will remove but actually prod is delete as just its rename the name 
# default = ["dev", "test", "prod"]