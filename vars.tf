variable "projectName" {
  default = "healthmed"
}

variable "clusterName" {
  default = "healthmed"
}

variable "regionDefault" {
  default = "us-east-1"
}

variable "vpcCIDR" {
  default = "172.31.0.0/20"
}

variable "rdsUser" {
  description = "Inserir usuario do banco em secrets"
  type        = string
  sensitive   = true
}

variable "rdsPass" {
  description = "Inserir senha do banco em secrets"
  type        = string
  sensitive   = true
}

variable "project_name_healthmed" {
  description = "Nome do projeto. Por exemplo, 'bluesburguer'."
  default     = "healthmed"
  type        = string
}

variable "project_name_med-rds" {
  description = "Nome do projeto. Por exemplo, 'bluesburguer'."
  default     = "rds-dbhealthmed"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    App      = "healthmed",
    Ambiente = "Desenvolvimento"
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  default = "sua_access_key"
}

variable "aws_secret_key" {
  default = "sua_secret_key"
}

variable "domain_name" {
  description = "Inserir aws secret key"
  type        = string
  default     = "bluesburguer.terraform.com"
}

# variable "github_repo_url" {
#   default = "https://github.com/bluesburger/orderingsystem-production"
# }


locals {
  tags = {
    created_by = "terraform"
  }

  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}