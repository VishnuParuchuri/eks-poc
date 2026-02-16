# ----------------------------------------
# CloudWatch Log Group for VPC Flow Logs
# ----------------------------------------
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 7
}

# ----------------------------------------
# IAM Role for VPC Flow Logs
# ----------------------------------------
resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

# ----------------------------------------
# Attach Correct Policy to IAM Role
# ----------------------------------------
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_attach" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforVPCFlowLogs"
}

# ----------------------------------------
# VPC Flow Log
# ----------------------------------------
resource "aws_flow_log" "vpc" {
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.vpc_flow_logs.name
  iam_role_arn         = aws_iam_role.vpc_flow_logs.arn

  depends_on = [
    aws_cloudwatch_log_group.vpc_flow_logs,
    aws_iam_role_policy_attachment.vpc_flow_logs_attach
  ]
}
