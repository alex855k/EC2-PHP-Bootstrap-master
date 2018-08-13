#
# Remote backend state
#

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "mono-deployment-dev"
    key = "ec2-bootstrap/infrastructure/alb/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
 backend "s3" {
    bucket = "mono-deployment-dev"
    key = "ec2-bootstrap/infrastructure/alb/terraform.tfstate"
    region = "us-east-1"
 }
}

provider "aws" {
  region = "${var.region}"
}

module "test_ec2-bootstrap_alb" {
  source = "git@github.com:monosolutions/terraform-mono-alb.git"
  vpc_id = "${var.vpc_id}"
  environment = "${var.environment}"
  alb_name = "${var.name}"
  alb_subnets = "${var.alb_subnets}"
  ingress = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_count = 1
  egress = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_count = 1
}