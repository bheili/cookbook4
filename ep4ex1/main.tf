/* Our first example configuration
This is the multi-line comment format */

# Our AWS provider info
provider "aws" {
  access_key = "123"
  secret_key = "456"
  region     = "us-west-2"
}

# Our first resource
resource "aws_instance" "example" {
  ami           = "ami-01bbe152bf19d0289"
  instance_type = "t2.micro"

  tags {
    name = "tfTestInstance"
  }
}
