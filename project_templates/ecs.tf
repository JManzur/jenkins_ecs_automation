# Elastic Container Service Definition
resource "aws_ecs_cluster" "demo-cluster" {
  name               = "demo-cluster"
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
  tags = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-Cluster" }, )
}