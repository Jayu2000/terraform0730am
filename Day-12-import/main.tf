resource "aws_instance" "name" {
    ami = "ami-0cbbe2c6a1bb2ad63"
    instance_type = "t2.micro"
    tags = {
      Name = "jayu"
    }

}











#(terraform import aws_instance.name i-088f1cdceee662d00)---this is command 
#terraform init after that run import command
#1st step-prepare empty resource block after that run terraform init and import commands

#resource "aws_instance" "name" {
  
#}
#-add resource block till no changes is there while run the terraform plan after that run terraform apply
#Apply complete! Resources: 0 added, 0 changed, 0 destroyed. ---
#Terraform import its just like give manually created resources control to terraform

