variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-west-2"
}

variable "key_name" {
  default = "nsx-keypair"
}

variable "ami" {
  # This is Amazon Linux: default = "ami-01bbe152bf19d0289"
  default = "ami-076e276d85f524150" #Ubuntu 16.04
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ips" {
  default = ["10.0.1.11", "10.0.1.12"]
}
