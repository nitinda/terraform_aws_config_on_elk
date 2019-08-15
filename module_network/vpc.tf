
resource "aws_vpc" "demo_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-vpc",
  ))}"
}

resource "aws_subnet" "demo_subnet_public" {
  count             = 2
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "172.16.${count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.demo_available.names[count.index]}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-subnet-public-${count.index}",
  ))}"
}

resource "aws_subnet" "demo_subnet_private" {
  count             = 2
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "172.16.${count.index+2}.0/24"
  availability_zone = "${data.aws_availability_zones.demo_available.names[count.index]}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-subnet-private-${count.index}",
  ))}"
}

resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-internet-gateway",
  ))}"
}

resource "aws_eip" "demo_eip" {
  count = 2
  vpc = true

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-eip-${count.index}",
  ))}"
}

resource "aws_nat_gateway" "demo_nat_gateway" {
  count = 2
  allocation_id = "${aws_eip.demo_eip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.demo_subnet_public.*.id[count.index]}"
  depends_on    = ["aws_internet_gateway.demo_internet_gateway"]

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-nat-gateway-${count.index}",
  ))}"
}

# Route Tables and Routes

resource "aws_route_table" "demo_route_table_public" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo_internet_gateway.id}"
  }

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-route-table-public",
  ))}"
}

resource "aws_route_table_association" "demo_route_table_association_public" {
  count          = 2
  subnet_id      = "${element(aws_subnet.demo_subnet_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_route_table_public.id}"
}

resource "aws_route_table" "demo_route_table_private" {
  count  = 2
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-route-table-private-${count.index}",
  ))}"
}

resource "aws_route_table_association" "demo_route_table_association_private" {
  count          = 2
  subnet_id      = "${element(aws_subnet.demo_subnet_private.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_route_table_private.*.id[count.index]}"
}

resource "aws_route" "demo_private_routes_nat" {
  count                  = 2
  route_table_id         = "${aws_route_table.demo_route_table_private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.demo_nat_gateway.*.id[count.index]}"
  depends_on             = ["aws_route_table.demo_route_table_private"]
}