variable "vpc_cidr" {
  default = "10.0.0.0/16"
}


variable "aws_region" {
  default = "eu-north-1"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"   
}

variable "privatesubnet_cidr" {
  default = "10.0.2.0/24"   
}

variable "availability_zone" {
    default = "eu-north-1a"
}

variable "route_cidr" {
  default = "0.0.0.0/0"
}

variable "ec2_ami" {
  default = "ami-042b4708b1d05f512"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key1" {
  default = "gns3s"

}
