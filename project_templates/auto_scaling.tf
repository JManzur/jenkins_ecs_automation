#Auto scaling target definition
resource "aws_appautoscaling_target" "fastapi-target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.demo-cluster.name}/${aws_ecs_service.fastapi-demo-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 3
  max_capacity       = 6
}

#Auto scaling policy [scale capacity UP by one]
resource "aws_appautoscaling_policy" "fastapi_demo_scale_up" {
  name               = "fastapi_demo_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.demo-cluster.name}/${aws_ecs_service.fastapi-demo-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.fastapi-target]
}

#Auto scaling policy [scale capacity DOWN by one]
resource "aws_appautoscaling_policy" "fastapi_demo_scale_down" {
  name               = "fastapi_demo_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.demo-cluster.name}/${aws_ecs_service.fastapi-demo-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.fastapi-target]
}

#CloudWatch alarm that triggers the autoscaling UP policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "fastapi_demo_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.demo-cluster.name
    ServiceName = aws_ecs_service.fastapi-demo-service.name
  }

  alarm_actions = [aws_appautoscaling_policy.fastapi_demo_scale_up.arn]
}

#CloudWatch alarm that triggers the autoscaling DOWN policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "fastapi_demo_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    ClusterName = aws_ecs_cluster.demo-cluster.name
    ServiceName = aws_ecs_service.fastapi-demo-service.name
  }

  alarm_actions = [aws_appautoscaling_policy.fastapi_demo_scale_down.arn]
}