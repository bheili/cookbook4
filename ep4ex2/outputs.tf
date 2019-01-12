# Outputs from the overall configuration
output "elb_address" {
  value = "${aws_elb.web-lb.dns_name}"
}

output "addresses" {
  value = "${aws_instance.web.*.public_ip}"
}
