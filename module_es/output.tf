output "es_endpoint" {
  value = "${aws_elasticsearch_domain.demo_elasticsearch_domain.endpoint}"
}

output "kibana_endpoint" {
  value = "${aws_elasticsearch_domain.demo_elasticsearch_domain.kibana_endpoint}"
}