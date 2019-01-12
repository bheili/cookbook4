/* Our second example
Includes multiple instances
plus load balancer */

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "vpc" {
  source        = "./vpc"
  name          = "app-vpc"
  cidr          = "10.0.0.0/16"
  public_subnet = "10.0.1.0/24"
}

module "securitygroups" {
  source = "./securitygroups"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${module.vpc.cidr}"
}

resource "aws_instance" "web" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_id}"
  private_ip                  = "${var.instance_ips[count.index]}"
  user_data                   = "${file("init/userdata.sh")}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${module.securitygroups.web_host_sg.id}",
  ]

  tags {
    name = "web-${format("%03d", count.index + 1)}"
  }

  count = "${length(var.instance_ips)}"
}

resource "aws_elb" "web-lb" {
  name = "web-elb"

  subnets         = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${module.securitygroups.web_inbound_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # The instances are registered automatically
  instances = ["${aws_instance.web.*.id}"]
}
