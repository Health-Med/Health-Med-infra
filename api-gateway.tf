resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.projectName}-api-gateway-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
    # vpc_endpoint_ids = [data.aws_vpc_endpoint.vpc_endpoint.id]
  }
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "healthmed"
      version = "1.0"
    }
    paths = {
      "/orders" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "http://${aws_lb.alb.dns_name}/api/healthmed"
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api" {
  deployment_id = aws_api_gateway_deployment.rest_api.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_method_settings" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
  }
}

# POLICY

resource "aws_iam_role_policy" "ecs_role_policy" {
  name = "ecs_role_api_gateway_access"
  role = aws_iam_role.healthmed_iam_role_for_ecs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "execute-api:Invoke"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.rest_api.id}/prod/GET/*"
      }
    ]
  })
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          "AWS" : "*"
        }
        Action = [
          "execute-api:Invoke"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.rest_api.id}/prod/GET/*"
      }
    ]
  })
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.projectName}-api-gateway-vpc-link"
  target_arns = [aws_lb.nlb.arn]
}
