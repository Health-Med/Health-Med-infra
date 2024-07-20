//task para med
resource "aws_ecs_task_definition" "task_med" {
  family = "TSK-${var.projectName}"
  container_definitions = jsonencode([
    {
      name      = "${var.project_name_healthmed}"
      essential = true,
      image     = "${aws_ecr_repository.repository_med.repository_url}:latest",
      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "production"
        },
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:mysql://${data.aws_db_instance.database.endpoint}/dbhealthmed?useSSL=false&useTimezone=true&serverTimezone=UTC"
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = "${var.rdsUser}"
        },
        {
          name  = "SPRING_DATASOURCE_PASSWORD"
          value = "${var.rdsPass}"
        },
        {
          name  = "SPRING_JPA_GENERATE_DDL"
          value = "true"
        },
        {
          name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
          value = "update"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.cloudwatch-log-group.name}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  # execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  # execution_role_arn = "arn:aws:iam::${var.AWSAccount}:role/ecsTaskExecutionRole"
  # execution_role_arn = "arn:aws:iam::${var.AWSAccount}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/healthmedSystemServiceRoleForECS"

  memory = "4096"
  cpu    = "2048"

  # depends_on = [
  #   data.aws_iam_role.ecs_task_execution_role
  # ]
}