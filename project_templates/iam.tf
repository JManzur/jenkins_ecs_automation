# ECS IAM Policy Document
data "aws_iam_policy_document" "ecs_policy_source" {
  statement {
    sid    = "TaskExecution"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SSMAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECSGetAppConfig"
    effect = "Allow"
    actions = [
      "appconfig:GetConfiguration",
      "appconfig:StartConfigurationSession",
      "appconfig:GetLatestConfiguration"
    ]
    resources = ["*"]
  }
}

# ECS IAM Role Policy Document
data "aws_iam_policy_document" "ecs_role_source" {
  statement {
    sid    = "ECSAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# ECS IAM Policy
resource "aws_iam_policy" "ecs_policy" {
  name        = "AppConfig_ecs_Policy"
  path        = "/"
  description = "AppConfig POC from ECS"
  policy      = data.aws_iam_policy_document.ecs_policy_source.json
  tags        = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-policy" }, )
}

# ECS IAM Role (ECS Task Execution role)
resource "aws_iam_role" "ecs_policy_role" {
  name               = "ecs_appconfig_policy_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role_source.json
  tags               = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-role" }, )
}

# Attach ecs Role and Policy
resource "aws_iam_role_policy_attachment" "ecs_attach" {
  role       = aws_iam_role.ecs_policy_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}