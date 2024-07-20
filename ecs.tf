resource "aws_ecs_service" "service_med" {
  name            = "SVC-${var.project_name_healthmed}"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_med.arn

  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = ["${data.aws_subnet.existing_subnet1.id}", "${data.aws_subnet.existing_subnet2.id}", "${data.aws_subnet.existing_subnet3.id}", "${data.aws_subnet.existing_subnet4.id}"]
    security_groups  = ["${data.terraform_remote_state.other_repo.outputs.public_subnet_sg_id}"]
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 240

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_med.arn
    container_name   = var.project_name_healthmed
    container_port   = 8080
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_lb.alb]
}
