resource "aws_lb_target_group" "tg_med" {
  name        = "TG-${var.projectName}"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = data.aws_vpc.existing_vpcs.id

  health_check {
    path    = "//swagger-ui/index.html"
    port    = 8080
    matcher = "200,301"
  }
}