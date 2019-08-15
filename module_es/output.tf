output "es_endpoint" {
  value = "${aws_elasticsearch_domain.demo_es_domain.endpoint}"
}

output "kibana_endpoint" {
  value = "${aws_elasticsearch_domain.demo_es_domain.kibana_endpoint}"
}