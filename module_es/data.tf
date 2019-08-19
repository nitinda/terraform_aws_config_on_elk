
data "http" "demo_workstation_external_ip" {
  url = "http://icanhazip.com"
}

locals {
  workstation_external_cidr = "${chomp(data.http.demo_workstation_external_ip.body)}/32"
}
