locals {
  workstation_external_cidr = "${chomp(data.http.demo_workstation_external_ip.body)}/32"
}

locals {
  Project = "ELK POC"
  Owner   = "Platform Team"
  Environment = "prod"
  BusinessUnit = "Platform Team"
}

variable common_tags {
  description = "Reource Tags"
  type = "map"
}