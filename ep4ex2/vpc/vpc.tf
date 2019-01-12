resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    name = "${var.name}"
  }
}

resource "aws_internet_gateway" "appigwy" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    name = "${var.name}-igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.appigwy.id}"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_subnet}"

  tags {
    name = "${var.name}-public"
  }
}

# Outputs for use by other modules

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr" {
  value = "${var.cidr}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.id}"
}

/* delete if not used
resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}
*/

