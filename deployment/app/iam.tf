#
# Instance profiles
#
resource "aws_iam_instance_profile" "custom_profile" {
  depends_on = ["aws_iam_role.custom_role"]
  name = "tf-custom-profile-${var.environment}-${module.ec2_bootstrap_deployment.this_instance_name}"
  role = "${aws_iam_role.custom_role.name}"
}
#
# IAM roles
#
resource "aws_iam_role" "custom_role" {
  name = "tf-role-${module.ec2_bootstrap_deployment.this_instance_name}"
  assume_role_policy = "${data.template_file.assume_policy.rendered}"
}

#
# IAM policies
# 
resource "aws_iam_policy" "policy_cloudwatch" {
  name = "policy-${var.environment}-${module.ec2_bootstrap_deployment.this_instance_name}-cloudwatch"
  description = "iam policy for cloudwatch access"
  policy = "${data.template_file.policy_cloudwatch.rendered}"
}

resource "aws_iam_policy" "policy_s3_bucket" {
  name = "policy-${var.environment}-${module.ec2_bootstrap_deployment.this_instance_name}-s3"
  description = "iam policy for s3 buckket acces"
  policy = "${data.template_file.policy_s3_bucket.rendered}"
}

resource "aws_iam_policy_attachment" "tf_custom_attachment_s3" {
  name = "custom-policy-${var.environment}-${module.ec2_bootstrap_deployment.this_instance_name}-s3"
  roles = ["${aws_iam_role.custom_role.name}"]
  policy_arn = "${aws_iam_policy.policy_s3_bucket.arn}"
}

resource "aws_iam_policy_attachment" "tf_custom_attachment_cloudwatch" {
  name = "custom-policy-${var.environment}-${module.ec2_bootstrap_deployment.this_instance_name}-cloudwatch"
  roles = ["${aws_iam_role.custom_role.name}"]
  policy_arn = "${aws_iam_policy.policy_cloudwatch.arn}"
}