# https://www.linkedin.com/pulse/aws-secrets-manager-terraform-tutorial-examples-dopplerhq-x0bge

# resource "aws_secretsmanager_secret" "db_password" {
#   name = "${var.project_prefix}/${var.env_prefix}/mysql/password"
# }

# resource "aws_secretsmanager_secret_version" "db_password_version" {
#   secret_id = aws_secretsmanager_secret.db_password.id
#   secret_string = var.mysql_root_pass
# }

# data "aws_secretsmanager_secret" "db_password" {
#   name = "${var.project_prefix}/${var.env_prefix}/mysql/password" # nat_mysql/dev/mysql/password
# }

# data "aws_secretsmanager_secret_version" "db_password_version" {
#   secret_id = data.aws_secretsmanager_secret.db_password.id
# }