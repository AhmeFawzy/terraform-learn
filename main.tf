provider "aws" {
    region = "us-east-1"
    #access_key = "AKIAV6TNO4KJMB7SJUSH"  this should not be hardcorded
    #secret_key = "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"  this should not be hardcorded
}

variable "subnet_cidr_block" {

    description = "subnet cidr block"
    default = "10.0.10.0/24" #the default value will be used in case the custom value for the variable not found in the variable file or in the block below or defined in the command line parameter (understand?)
    type = string            # in most cases you will not have to define a type for the varible but it is rarly used 
}   
# if you left the variable without a type the user can put any type they want
variable "cidr_blocks" {
    description ="cidr blocks for vpc and subnet"
    type = list (object({
        cidr_block = string
        name = string
    }))
}

variable "vpc_cidr_block" {

    description = "vpc cidr block"
}

variable "environment" {

    description = "deployment environment"
}

variable vail_zone {}

resource "aws_vpc" "development-vpc" {

    cidr_block = var.vpc_cidr_block  #or cidr_blocks =var.cidr_blocks[0].cidr_block
    tags = {
        Name: "development"  # or you can access it by cidr_blocks variable var.cidr_blocks[0].name
        vpc_env: "dev"
    }
}
#terraform destroy -target aws_sybnet.dev-sybnet-2 >> to delete the next resource
resource "aws_subnet" "dev-subnet-1" {
#subnet belongs to a vpc so you shuold specify to which one it belongs
    
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = "10.0.10.0/24"     #or   cidr_block = var.subnet_cider_block >> the variable that we defined  #or cidr_blocks =var.cidr_blocks[1].cidr_block
    availability_zone = "us-east-1a"
    tags = {
        Name: "subnet-1-dev" #you can access it by cidr_blocks variable var.cidr_blocks[1].name
    }
} 

data "aws_vpc" "existing_vpc" {
    default = true 
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.160.0/20"
    availability_zone = "us-east-1a"  #or var.avail_zone but first you need to run and save your custom env of variable export TF_VAR_avail_zone="eu-west-3a"
    tags = {
        Name: "subnet-2-default"
    }
}

output "dev-vpc-id" {
   value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
   value = aws_subnet.dev-subnet-1.id
}

