variable "region" {
  type = "string"
  description = "AWS region to deploy into"
}

variable "version" {
  type = "string"
  description = "deployment version"
}

variable "environment" {
  type = "string"
  description = "deployment environment"
}

variable "vpc_id" {
  type = "string"
  description = "Id of VPC to deploy to"
}

variable "minimum_instances" {
  type = "string"
  description = "minimum number of instances to be deployed for autoscaling group"
  default = "1"
}

variable "instance_type" {
  type = "string"
  description = "instance type to deploy"
}

variable "alb_sg" {
  type = "string"
  description = "Security group id of ALB to connect to"
}

variable "alb_arn" {
  type = "string"
  description = "ARN of ALB to connect to"
}

variable "private_sns" {
  type = "list"
  description = "list of private subnets to deploy to"
}

variable "deployfileuri" {
  type = "string"
  description = "full uri of Artifact to be used by user-data"
}

variable "access_key" {
  type = "string"
  description = "aws access key id"
}

variable "secret_key" {
  type = "string"
  description = "aws secret access key"
}