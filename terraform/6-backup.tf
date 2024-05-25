# # Backup Vault
# resource "aws_backup_vault" "this" {
#   name = "example-vault"
# }

# # Backup Plan - Schedule
# resource "aws_backup_plan" "this" {
#   name = "example-plan"

#   rule {
#     rule_name         = "example-rule"
#     target_vault_name = aws_backup_vault.this.name
#     schedule          = "cron(0 12 * * ? *)" # min, hour, day of month, month, day of week, year

#     lifecycle {
#       delete_after = 14
#     }
#   }
# }

# # Backup Selection - Choose Resources to Backup
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["backup.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }
# resource "aws_iam_role" "example" {
#   name               = "example"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "example" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
#   role       = aws_iam_role.example.name
# }

# resource "aws_backup_selection" "example" {
#   name         = "tf_example_backup_selection"
#   iam_role_arn = aws_iam_role.example.arn
#   plan_id = aws_backup_plan.this.id

#   resources = [
#     aws_instance.vm_1.arn
#   ]
# }