# Elastic Container Registry Definition
resource "aws_ecr_repository" "demo-repo" {
  name                 = "demo-repository"
  image_tag_mutability = "MUTABLE"
  tags                 = merge(var.ProjectTags, { Name = "${var.ecsNameTag}-Registry" }, )

  image_scanning_configuration {
    scan_on_push = false
  }
}

# ECR Lifecycle Policy
# Keep two copies of any given image with the tag prefix "flask-demo-"
resource "aws_ecr_lifecycle_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.demo-repo.name

  policy = <<EOF
  {
    "rules": [
      {
        "action": {
          "type": "expire"
        },
        "selection": {
          "countType": "imageCountMoreThan",
          "countNumber": 2,
          "tagStatus": "tagged",
          "tagPrefixList": [
            "fastapi_demo-"
          ]
        },
        "description": "Keep last 2 flask-demo images ",
        "rulePriority": 1
      }
    ]
  }
      EOF
}