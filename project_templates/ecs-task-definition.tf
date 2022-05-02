# Get Docker Image URI using a local scritp
data "external" "get_image_uri" {
  program = [coalesce("scripts/get_image_uri.sh")]

  depends_on = [
    null_resource.push
  ]
}

#Load the task definition template from a json.tpl file
data "template_file" "fastapi-demo-tpl" {
  template = file("templates/fastapi-demo.json.tpl")

  vars = {
    app_image     = "${data.external.get_image_uri.result["URI"]}"
    aws_region    = var.aws_region["virginia"]
    app_port      = var.app_port
    app_cw_group  = "/FastAPI_Logs"
    app_cw_stream = "FastAPI_Stream"
  }
}

#Task definition
resource "aws_ecs_task_definition" "fastapi-demo-td" {
  family                   = "fastapi-demo-td"
  task_role_arn            = aws_iam_role.ecs_policy_role.arn
  execution_role_arn       = aws_iam_role.ecs_policy_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.fastapi-demo-tpl.rendered

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-task-definition" }, )
}

#Service definition
resource "aws_ecs_service" "fastapi-demo-service" {
  name                   = "fastapi-demo-service"
  cluster                = aws_ecs_cluster.demo-cluster.id
  task_definition        = aws_ecs_task_definition.fastapi-demo-td.arn
  desired_count          = var.app_count
  launch_type            = "FARGATE"
  enable_execute_command = true

  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-fastapi-srv" }, )

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [aws_subnet.private_a[0].id, aws_subnet.private_a[1].id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fastapi-demo-tg.id
    container_name   = "fastapi-demo"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.fastapi-demo-front_end]
}