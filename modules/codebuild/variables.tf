variable "aws_region" {}

variable "remote_state_bucket" {}

variable "branch_pattern" {}

variable "git_trigger_event" {}

variable "repo_url" {
  description = "URL to Github repository"
}

variable "environment" {
  type = string
}

variable "app_name" {
  type = string
}

variable "build_spec_file" {
  default = "buildspec.yml"
}

variable "vpc_id" {
  type        = string
  default     = null
}

variable "subnets" {
  type        = list(string)
  default     = null
}

variable "security_groups" {
  type        = list(string)
  default     = null
}

locals {
  codebuild_project_name = "${var.app_name}-${var.environment}"
  description            = "Codebuild for ${var.app_name} environment ${var.environment}"
}
