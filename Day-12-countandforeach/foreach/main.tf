variable "env" {
  type    = list(string)
  default = ["dev", "prod"]

}

resource "aws_instance" "name" {
  ami           = "ami-05ffe3c48a9991133"
  instance_type = "t2.micro"
  for_each      = toset(var.env)
  #count = length(var.env)   if it is count
  tags = {
    Name = each.value
    #Name = var.env[count.index] if it is count
  }

}

#for_each = toset(var.env)-for a set ,each.value and each.key is the same 

#foreach-

#dev -i-0ed04ac5e94023916
#test - i-0d66c66339ab34157
#prod - i-0bfc3dd49346c5f2f

#dev- i-0ed04ac5e94023916
#prod -i-0bfc3dd49346c5f2f


