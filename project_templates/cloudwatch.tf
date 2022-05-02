##CloudWatch log group [30 days retention]
resource "aws_cloudwatch_log_group" "fd-log_group" {
  name              = "FastAPI_Logs"
  retention_in_days = 30

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-cw-logs" }, )
}

##CloudWatch log stream 
resource "aws_cloudwatch_log_stream" "fd_log_stream" {
  name           = "FastAPI_Stream"
  log_group_name = aws_cloudwatch_log_group.fd-log_group.name
}