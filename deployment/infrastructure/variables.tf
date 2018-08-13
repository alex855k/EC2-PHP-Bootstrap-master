variable "region" {
  type = "string"
  description = "aws region to deploy to"
  default = "eu-central-1"
}

variable "environment" {
  type = "string"
  description = "Deployment environment"
}
variable "name" {
  type = "string"
  description = "name of alb"
  default = "ec2-bootstrap-alb"
}

variable "vpc_id" {
  type = "string"
  description = "VPC id to connect to"
}

variable "alb_subnets" {
  type = "list"
  description = "subnets to forwards traffic to"
}