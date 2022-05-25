locals {
  repository_name = format("%s-%s", var.app_name, var.environment)
}

variable "environment" {}

variable "app_name" {}

variable "image_tag" {
  type = string
  #  default = "0.0.1"
}

variable "aws_region" {}

variable "remote_state_bucket" {}

variable "working_dir" {
    type = string
}