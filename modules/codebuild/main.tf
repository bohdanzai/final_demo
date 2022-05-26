data "aws_region" "current" {}

data "aws_ssm_parameter" "github_token" {
  name = "github_token"
}

output "token"{
    value = data.aws_ssm_parameter.github_token.value
    sensitive = true
}

resource "null_resource" "import_source_credentials" {
  triggers = {
    github_oauth_token = data.aws_ssm_parameter.github_token.value
  }
  provisioner "local-exec" {
    command = <<EOF
      aws --region ${data.aws_region.current.name} codebuild import-source-credentials \
                                                             --token ${data.aws_ssm_parameter.github_token.value} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

resource "aws_codebuild_project" "project" {
  depends_on    = [null_resource.import_source_credentials]
  name          = local.codebuild_project_name
  description   = local.description
  build_timeout = "120"
  service_role  = aws_iam_role.role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true //allows to start Docker

    environment_variable {
      name  = "CI"
      value = "true"
    }
  }
  source {
    buildspec           = var.build_spec_file
    type                = "GITHUB"
    location            = var.repo_url
    git_clone_depth     = 1
    report_build_status = "true"
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }
}
resource "aws_codebuild_webhook" "develop_webhook" {
  project_name = aws_codebuild_project.project.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.git_trigger_event
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.branch_pattern
    }
  }
}
