##CloudWatch log group [30 days retention]
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "VPCFlowLogs"
  retention_in_days = 30

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-VPC-Logs" }, )
}