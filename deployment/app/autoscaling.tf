provider "aws" { 
  region      = "${var.region}"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "mono-terraform-state-dev"
    key = "ec2-bootstrap/terraform.tfstate"
    region = "eu-central-1"
  }
}

terraform {
 backend "s3" {
    bucket = "mono-terraform-state-dev"
    key = "ec2-bootstrap/terraform.tfstate"
    region = "eu-central-1"
    workspace_key_prefix = "ec2-bootstrap"
 }
}

module "ec2_bootstrap_deployment" {
  source = "git@github.com:monosolutions/terraform-mono-instance.git"
  vpc_id = "${var.vpc_id}"
  vpc_zone_identifiers = "${var.private_sns}"
  alb_arn = "${var.alb_arn}"
  alb_healthcheck_interval = "60"
  alb_healthcheck_path = "/health_check"
  alb_healthcheck_port = "81"
  alb_healthcheck_matcher = "200"
  autoscaling_min_size = "${var.minimum_instances}"
  launchconfiguration_instance_type = "${var.instance_type}"
  environment = "${var.environment}"
  rules_ingress_security_group = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      source_security_group = "${var.alb_sg}"
    },
    {
      from_port = 80
      to_port = 81
      protocol = "tcp"
      source_security_group = "${var.alb_sg}"
    }
  ]
  count_ingress_security_group = 2
  rules_egress_cidr = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  instance_name = "ec2-bootstrap"
  instance_version = "${var.version}"
  aws_pub_key_path = "./app_files/certs/id_rsa.pub"
  full_cloudinit_file = "${data.template_cloudinit_config.cloudinit.rendered}"
  predefined_iam_instance_profile = "${aws_iam_instance_profile.custom_profile.name}"
}