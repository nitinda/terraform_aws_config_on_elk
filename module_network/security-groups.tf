resource "aws_security_group" "demo_security_group" {
  name        = "terraform-demo-es-security-group"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_vpc.demo_vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["${local.workstation_external_cidr}","${aws_vpc.demo_vpc.cidr_block}","0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${aws_vpc.demo_vpc.cidr_block}","${local.workstation_external_cidr}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-es-security-group",
  ))}"
}
