output "ecs-service-name-med" {
  value = aws_ecs_service.service_med.name
}

output "ecr-repository-med" {
  value = aws_ecr_repository.repository_med.name
}

output "ecr-repository-order-url" {
  value = aws_ecr_repository.repository_med.repository_url
}
#
# # Saída para exibir a URL das filas SQS criadas
# output "order_paid_queue" {
#   value = aws_sqs_queue.order_paid_queue.id
# }
#
# output "order_in_production_queue" {
#   value = aws_sqs_queue.order_in_production_queue.id
# }
#
# output "order_produced_queue" {
#   value = aws_sqs_queue.order_produced_queue.id
# }
#
# output "order_delivering_queue" {
#   value = aws_sqs_queue.order_delivering_queue.id
# }
#
# output "order_delivered_queue" {
#   value = aws_sqs_queue.order_delivered_queue.id
# }
#
# output "order_canceled_queue" {
#   value = aws_sqs_queue.order_canceled_queue.id
# }

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "datasource_url" {
  value = data.aws_db_instance.database.endpoint
}

output "database" {
  value = data.aws_db_instance.database.db_instance_identifier
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}