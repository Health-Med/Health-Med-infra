resource "aws_service_discovery_private_dns_namespace" "private" {
  name        = var.domain_name
  description = "Private dns namespace for service discovery"
  vpc         = data.aws_vpc.existing_vpcs.id
}

resource "aws_service_discovery_service" "this" {
  name = "service_discovery_service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 10
  }
}
