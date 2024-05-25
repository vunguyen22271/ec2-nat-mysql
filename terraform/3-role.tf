# Get the secret from AWS Secrets Manager using the IAM role.
resource "aws_iam_policy" "get_secret_policy" {
  name        = "${var.project_prefix}_${var.env_prefix}_get_secret_policy"
  description = "Custom policy for EC2 instances"

  policy      = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:${var.project_prefix}/${var.env_prefix}/mysql/password-*",
    }
  ]
}
)
}

# Create an IAM role for EC2 instances
resource "aws_iam_role" "role" {
  name = "${var.project_prefix}_${var.env_prefix}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  managed_policy_arns = [
    aws_iam_policy.get_secret_policy.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}


# https://skundunotes.com/2023/08/27/provision-an-amazon-ec2-instance-with-session-manager-access-using-terraform/
# resource "aws_iam_role_policy_attachment" "attachment-2" {
#   role       = aws_iam_role.role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# Create an instance profile
resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_prefix}_${var.env_prefix}_profile"
  role = aws_iam_role.role.name
}
