variable "vpc_cidr" {
  type = string 
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "availabililty_zone_1" {
    type = list(string)
}

variable "public_subnet_names" {
    type = list(string)
}

variable "private_cidr" {
  type  = string
}

variable "availablilty_zone" {
  type = string 
}

variable "ami_id" {
  type = string
}

variable "instance_names" {
  type = list(string)
}