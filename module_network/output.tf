output "demo_subnet_private" {
  value = "${aws_subnet.demo_subnet_private.*.id}"
}

output "demo_subnet_public" {
  value = "${aws_subnet.demo_subnet_public.*.id}"
}

output "demo_vpc_cidr" {
  value = "${aws_vpc.demo_vpc.cidr_block}"
}

output "demo_security_group" {
  value = "${aws_security_group.demo_security_group.id}"
}

output "demo_vpc_id" {
  value = "${aws_vpc.demo_vpc.id}"
}