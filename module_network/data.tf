data "aws_availability_zones" "demo_available" {}

provider "http" {}

data "http" "demo_workstation_external_ip" {
  url = "http://icanhazip.com"
}