#Application Load Balancer (ALB): Internet > fastapi-Demo ECS
resource "aws_lb" "fastapi-demo-alb" {
  name               = "fastapi-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fastapi-demo-sg.id]
  subnets            = [aws_subnet.public_a[0].id, aws_subnet.public_a[1].id]

  #   enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-alb" }, )
  
}

#ALB Target
resource "aws_lb_target_group" "fastapi-demo-tg" {
  name        = "fastapi-demo-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_a.id
  target_type = "ip"

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-tg" }, )

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

#ALB Listener
resource "aws_lb_listener" "fastapi-demo-front_end" {
  load_balancer_arn = aws_lb.fastapi-demo-alb.id
  port              = var.app_port
  protocol          = "HTTP"

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-listener" }, )

  default_action {
    target_group_arn = aws_lb_target_group.fastapi-demo-tg.id
    type             = "forward"
  }
}