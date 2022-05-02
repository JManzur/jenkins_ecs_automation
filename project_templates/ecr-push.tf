# Equivalent to 'aws ecr get-login'
data "aws_ecr_authorization_token" "ecr_token" {
}

# Calculate hash of the Docker image source contents
data "external" "hash" {
  program = [coalesce("scripts/hash.sh"), "fastapi_demo"]
}

# Capture correct timestamp from bash file - used instead of terraform timestamp()
data "external" "time_stamp" {
  program = [coalesce("scripts/time_stamp.sh")]
}

# Make a "docker build" and "docker push" if the hash of the Dockerfile directory change.
resource "null_resource" "push" {
  triggers = {
    hash = data.external.hash.result["hash"]
  }

  provisioner "local-exec" {
    command = "echo ${data.aws_ecr_authorization_token.ecr_token.password}"
  }

  provisioner "local-exec" {
    #{push.sh} {AWSRegion} {AWSProfile} {SOURCE_CODE} {ECR_URL} {IMAGE_TAG}
    command     = "${coalesce("scripts/push.sh")} ${var.aws_region["virginia"]} ${var.aws_profile} fastapi_demo ${aws_ecr_repository.demo-repo.repository_url} fastapi_demo-${data.external.time_stamp.result["time_stamp"]}"
    interpreter = ["bash", "-c"]
  }
}