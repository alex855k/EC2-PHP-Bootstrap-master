#
# AWS cloudwatch configuration files
#
data "template_file" "awscreds" {
  template            = "${file("./app_files/configs/awscreds.conf")}"
  vars{
      access_key = "${var.access_key}"
      secret_key = "${var.secret_key}"
  }
}

data "template_file" "awscli" {
  template = "${file("./app_files/configs/awscli.conf")}"
  vars {
    region = "${var.region}"
  }
}

data "template_file" "cloudwatch_config" {
  template            = "${file("./app_files/configs/cloudwatch.cfg")}" 
  vars {
    log_group_name = "${module.ec2_bootstrap_deployment.this_instance_name}-${var.environment}-${var.version}-logs"
  }
}
#
# User data/Cloudinit
#

data "template_file" "shell-script" {
  template = "${file("./app_files/user-data/user-data.sh")}"
  vars {
    file = "${var.deployfileuri}"
  }
}

data "template_file" "init-script" {
  template = "${file("./app_files/configs/init.cfg")}"
  vars {
    awscli = "${data.template_file.awscli.rendered}"
    cloudwatch = "${data.template_file.cloudwatch_config.rendered}"
    awscreds = "${data.template_file.awscreds.rendered}"
  }
}

data "template_cloudinit_config" "cloudinit" {
  gzip = false
  base64_encode = false
  part {
    filename = "init.cfg"
    content_type = "text/cloud-config"
    content = "${data.template_file.init-script.rendered}"
  }
  part {
    filename = "user-data.sh"
    content_type = "text/x-shellscript"
    content = "${data.template_file.shell-script.rendered}"
  }
}

data "template_file" "policy_s3_bucket" {
  template = "${file("./app_files/policies/policy-s3-bucket.json")}"
  vars {
    environment = "${var.environment}"
  }
}
data "template_file" "policy_cloudwatch" {
  template = "${file("./app_files/policies/policy-cloudwatch.json")}"
}
data "template_file" "assume_policy" {
  template = "${file("./app_files/policies/assume-role-policy.json")}"
}

#
# Identities/Accounts
#
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}
